const {onSchedule} = require("firebase-functions/v2/scheduler");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();
const messaging = admin.messaging();

exports.sendScheduledClassReminders = onSchedule(
    {
      schedule: "every 5 minutes",
      timeZone: "Asia/Kolkata",
    },
    async () => {
      const now = new Date();
      console.log("Function running at:", now.toString());

      const timeDiffs = [5, 15, 30, 45, 55];
      const classSnap = await db.collection("scheduled_classes").get();
      console.log(`Found ${classSnap.size} scheduled classes`);

      for (const doc of classSnap.docs) {
        const data = doc.data();

        if (!data.targetDate || !data.title || !data.description) {
          console.log(`Skipping ${doc.id}: Missing required fields.`);
          continue;
        }

        const target = new Date(data.targetDate._seconds * 1000);
        const diffMins = Math.floor((target - now) / 60000);
        console.log(`Class ${doc.id} is in ${diffMins} minutes`);

        // Tolerance ±4 minutes
        if (timeDiffs.some((t) => Math.abs(t - diffMins) <= 4)) {
          console.log(`Sending notifications for class: ${data.title}`);

          const users = await db.collection("users").get();
          for (const user of users.docs) {
            const userData = user.data();
            const token = userData.token;

            if (token) {
              try {
                await messaging.send({
                  token,
                  notification: {
                    title: data.title,
                    body: data.description,
                  },
                });
                console.log(`Notification sent to token: ${token}`);
              } catch (err) {
                console.error(`Failed to send to ${token}:`, err);
              }
            } else {
              console.log(`User ${user.id} has no token`);
            }
          }
        }
      }
    },
);
