import { Failure } from "../../common/types";
import databases from "../../data/data-sources/injection";
import { IPopulatedDirectMessageEntity } from "../entities";

export async function sendDirectMessage(
  senderCognitoId: string,
  recipientCognitoId: string,
  text: string
): Promise<IPopulatedDirectMessageEntity | Failure> {
  const [friendship, sender, recipient] = await Promise.all([
    databases().friendshipDatabase.getByUsers([
      senderCognitoId,
      recipientCognitoId,
    ]),
    databases().userDatabase.get(senderCognitoId),
    databases().userDatabase.get(recipientCognitoId),
  ]);
  if (friendship instanceof Failure) {
    return friendship;
  } else if (sender instanceof Failure) {
    return sender;
  } else if (recipient instanceof Failure) {
    return recipient;
  } else {
    return {
      ...(await databases().directMessageDatabase.create({
        friendshipId: friendship._id,
        text: text,
        senderCognitoId: senderCognitoId,
      })),
      sender: {
        cognitoId: senderCognitoId,
        firstName: sender.firstName,
        lastName: sender.lastName,
        gymId: sender.gymId,
        _id: sender._id,
        confirmed: sender.confirmed,
      },
      recipient: {
        cognitoId: recipientCognitoId,
        firstName: recipient.firstName,
        lastName: recipient.lastName,
        gymId: recipient.gymId,
        _id: recipient._id,
        confirmed: recipient.confirmed,
      },
    };
  }
}
