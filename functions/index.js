const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp(functions.config().functions);
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// var newData;

// exports.messageTrigger = functions.firestore.document('chatrooms/{userId}/chats/{chatsId}').onCreate(async (snapshot, context) => {
//     if (snapshot.empty) {
//         console.log('No devices');
//         return;
//     }
//     const hi = admin.firestore().doc(`chatroom/{userId}`);
//     hii = hi.get();

//     console.log(hii.data);
//     newData = snapshot.data;
//     var tokens = ['dj4tfRMbT3KHN8GlkDpajI:APA91bGiFKhGBn8WYL-vObOshrCK6VyB8_HBMWIZn6QRztz_23Par5-OEBSwbNFQRESnE-P1AfIXX4aZ91qAwQ13nSuLTkI4KiwD2ZWU1dov3x-wdbpEaa4gGmsehKbSOCTzMxg94TOn']
//     var payload = {
//         notification: {
//             title: 'Push Title', body
//                 : 'Push body', sound: 'default'
//         }, data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', message: 'Sample push mesage' }
//     }

//     try {
//         const response = await admin.messaging().sendToDevice(tokens, payload);
//         console.log('Notification sent successfully');
//         const userId = context.params.userId; //joshuailuma_testfirst
//         console.log(userId);

//     } catch (err) {
//         console.log('Error sending notification');

//     }
// });

//If last message is 1st username, send notification to 2nd username

exports.onCreateNotification = functions.firestore.document('chatrooms/{userId}/chats/{activeChats}')
    .onCreate(async (snapshot, context) => {
        //1) Get the user connected to the chats
        const userId = context.params.userId;

        const userRef = admin.firestore().doc(`chatrooms/${userId}`);
        const doc = await userRef.get();

      

        //2) Once we have user, check if they have a notification token, then send notification
        const firstUserToken = doc.data().firstUserToken;
        const secondUserToken = doc.data().secondUserToken;
        const firstUsername = doc.data().firstUsername;
        const secondUsername = doc.data().secondUserUsername;
        const lastMessageSendBy = doc.data().lastMessageSendBy;
        activeChats = snapshot.data();
        
        
   

        if (lastMessageSendBy == firstUsername) {
            


           
            sendNotification(secondUserToken, activeChats);
            // console.log('Notification sent to ${secondUserToken}');

            function sendNotification(secondUserToken, activeChats) {
               var body = `${activeChats.message}`;

             
                //4 Create message for push notification
                var payload = {
                    notification: {
                        title: `${activeChats.sendBy}`,
                        body: body,
                        sound: 'default',
                        alert: 'true'
                    },
                    data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', },
                };

                // 5) Send message with admin.messaging
                admin.messaging().sendToDevice(secondUserToken, payload).then(response => {
                    console.log("Message sent to secondUser", response);
                }).catch(error => {
                    console.log("Error sending message", error);
                })

            }

        } else if (lastMessageSendBy == secondUsername) {
            

            sendNotification(firstUserToken, activeChats);
            // console.log('Notification sent to ${firstUserToken}');

            function sendNotification(firstUserToken, activeChats) {
                let body;

                //3) Switch body value based of notification type
                switch (activeChats.type) {
                    case "message": body = `${activeChats.message}`;
                        break;
                    default:
                        break;
                }
                

                //4 Create message for push notification
                const payload = {
                    Notification: {
                        title: `${activeChats.sendBy}`,
                        body: body,
                        sound: 'default',
                    },
                    data: { click_action: 'FLUTTER_NOTIFICATION_CLICK', },
                };

                // 5) Send message with admin.messaging
                admin.messaging().sendToDevice(firstUserToken, payload).then(response => {
                    console.log("Message sent to firstUser", response);
                }).catch(error => {
                    console.log("Error sending message", error);
                })

            }
            
        } else {
            console.log('No notification for this user')
        }

        
    })
