const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
// database tree
exports.sendNewBestellung = functions.database.ref('/Bestellungen/{id}').onWrite(event=>{
    const uuid = event.params.id;
                                                                                         
    console.log('User to send notification', uuid);
                                                                                         
    var ref = admin.database().ref(`Users/${uuid}/token`);
    return ref.once("value", function(snapshot){
                                                                                                         
    const payload = {
    notification: {
    title: 'Neue Bestellung',
    body: 'Tap here to check it out!'
    }
    };
                                                                                                         
    admin.messaging().sendToDevice(snapshot.val(), payload)
                                                                                                         
    },
    function (errorObject) {
    console.log("The read failed: " + errorObject.code);
    });
})
