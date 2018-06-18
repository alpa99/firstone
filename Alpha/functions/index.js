const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);
// database tree
exports.sendNewBestellung = functions.database.ref('/userBestellungen/{UID}').onWrite(event=>{
        let projectData = event.data.val();
        if (!event.data.previous.exists()) {
        // Do things here if project didn't exists before
        }
})
