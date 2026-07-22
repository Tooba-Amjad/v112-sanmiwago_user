/* eslint-disable max-len */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({maxInstances: 10});

const admin = require("firebase-admin");

admin.initializeApp();

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

exports.sendNotification = onRequest(async (request, response) => {
  try {
    const {fcm, title, body, data} = request.body;

    if ([fcm, title, body].some((v) => v == null)) {
      // v == null catches both null and undefined
      response.status(400).send({
        status: "error",
        message: "Missing required parameters",
      });
      return;
    }
    logger.info(`fcm: ${fcm}`, {structuredData: true});
    logger.info(`title: ${title}`, {structuredData: true});
    logger.info(`body: ${body}`, {structuredData: true});
    logger.info(`data: ${data}`, {structuredData: true});

    let payloadData = data;
    if ((typeof data) === "string") {
      try {
        payloadData = JSON.parse(data);

        if (typeof payloadData === "string") {
          payloadData = JSON.parse(payloadData); // parse again if still a string => probably happening because of the x-www-form-urlencoded type
        }
        logger.info(`payloadData after JSON.parse: ${payloadData}`, {structuredData: true});
      } catch (e) {
        response.status(400).send({
          status: "error",
          message: "data must be a valid JSON object",
        });
        return;
      }
    }


    const msgId = await admin.messaging().send({
      token: fcm,
      notification: {
        title,
        body,
      },
      data: payloadData,
    });

    logger.info(`msgId: ${msgId}`, {structuredData: true});

    response.status(200).send({
      status: "success",
      msgId: msgId,
      message: "Notification sent successfully",
    });
  } catch (error) {
    response.status(500).send({
      status: "error",
      message: `Error sending notification. ${error}`,
    });
  }
});
