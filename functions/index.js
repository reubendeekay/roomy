const functions = require('firebase-functions')
const admin = require('firebase-admin')
admin.initializeApp()

exports.onUserStatusChange = functions.database
  .ref("/users/{uid}/isOnline")
  .onUpdate(async (change, context) => {
    // Get the data written to Realtime Database
    const isOnline = change.after.val();

    // Get a reference to the Firestore document
    const userStatusFirestoreRef = firestore.doc(`users/${context.params.uid}`);
    
    console.log(`status: ${isOnline}`);

    // Update the values on Firestore
    return userStatusFirestoreRef.update({
      isOnline: isOnline,
      lastSeen: Date.now(),
    });
  });

exports.sendNotification = functions.firestore
  .document('chats/{chatRoom}/messages/{message}')
  .onCreate((snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.sender
    const idTo = doc.to
    const contentMessage = doc.message


    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('userId', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log(`Found user to: ${userTo.data().fullName}`)
         
          // Get info user from (sent)
          admin
            .firestore()
            .collection('users')
            .where('userId', '==', idFrom)
            .get()
            .then(querySnapshot2 => {
              querySnapshot2.forEach(userFrom => {
                console.log(`${userFrom.data().fullName}`)
                const payload = {

                  notification: {
                    id:'/chat-screen',
                    title: `${userFrom.data().fullName}`,
                    body: contentMessage,
                    badge: '1',
                    sound: 'default'
                  },
                  data: {
                    profilePic: userFrom.data().profilePic,
                    
                  }
                }
                // Let push to the target device
                admin
                  .messaging()
                  .sendToDevice(userTo.data().pushToken, payload)
                  .then(response => {
                    console.log('Successfully sent message:', response)
                  })
                  .catch(error => {
                    console.log('Error sending message:', error)
                  })
              })
            })
        })
        
        
      })
    return null
  })

  /////////////////NOTIFICATIONS
exports.sendBookingNotification = functions.firestore.document('userData/bookings/{userId}/{booking}').onCreate(
  (snap, context) => {
    console.log('Send booking function running');
    const doc = snap.data();
    const idTo = doc.ownerId;
    const propertyName = doc.propertyName;
    const numDays = doc.numOfDays;
    const numGuests = doc.numOfGuests;
    const numRooms = doc.numOfRooms;

    admin.firestore().collection('users').where('userId', '==', idTo).get().then(querySnapshot2 => {
      querySnapshot2.forEach(userFrom => {
        console.log(`${propertyName} has been booked for ${numDays}`)
        const payload = {
          notification: {
            title: `${propertyName} has been booked for ${numDays}`,
            body: `You have a new booking for "${propertyName}. The will be ${numGuests} guests booking ${numRooms} room(s). Please respond to it`,
            badge: '1',
            sound: 'default'
          },
          data: {
            profilePic: userFrom.data().profilePic,
            
          }
        }

        admin
          .messaging()
          .sendToDevice(userTo.data().pushToken, payload)
          .then(response => {
            console.log('Successfully sent booking notfication:', response)
          })
          .catch(error => {
            console.log('Error sending notification:', error)
          })
      })
    });
    return null

  }
  
)
  

///////////////////////TWITTER BOT///////////////////////////////////////////////////////////////////

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
const dbRef = admin.firestore().doc('myTwitter/kid_indigoo');

// Twitter API init
const TwitterApi = require('twitter-api-v2').default;
const twitterClient = new TwitterApi({
  clientId: 'cEdTQXUxQ1g1a1BhUnlNVFREUGs6MTpjaQ',
  clientSecret: 'O2_Lf80R9njlDMZ6sVmWZ1VkK3SN-kuGljR1dYNJzWip5JoMV4',
});

const callbackURL = 'https://us-central1-itravel-ecbed.cloudfunctions.net/callback';

// OpenAI API init
const { Configuration, OpenAIApi } = require('openai');
const configuration = new Configuration({
  organization: 'org-RdGFM2Nmd1s9am9d9k6DpFLW',
  apiKey: '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',
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

// AAAAAAAAAAAAAAAAAAAAAI5tYwEAAAAA4EF8cDabizCunnpyKMnJsBR%2BIX8%3Da47xlcxxbAZc8M95sru3YdRZdCukxjoBe6sJmGyIa314ge13BB

// clientId: 'uc2LtRsmvZJskIiwZi6vWQ6s4',
// clientSecret: 'PTGTi5IJL43LqmQZtu50vj64gZXbGebBm9mHfF2DKeeVMZFiEo',