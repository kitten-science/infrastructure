const { HeadObjectCommand, S3 } = require("@aws-sdk/client-s3");

const BUCKET = "kitten-science-us0";
const client = new S3({ region: "us-east-1" });

const fetchFileMeta = async (filename) => {
  try {
    console.info(`Fetching metadata for '${filename}'...`);
    const command = new HeadObjectCommand({
      Bucket: BUCKET,
      Key: filename,
    });

    const response = await client.send(command);
    if (response.$metadata.httpStatusCode !== 200) {
      console.warn(
        `Response status code was '${response.$metadata.httpStatusCode}'. Failing.`
      );
      return null;
    }

    const metadata = {
      cacheControl: response.CacheControl ?? "no-cache",
      websiteRedirectLocation: response.WebsiteRedirectLocation,
    };
    return metadata;
  } catch (error) {
    console.error(error);
    return null;
  }
};

exports.handler = async (event) => {
  if (!Array.isArray(event.Records)) {
    throw new Error("No Records in event!");
  }

  const request = event.Records[0].cf.request;
  const requestFilename = request.uri.replace(/^\//, "");

  try {
    const meta = await fetchFileMeta(requestFilename);
    if (!meta) {
      console.info(
        `Found no relevant metadata matching '${requestFilename}'. Passing request through to origin.`
      );
      return request;
    }

    if (!meta.websiteRedirectLocation) {
      console.info(
        `No redirect location has been set for '${requestFilename}'. Passing request through to origin.`
      );
      return request;
    }

    console.info(
      `Redirecting request for '${request.uri}' to '${meta.websiteRedirectLocation}' (${meta.cacheControl}).`
    );

    return {
      status: "302",
      statusDescription: "Found",
      headers: {
        "cache-control": [{ value: meta.cacheControl }],
        location: [{ value: meta.websiteRedirectLocation }],
      },
    };
  } catch (_error) {
    console.error(_error);
    return request;
  }
};
