const express = require('express');
const app = express();

app.get('/', (req, res) => {
  console.log('Pull From PubSub received a request via Service Interface (not MSG subscription).');

  const target = process.env.TARGET || 'World';
  res.send(`Hello ${target}!`);
});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('Pull From PubSub listening on port', port);
  // crude insertion of pub-sub listener - listen for 100 mins on the GCS notif topic. 
  notmain("demo-test-sub-landing", 6000);
});

// Copyright 2019-2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

/**
 * This application demonstrates how to perform basic operations on
 * subscriptions with the Google Cloud Pub/Sub API.
 *
 * For more information, see the README.md under /pubsub and the documentation
 * at https://cloud.google.com/pubsub/docs.
 */

 'use strict';

 // sample-metadata:
 //   title: Listen For Messages
 //   description: Listens for messages from a subscription.
 //   usage: node listenForMessages.js <subscription-name-or-id> [timeout-in-seconds]
 
 function notmain(
   subscriptionNameOrId = 'YOUR_SUBSCRIPTION_NAME_OR_ID',
   timeout = 60
 ) {
   timeout = Number(timeout);
 
   // [START pubsub_subscriber_async_pull]
   // [START pubsub_quickstart_subscriber]
   /**
    * TODO(developer): Uncomment these variables before running the sample.
    */
   //const subscriptionNameOrId = 'gcs-notif-topic';
   //const timeout = 6000;
 
   // Imports the Google Cloud client library
   const {PubSub} = require('@google-cloud/pubsub');
 
   // Creates a client; cache this for further use
   const pubSubClient = new PubSub();
 
   function listenForMessages() {
     // References an existing subscription
     const subscription = pubSubClient.subscription(subscriptionNameOrId);
 
     // Create an event handler to handle messages
     let messageCount = 0;
     const messageHandler = message => {
       console.log(`Received message ${message.id}:`);
       console.log(`\tData: ${message.data}`);
       console.log(`\tAttributes: ${message.attributes}`);
       messageCount += 1;
       doGCS('triggered by Subscriber Pull');
       // "Ack" (acknowledge receipt of) the message
       message.ack();
     };
 
     // Listen for new messages until timeout is hit
     subscription.on('message', messageHandler);
 
     setTimeout(() => {
       subscription.removeListener('message', messageHandler);
       console.log(`${messageCount} message(s) received.`);
     }, timeout * 1000);
   }
 
   listenForMessages();
   // [END pubsub_subscriber_async_pull]
   // [END pubsub_quickstart_subscriber]
 }
 
 //main(...process.argv.slice(2));

 // GCS Code
 function doGCS(srcMsg = 'srcMsg'){
  console.log(srcMsg);
  console.log('GCS Transition received a request.');

  // Prefix the GCS Bucket Names with your project name plus "_" 
  const srcBucketName = 'nlp-dev-6aae_datalake-ingest-landing';
  const srcFilename = 'UID-007.wav';
  const destBucketName = 'nlp-dev-6aae_datalake-transcribed';
  const destFileName = 'UID-007.json';

  copyGCSFile(srcBucketName,srcFilename,destBucketName,destFileName)

  console.log(`File ${srcFilename} copied from ${srcBucketName} to ${destBucketName} to become ${destFileName}`);

};
 /*
Function to Copy File from one Bucket to another
*/
function copyGCSFile(
  srcBucketName = 'nlp-dev-6aae_datalake-ingest-landing',
  srcFilename = 'UID-007.wav',
  destBucketName = 'nlp-dev-6aae_datalake-transcribed',
  destFileName = 'UID-007.json',
  destinationGenerationMatchPrecondition = 0
) {
  // [START storage_copy_file]
  /**
   * TODO(developer): Uncomment the following lines before running the sample.
   */
  // The ID of the bucket the original file is in
  // const srcBucketName = 'your-source-bucket';

  // The ID of the GCS file to copy
  // const srcFilename = 'your-file-name';

  // The ID of the bucket to copy the file to
  // const destBucketName = 'target-file-bucket';

  // The ID of the GCS file to create
  // const destFileName = 'target-file-name';

  // Imports the Google Cloud client library
  const {Storage} = require('@google-cloud/storage');

  // Creates a client
  const storage = new Storage();

  async function copyFile() {
    const copyDestination = storage.bucket(destBucketName).file(destFileName);

    // Optional:
    // Set a generation-match precondition to avoid potential race conditions
    // and data corruptions. The request to upload is aborted if the object's
    // generation number does not match your precondition. For a destination
    // object that does not yet exist, set the ifGenerationMatch precondition to 0
    // If the destination object already exists in your bucket, set instead a
    // generation-match precondition using its generation number.
    const copyOptions = {
      preconditionOpts: {
        ifGenerationMatch: destinationGenerationMatchPrecondition,
      },
    };

    // Copies the file to the other bucket
    await storage
      .bucket(srcBucketName)
      .file(srcFilename)
      .copy(copyDestination, copyOptions);

    console.log(
      `gs://${srcBucketName}/${srcFilename} copied to gs://${destBucketName}/${destFileName}`
    );
  }

  copyFile().catch(console.error);
  // [END storage_copy_file]
}