import * as admin from 'firebase-admin';

const PROJECT_ID = process.env.GCLOUD_PROJECT || 'invoify-7757d';
const BUCKET_NAME = process.env.STORAGE_BUCKET || 'invoify-7757d.firebasestorage.app';

export function getAdminApp(): typeof admin {
  if (!admin.apps.length) {
    admin.initializeApp({
      projectId: PROJECT_ID,
      storageBucket: BUCKET_NAME,
    });
  }
  return admin;
}

export function getDb(): admin.firestore.Firestore {
  getAdminApp();
  return admin.firestore();
}

export function getStorage(): admin.storage.Storage {
  getAdminApp();
  return admin.storage();
}

export function getMessaging(): admin.messaging.Messaging {
  getAdminApp();
  return admin.messaging();
}

// Export lazy getters for backward compatibility
export const db = new Proxy({} as admin.firestore.Firestore, {
  get(_target, prop) {
    return (getDb() as any)[prop];
  },
});

export const storage = new Proxy({} as admin.storage.Storage, {
  get(_target, prop) {
    return (getStorage() as any)[prop];
  },
});

export const messaging = new Proxy({} as admin.messaging.Messaging, {
  get(_target, prop) {
    return (getMessaging() as any)[prop];
  },
});
