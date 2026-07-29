import { db, messaging } from '../config/firebase';

export interface SendPushNotificationParams {
  userId: string;
  title: string;
  body: string;
  data?: Record<string, string>;
}

export async function sendPushNotificationToUser(params: SendPushNotificationParams): Promise<boolean> {
  try {
    const userDoc = await db.collection('users').doc(params.userId).get();
    if (!userDoc.exists) {
      console.warn(`User ${params.userId} not found for sending FCM notification.`);
      return false;
    }

    const userData = userDoc.data();
    const fcmToken = userData?.fcmToken || userData?.fcmTokens?.[0];

    if (!fcmToken) {
      console.warn(`No FCM token found for user ${params.userId}.`);
      return false;
    }

    await messaging.send({
      token: fcmToken,
      notification: {
        title: params.title,
        body: params.body,
      },
      data: {
        click_action: 'FLUTTER_NOTIFICATION_CLICK',
        ...params.data,
      },
    });

    console.log(`Push notification sent successfully to user ${params.userId}`);
    return true;
  } catch (error) {
    console.error(`Error sending push notification to user ${params.userId}:`, error);
    return false;
  }
}
