const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();


// createTask is called when a user creates a task in the UI
// ____________________________________________________________________________________________________________________________________
exports.createTask = functions.https.onCall(async (data) => {

    // Send a message to everyone
    admin.messaging().sendToTopic("task_created", {
    notification:
      {
        title: data["creater_name"] + " has created a task: " + data["task_title"],
        body: data["creater_name"] + " has created a task: " + data["task_title"] + " at " + data["date_time"] ,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    data: {
      "task_id": data["task_id"],
    },
  });
  return `Successfully completed: ${data["task_id"]}`;

});


// giveKudos is called when a user clicks the kudos button in the UI
// ____________________________________________________________________________________________________________________________________
exports.giveKudos = functions.https.onCall(async (data) => {
// exports.giveKudos = functions.pubsub.topic("kudos").onPublish((message) => {
// payload:
// name and id of person who completed task
// name and id of person who gave kudos
// the title of the task
// What this needs to do:
// update the task with the new kudos (calculate number of kudos)
// update the leaderboard with the new kudos
// send the notification to the person who completed the task.

  const taskId = data["task_id"];

  // Adds a record of the kudos to the task
  const snapshot = await admin.database().ref("tasks/"+taskId).get();
  const snapshotVal = snapshot.val();
  await admin.database().ref("tasks/"+taskId+"/kudos").push({
    "id": data["kudos_giver_id"],
    "date_time": data["date_time"],
  });

  // Gives the completer kudos
  const userId = snapshotVal["accepted_by"];
  await admin.database().ref("profiles/"+userId+"/kudos").
      set(
          admin.database.
              ServerValue.increment(snapshotVal["task_effort"]),
      );

  // const kudosGiverId = data["kudos_giver_id"];
  // Returns the text received
  // console.debug(taskId, kudosGiverId);
  console.debug("kudos"+userId);

  // Send the task completer a message
  admin.messaging().sendToTopic(userId, {
    notification:
      {
        title: data["kudos_giver_name"] + " has given you kudos!",
        body: snapshotVal["title"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    data: {
      "created_by": snapshotVal["created_by"],
      "date_created": snapshotVal["date_created"],
    },
  });
  return `Successfully received: ${taskId}`;
});


// assignTask is called when a user assigns a task in the UI
// ____________________________________________________________________________________________________________________________________
exports.assignTask = functions.https.onCall(async (data) => {

    // Send the task assignee a message
    admin.messaging().sendToTopic(data["assignee_id"], {
    notification:
      {
        title: "You have a new task: " + data["task_title"],
        body: data["kudos_assigner_name"] + " has assigned you a new task: " + data["task_title"],
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    data: {
      "task_id": data["task_id"],
    },
  });
  return `Successfully assigned: ${data["task_id"]}`;

});

// completeTask is called when a user completes a task in the UI
// ____________________________________________________________________________________________________________________________________
exports.completeTask = functions.https.onCall(async (data) => {

    // Send a message to everyone
    admin.messaging().sendToTopic("task_completed", {
    notification:
      {
        title: data["completer_name"] + " has completed a task: " + data["task_title"],
        body: data["completer_name"] + " has completed a task: " + data["task_title"] + " at " + data["date_time"] ,
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
    data: {
      "task_id": data["task_id"],
    },
  });
  return `Successfully completed: ${data["task_id"]}`;

});


//
//// notifyUsers - a generic update to all users
//exports.notifyUsers = functions.database.ref("tasks/{task}")
//    .onCreate(( snapshot, _) => {
//      const snapshotVal = snapshot.val();
//      // const {title} = snapshotVal;
//      const title1 = snapshotVal.title;
//      // const createdBy = snapshotVal.createdBy;
//      console.debug(title1);
//      console.debug(snapshotVal);
//
//      // Grab the current value     of what was written to the Realtime Database.
//      admin.messaging().sendToTopic("task", {
//        notification:
//          {
//            title: "A new task has been added",
//            body: snapshotVal["title"],
//            clickAction: "FLUTTER_NOTIFICATION_CLICK",
//          },
//        data: {
//          "created_by": snapshotVal["created_by"],
//          "date_created": snapshotVal["date_created"],
//        },
//      });
//      return;
//    });
