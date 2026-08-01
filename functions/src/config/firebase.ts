import { initializeApp, getApps, App } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';
import { getStorage } from 'firebase-admin/storage';
import { getMessaging } from 'firebase-admin/messaging';

const BUCKET_NAME = process.env.STORAGE_BUCKET || 'invoify-7757d.firebasestorage.app';

export function getAdminApp(): App {
  if (!getApps().length) {
    return initializeApp({
      storageBucket: BUCKET_NAME,
    });
  }
  return getApps()[0];
}

// Top-level initialization ensures single instance across all Cloud Function invocations
export const app = getAdminApp();
export const db = getFirestore(app);
export const storage = getStorage(app);
export const messaging = getMessaging(app);


