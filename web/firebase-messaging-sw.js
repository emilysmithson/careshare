
   
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
  apiKey: 'AIzaSyCqYe7ZI5IkfCh_909kD7PQj4EqcLAUT8k',
  appId: '1:468078459323:web:e5d84472a92c49af4f2c9e',
  messagingSenderId: '468078459323',
  projectId: 'careshare-data',
  authDomain: 'careshare-data.firebaseapp.com',
  databaseURL: 'https://careshare-data-default-rtdb.europe-west1.firebasedatabase.app',
  storageBucket: 'careshare-data.appspot.com',
  measurementId: 'G-5MS77VHJDB',
});
// Necessary to receive background messages:
const messaging = firebase.messaging();

// Optional:
messaging.onBackgroundMessage((m) => {
  console.log("onBackgroundMessage", m);
});