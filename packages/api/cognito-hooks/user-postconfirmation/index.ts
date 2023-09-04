import { PostConfirmationTriggerEvent } from "aws-lambda";
import {
  // EnvironmentVars,
  ResourceNotFoundError,
  dynamo,
} from "typescript-core/src/utils";
import { getUserWithoutIdentity } from "typescript-core/src/repositories";
import { CognitoIdentityServiceProvider } from "aws-sdk";

export async function invoke(event: PostConfirmationTriggerEvent) {
  // AWS.config.update({ region: EnvironmentVars.region() });
  // const cognitoIdentityProvider = new AWS.CognitoIdentityServiceProvider({
  //   apiVersion: "2016-04-18",
  // });
  const client = dynamo();
  const user = await getUserWithoutIdentity(client, event.userName);
  if (user instanceof ResourceNotFoundError) {
    throw new Error("User not found");
  }
  return event;
  // cognitoIdentityProvider.adminUpdateUserAttributes(
  //   {
  //     UserAttributes: [
  //       {
  //         Name: "custom:gymId",
  //         Value: user.invite.gymId,
  //       },
  //     ],
  //     UserPoolId: event.userPoolId,
  //     Username: event.userName,
  //   },
  //   (err) => {
  //     if (err) {
  //       return err;
  //     } else {
  //       return event;
  //     }
  //   },
  // );
}
