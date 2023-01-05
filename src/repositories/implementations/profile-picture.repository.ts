import { injectable } from "inversify";
import { IProfilePictureRepository } from "../interfaces";
import { getSignedUrl } from "@aws-sdk/s3-request-presigner";
import {
  S3Client,
  GetObjectCommand,
  PutObjectCommand,
} from "@aws-sdk/client-s3";

const S3_BUCKET_NAME = process.env.S3_BUCKET_NAME ?? "";

const s3Client = new S3Client({
  credentials: {
    accessKeyId: process.env.S3_BUCKET_ACCESS_KEY_ID ?? "",
    secretAccessKey: process.env.S3_BUCKET_ACCESS_KEY_SECRET ?? "",
  },
  region: process.env.COGNITO_REGION ?? "",
});

@injectable()
export class S3ProfilePictureRepository implements IProfilePictureRepository {
  getProfilePictureUrl(userCognitoId: string) {
    return getSignedUrl(
      s3Client,
      new GetObjectCommand({
        Bucket: S3_BUCKET_NAME,
        Key: userCognitoId,
      })
    );
  }

  getPresignedUploadURL(userCognitoId: string) {
    const expiration = new Date();
    expiration.setMinutes(expiration.getMinutes() + 20);
    return getSignedUrl(
      s3Client,
      new PutObjectCommand({
        Bucket: S3_BUCKET_NAME,
        Key: userCognitoId,
        Expires: expiration,
      })
    );
  }
}
