const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnNewPost = functions.database.ref("/posts/{postId}")
    .onWrite(async (change, context) => {
      const postId = context.params.postId;

      // If the post is deleted, exit the function
      if (!change.after.exists()) {
        return functions.logger.log(`Post ${postId} was deleted.`);
      }

      // If the post was updated but not created, exit the function
      if (change.before.exists() && change.after.exists()) {
        return functions.logger.log(`Post ${postId} was updated, not created. No notification sent.`);
      }

      // If the post is newly created
      const newPost = change.after.val();

      // Fix: Retrieve post content from `text` field
      let postContent = newPost ? newPost.text : null;

      // Ensure postContent is a valid string, provide a fallback if it's invalid
      if (typeof postContent !== "string" || postContent.trim() === "") {
        postContent = "A new post is available!";
      }

      functions.logger.log(`New post added with postId: ${postId}. Post content: ${postContent}`);

      // Get the list of device notification tokens from users
      const getDeviceTokensPromise = admin.database().ref("/users").once("value");

      // Wait for tokens data to be retrieved
      const tokensSnapshot = await getDeviceTokensPromise;

      // Check if there are any device tokens
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

      functions.logger.log(`Found ${userTokens.length} user tokens to send notifications.`);

      // Updated notification and data payload
      const payload = {
        notification: {
          title: "New Post Available",
          body: postContent, // Use the updated post content here
        },
        data: {
          title: "New Post Available",
          body: postContent, // Include post content in data payload as well
        },
      };

      // Send notifications to each token using the `send` method
      const sendPromises = userTokens.map(async (registrationToken) => {
        const message = {
          token: registrationToken, // Token for the specific device
          ...payload,               // The payload for the notification
        };

        try {
          const response = await admin.messaging().send(message);
          functions.logger.log(`Successfully sent message to ${registrationToken}:`, response);
        } catch (error) {
          functions.logger.error(`Error sending message to ${registrationToken}:`, error);

          // Remove invalid tokens from the database if needed
          if (
            error.code === "messaging/invalid-registration-token" ||
            error.code === "messaging/registration-token-not-registered"
          ) {
            return admin.database().ref(`/users/${tokensSnapshot.ref.key}/token`).remove();
          }
        }
      });

      // Wait for all promises to complete
      return Promise.all(sendPromises);
    });

