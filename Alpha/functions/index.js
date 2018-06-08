const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
// database tree
exports.sendPushNotification = functions.database.ref('/Bestellungen/{id}').onWrite(event =>{
            const payload = {
            notification: {
            title: 'Neue Bestellung',
            body: 'Tischnummer 99',
            badge: '1',
            sound: 'default',
                }
                                                                                
            };
        return admin.database().ref('fcmToken').once('value').then(allToken => {
            if (allToken.val()){
            const token = Object.keys(allToken.val());
            console.log(`token? ${token}`);
            return admin.messaging().sendToDevice(token, payload).then(response =>{
            return null;
            });
        }
                                                                                                                                           
        return null;
        });
                                                                                    });
