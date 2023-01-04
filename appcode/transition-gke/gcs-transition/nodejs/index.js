const express = require('express');
const app = express();

app.get('/', (req, res) => {
  console.log('GCS Transition received a request.');

  const srcBucketName = 'datalake-ingest-landing';
  const srcFilename = 'UID-007.wav';
  const destBucketName = 'datalake-transcribed';
  const destFileName = 'UID-007.json';

  copyGCSFile(srcBucketName,srcFilename,destBucketName,destFileName)

  res.send(`File ${srcFilename} copied from ${srcBucketName} to ${destBucketName} to become ${destFileName}`);

});

const port = process.env.PORT || 8080;
app.listen(port, () => {
  console.log('GCS Transition listening on port', port);
});
/*
Function to Copy File from one Bucket to another
*/
function copyGCSFile(
  srcBucketName = 'datalake-ingest-landing',
  srcFilename = 'UID-007.wav',
  destBucketName = 'datalake-transcribed',
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
