const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
exports.writeMessage = functions.https.onCall(async (data) => {
  // Grab the text parameter.
  const original = data.text;
  // Returns the text received
  return `Successfully received: ${original}`;
});
exports.giveKudos = functions.pubsub.topic("kudos").onPublish((message) => {
// payload:
// name and id of person who completed task
// name and id of person who gave kudos
// the title of the task
// What this needs to do:
// update the task with the new kudos (calculate number of kudos)
// update the leaderboard with the new kudos
// send the notification to the person who completed the task.
  const payload = message.data;
  const username = payload["user_name"];
  const userId = payload["user_id"];
  console.debug(username);
  console.debug(userId);
});
exports.notifyUsers = functions.database.ref("tasks/{task}")
    .onCreate(( snapshot, _) => {
      const snapshotVal = snapshot.val();
      // const {title} = snapshotVal;
      const title1 = snapshotVal.title;
      // const createdBy = snapshotVal.createdBy;
      console.debug(title1);
      console.debug(snapshotVal);
      // Grab the current value of what was written to the Realtime Database.
      admin.messaging().sendToTopic("task", {
        notification:
          {
            title: "A new task has been added",
            body: snapshotVal["title"],
            clickAction: "FLUTTER_NOTIFICATION_CLICK",
          },
        data: {
          "created_by": snapshotVal["created_by"],
          "date_created": snapshotVal["date_created"],
        },
      });
      return;
    });
