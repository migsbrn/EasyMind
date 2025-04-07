import { initializeApp } from "firebase/app";
import { getFirestore } from "firebase/firestore";
import { getAuth } from "firebase/auth";
import { getAnalytics } from "firebase/analytics";

const firebaseConfig = {
  apiKey: "AIzaSyCT5HTrn5anC7bwfdLx8AmF-MafDcNlIzg",
  authDomain: "easy-mind-51834.firebaseapp.com",
  projectId: "easy-mind-51834",
  storageBucket: "easy-mind-51834.firebasestorage.app",
  messagingSenderId: "1026451165224",
  appId: "1:1026451165224:web:dc442a4c04fe8cf7be651d",
  measurementId: "G-LELN1NTF6M"
};

// Initialize Firebase
const app = initializeApp(firebaseConfig);
const analytics = getAnalytics(app);
const db = getFirestore(app);
const auth = getAuth(app);

export { db, auth };