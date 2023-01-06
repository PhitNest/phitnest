import { injectable } from "inversify";
import { IProfilePictureRepository } from "../interfaces";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import {
  S3Client,
  GetObjectCommand,
  PutObjectCommand,
  HeadObjectCommand,
} from "@aws-sdk/client-s3";

const S3_BUCKET_NAME = process.env.S3_BUCKET_NAME ?? "";

const s3Client = new S3Client({
  credentials: {
    accessKeyId: process.env.S3_BUCKET_ACCESS_KEY_ID ?? "",
    secretAccessKey: process.env.S3_BUCKET_ACCESS_KEY_SECRET ?? "",
  },
  region: process.env.COGNITO_REGION ?? "",
});

const expiration = 60 * 5;

@injectable()
export class S3ProfilePictureRepository implements IProfilePictureRepository {
  getPresignedGetURL(userCognitoId: string) {
    return getSignedUrl(
      s3Client,
      new GetObjectCommand({
        Bucket: S3_BUCKET_NAME,
        Key: userCognitoId,
      }),
      {
        expiresIn: expiration,
      }
    );
  }

  getPresignedUploadURL(userCognitoId: string) {
    return getSignedUrl(
      s3Client,
      new PutObjectCommand({
        Bucket: S3_BUCKET_NAME,
        Key: userCognitoId,
      }),
      {
        expiresIn: expiration,
      }
    );
  }

  async hasProfilePicture(userCognitoId: string) {
    try {
      await s3Client.send(
        new HeadObjectCommand({
          Bucket: S3_BUCKET_NAME,
          Key: userCognitoId,
        })
      );
      return true;
    } catch (err) {
      return false;
    }
  }
}
