const functions = require('firebase-functions')
const admin = require('firebase-admin')
const myTwitter = require('./my-twitter')
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
  

