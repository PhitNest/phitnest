import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import {
  GetObjectCommand,
  HeadObjectCommand,
  PutObjectCommand,
  S3Client,
} from "@aws-sdk/client-s3";
import {
  kFailedToGetProfilePictureUploadUrl,
  kFailedToGetProfilePictureUrl,
  kInvalidProfilePicture,
} from "../../../../common/failures";
import { IProfilePictureDatabase } from "../interfaces";
import { Failure } from "../../../../common/types";

const BUCKET_NAME = process.env.S3_BUCKET_NAME ?? "";

const s3 = new S3Client({
  region: "us-east-1",
  credentials: {
    accessKeyId: process.env.S3_BUCKET_ACCESS_KEY_ID ?? "",
    secretAccessKey: process.env.S3_BUCKET_ACCESS_KEY_SECRET ?? "",
  },
});

async function validateProfilePicture(userCognitoId: string) {
  try {
    const response = await s3.send(
      new HeadObjectCommand({ Bucket: BUCKET_NAME, Key: userCognitoId })
    );
    if (!(response.ContentType ?? "").startsWith("image/")) {
      return kInvalidProfilePicture;
    }
  } catch (err) {
    return kInvalidProfilePicture;
  }
}

export class S3ProfilePictureDatabase implements IProfilePictureDatabase {
  async getProfilePictureUploadUrl(userCognitoId: string) {
    try {
      return getSignedUrl(
        s3,
        new PutObjectCommand({
          Bucket: BUCKET_NAME,
          Key: userCognitoId,
          ContentType: "image/*",
        }),
        {
          expiresIn: 1000,
        }
      );
    } catch (err) {
      const failure = kFailedToGetProfilePictureUploadUrl;
      failure.details = {
        userCognitoId: userCognitoId,
      };
      return failure;
    }
  }

  async getProfilePictureUrl(userCognitoId: string) {
    const validation = await validateProfilePicture(userCognitoId);
    if (!(validation instanceof Failure)) {
      try {
        return getSignedUrl(
          s3,
          new GetObjectCommand({ Bucket: BUCKET_NAME, Key: userCognitoId }),
          {
            expiresIn: 10000,
          }
        );
      } catch (err) {
        return kFailedToGetProfilePictureUrl;
      }
    } else {
      return validation;
    }
  }
}
