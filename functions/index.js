const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

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
