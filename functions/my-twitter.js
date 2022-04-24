const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

///CHANGE PROMPTS TO YOUR LIKING
const prompts = [
    'something from a kenyan meme',
    'something from popular meme',
    'something from a popular TV show',
    'Android',
    'iOS',
    'Flutter',
    'React',
    'React Native',
    'Swift',
    'Java',
    'Kotlin',
    'PHP',
    'Python',
    'Laravel',
    'Django',
    'Flutter Web',
    'Node.js',
    'Linked in',
    'Golang',
    'JavaScript',
    'TypeScript',
    'Productivity',
    'Mobile development',
    'Linux',
    'Windows',
    'MacOS',
    'Artificial Intelligence',
    'Machine Learning',
    'Natural Language Processing',
    'Blockchain',
    'Cryptocurrency',
    'Cloud',
    'DevOps',
    'Data Science',
    'Data Structures',
    'Algorithms',
    'Databases',
    'Big Data',
    'Machine Learning',
    'Data Mining',
    'Data Visualization',
    'Data Analysis',
    'Data Engineering',
    'Data Warehousing',
    '@kid_indigoo',
    'My portfolio is https://reubenjefwa.tk',
    'Kubernetes',
    'Docker',
    'AWS',
    'Azure',
    'Google Cloud',
    'Google Cloud Platform',
    'Firebase',
    'Firebase Cloud Functions',
    'Firebase Cloud Storage',
    'Firebase Realtime Database',
    'Firebase Firestore',
    'Firebase Hosting',
    'Firebase Authentication',
    'Firebase Database',
    'Startup',
    'Computer Science',
    'Data Structures',
    'Figma',
    'Adobe XD',
    'Porfolio',
    'Git',
    'Github',
    'Microsoft',
    'Apple',
    'Internship',
    'Job',
    'Job Search',
    'Job Interview',
    'Job Interview Questions',
    'Job Interview Questions and Answers',
    'Venture Capitalism',
    'Student Life',
    'Kenya',
    'Kenya Student',
    '#tech',
    '#100DaysOfCode',
    '#FlutterDevs',
    '#Flutter',
    '#FlutterDev',
    '#NodeJS',
    '#Node',
    'tech joke',
  
  
  ]
  
  
  
  // Database reference
  const dbRef = admin.firestore().doc('myTwitter/username');
  
  // Twitter API init
  const TwitterApi = require('twitter-api-v2').default;
  const twitterClient = new TwitterApi({
    clientId: 'CLIENT ID HERE',
    clientSecret: 'CLIENT SECRET HERE',
  });
  
  const callbackURL = 'https://us-central1-itravel-ecbed.cloudfunctions.net/callback';//Copy Call back URL by running firebase serve
  
  // OpenAI API init
  const { Configuration, OpenAIApi } = require('openai');
  const configuration = new Configuration({
    organization: 'ORGANIZATION HERE',
    apiKey: 'API KEY HERE',
  });
  const openai = new OpenAIApi(configuration);
  
  // STEP 1 - Auth URL
  exports.auth = functions.https.onRequest(async(request, response) => {
    const { url, codeVerifier, state } = twitterClient.generateOAuth2AuthLink(
      callbackURL,
      { scope: ['tweet.read', 'tweet.write', 'users.read', 'offline.access'] }
    );
  
    // store verifier
    await dbRef.set({ codeVerifier, state });
  
    response.redirect(url);
  });
  
  // STEP 2 - Verify callback code, store access_token 
  exports.callback = functions.https.onRequest(async(request, response) => {
    const { state, code } = request.query;
  
    const dbSnapshot = await dbRef.get();
    const { codeVerifier, state: storedState } = dbSnapshot.data();
  
    if (state !== storedState) {
      return response.status(400).send('Stored tokens do not match!');
    }
  
    const {
      client: loggedClient,
      accessToken,
      refreshToken,
    } = await twitterClient.loginWithOAuth2({
      code,
      codeVerifier,
      redirectUri: callbackURL,
    });
  
    await dbRef.set({ accessToken, refreshToken });
  
    const { data } = await loggedClient.v2.me(); // start using the client if you want
  
    // response.send(data);
    response.sendStatus(200);
  });
  
  // STEP 3 - Refresh tokens and post tweets
  exports.tweet = functions.https.onRequest(async(request, response) => {
    const { refreshToken } = (await dbRef.get()).data();
  
    const {
      client: refreshedClient,
      accessToken,
      refreshToken: newRefreshToken,
    } = await twitterClient.refreshOAuth2Token(refreshToken);
  
    await dbRef.set({ accessToken, refreshToken: newRefreshToken });
    console.log('Running!');
  
    const nextTweet = await openai.createCompletion('text-davinci-001', {
      prompt: `tweet something cool for about ${prompts[Math.floor(Math.random() * prompts.length)]} for #techtwitter`,
      max_tokens: 164,
    });
    console.log(nextTweet);
  
    const { data } = await refreshedClient.v2.tweet(
      nextTweet.data.choices[0].text
    );
    console.log(data);
    response.send(data);
  });
  
  
  exports.tweetHourly = functions.pubsub.schedule('*/30 * * * *').onRun(async (context) => { 
    const { refreshToken } = (await dbRef.get()).data();
  
  
    const {
      client: refreshedClient,
      accessToken,
      refreshToken: newRefreshToken,
    } = await twitterClient.refreshOAuth2Token(refreshToken);
  
    await dbRef.set({ accessToken, refreshToken: newRefreshToken });
  
  
    const nextTweet = await openai.createCompletion('text-davinci-001', {
      prompt: `tweet something cool for #techtwitter or ${prompts[Math.floor(Math.random() * prompts.length)]}`,
      max_tokens: 64,
    });
    console.log(nextTweet);
  
    const { data } = await refreshedClient.v2.tweet(
      nextTweet.data.choices[0].text
    );
    console.log(data);
   
  
  });