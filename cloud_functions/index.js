const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

// Existing function to notify all users about new posts
exports.sendNotificationOnNewPost = functions.database.ref("/posts/{postId}")
    .onWrite(async (change, context) => {
      const postId = context.params.postId;

      if (!change.after.exists()) {
        return functions.logger.log(`Post ${postId} was deleted.`);
      }

      if (change.before.exists() && change.after.exists()) {
        return functions.logger.log(`Post ${postId} was updated, not created. No notification sent.`);
      }

      const newPost = change.after.val();

      if (!newPost) {
        return functions.logger.log("No post data found.");
      }

      const postTitle = newPost.title || "New Content Available";
      const postContent = newPost.text || newPost.about || "Check out the latest updates!";

      functions.logger.log(`New post added with postId: ${postId}. Post title: ${postTitle}, Post content: ${postContent}`);

      // Get user tokens
      const tokensSnapshot = await admin.database().ref("/users").once("value");

      if (!tokensSnapshot.exists()) {
        return functions.logger.log("No users found in database.");
      }

      const userTokens = [];
      tokensSnapshot.forEach((userSnapshot) => {
        const userToken = userSnapshot.val().token;
        if (userToken && typeof userToken === "string") {
          userTokens.push(userToken);
        }
      });

      if (userTokens.length === 0) {
        return functions.logger.log("No user tokens found.");
      }

      const payload = {
        notification: {
          title: postTitle,
          body: postContent,
        },
        data: {
          title: postTitle,
          body: postContent,
          type: newPost.type || "news",
          postId: postId,
        }
      };

      const sendPromises = userTokens.map(async (registrationToken) => {
        const message = { token: registrationToken, ...payload };
        try {
          const response = await admin.messaging().send(message);
          functions.logger.log(`Successfully sent message to ${registrationToken}:`, response);
        } catch (error) {
          functions.logger.error(`Error sending message to ${registrationToken}:`, error);

          if (
            error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered"
          ) {
            return admin.database().ref(`/users/${tokensSnapshot.ref.key}/token`).remove();
          }
        }
      });

      return Promise.all(sendPromises);
    });


// New function to notify tutors and masters about reservation changes
exports.sendReservationNotification = functions.database.ref("/reservations/{reservationId}")
    .onWrite(async (change, context) => {
      const reservationId = context.params.reservationId;
      const message = change.after.exists() ? "New reservation added" : "Reservation removed";

      const staffSnap = await admin.database().ref("stuff").once("value");
      const tokens = [];
      staffSnap.forEach((staff) => {
        if (staff.child("token").exists()) {
          tokens.push(staff.child("token").val());
        }
      });

      const payload = {
        notification: {
          title: "Reservation Update",
          body: message,
        },
        data: {
          title: "Reservation Update",
          body: message,
        },
      };

      const sendPromises = tokens.map(async (registrationToken) => {
        const message = { token: registrationToken, ...payload };
        try {
          const response = await admin.messaging().send(message);
          functions.logger.log(`Successfully sent reservation notification to ${registrationToken}:`, response);
        } catch (error) {
          functions.logger.error(`Error sending reservation notification to ${registrationToken}:`, error);
        }
      });

      return Promise.all(sendPromises);
    });

// New function to notify only masters about payment updates
exports.sendPaymentNotification = functions.database.ref("/payments/{paymentId}")
    .onWrite(async (change, context) => {
      const paymentId = context.params.paymentId;
      const paymentStatus = (change.after.val() && change.after.val().status) || "Payment update";
      const message = `Payment update: ${paymentStatus}`;

      const staffSnap = await admin.database().ref("staff").once("value");
      const masterTokens = [];
      staffSnap.forEach((staff) => {
        if (staff.child("type").val() === "master" && staff.child("token").exists()) {
          masterTokens.push(staff.child("token").val());
        }
      });

      const payload = {
        notification: {
          title: "Payment Update",
          body: message,
        },
        data: {
          title: "Payment Update",
          body: message,
        },
      };

      const sendPromises = masterTokens.map(async (registrationToken) => {
        const message = { token: registrationToken, ...payload };
        try {
          const response = await admin.messaging().send(message);
          functions.logger.log(`Successfully sent payment notification to ${registrationToken}:`, response);
        } catch (error) {
          functions.logger.error(`Error sending payment notification to ${registrationToken}:`, error);
        }
      });

      return Promise.all(sendPromises);
    });
