import { db, messaging } from '../config/firebase';

export interface SendPushNotificationParams {
  userId: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

export async function sendPushNotificationToUser(params: SendPushNotificationParams): Promise<boolean> {
  try {
    console.log(`[sendPushNotificationToUser] Target userId: ${params.userId}`);
    const userDoc = await db.collection('users').doc(params.userId).get();
    if (!userDoc.exists) {
      console.warn(`[sendPushNotificationToUser] User doc ${params.userId} does not exist in Firestore.`);
      return false;
    }

    const userData = userDoc.data();
    const fcmToken = userData?.fcmToken || (Array.isArray(userData?.fcmTokens) ? userData.fcmTokens[0] : undefined);

    if (!fcmToken) {
      console.warn(`[sendPushNotificationToUser] No fcmToken field found in users/${params.userId}`);
      return false;
    }

    console.log(`[sendPushNotificationToUser] Sending FCM payload to token (${fcmToken.substring(0, 20)}...)...`);

    const response = await messaging.send({
      token: fcmToken,
      notification: {
        title: params.title,
        body: params.body,
      },
      android: {
        priority: 'high',
        notification: {
          channelId: 'high_importance_channel',
          priority: 'high',
          defaultSound: true,
        },
      },
      apns: {
        payload: {
          aps: {
            alert: {
              title: params.title,
              body: params.body,
            },
            sound: 'default',
          },
        },
      },
      data: params.data || {},
    });

    console.log(`[sendPushNotificationToUser] FCM Notification sent successfully! Response ID: ${response}`);
    return true;
  } catch (error: any) {
    console.error(`[sendPushNotificationToUser] Error sending FCM notification to user ${params.userId}:`, error?.message || error, error?.stack || '');
    return false;
  }
}
