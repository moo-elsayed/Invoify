import * as admin from 'firebase-admin';

export function getAdminApp(): typeof admin {
  if (!admin.apps.length) {
    admin.initializeApp();
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
