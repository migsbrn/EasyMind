import admin from 'firebase-admin';

// Initialize Firebase Admin SDK with your service account key
import serviceAccount from './serviceAccountKey.json' assert { type: 'json' };

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  projectId: 'easy-mind-51834', // Ensure this matches your Firebase project ID
});

// User UIDs for admins (use meaningful keys or comments for clarity)
const userUids = {
  bprosas: 'lCPzNsW6t4RBm77ehbxprqK3ybv2',
  kaiii: 'yP1XzeVZbzTSkn2JwrPKUaZla2H3',
};

// Function to set admin claim for a single UID
const setAdminClaim = async (uid, emailDescription) => {
  try {
    await admin.auth().setCustomUserClaims(uid, { admin: true });
    console.log(`Admin claim set successfully for ${emailDescription} (UID: ${uid})`);
  } catch (error) {
    console.error(`Error setting admin claim for ${emailDescription} (UID: ${uid}):`, error);
  }
};

// Set admin claims for all users
const applyAdminClaims = async () => {
  await Promise.all([
    setAdminClaim(userUids.bprosas, 'bprosas@easymind.com'),
    setAdminClaim(userUids.kaiii, 'kaiii.kuma08@gmail.com')
  ]);
};

// Run the script
applyAdminClaims();