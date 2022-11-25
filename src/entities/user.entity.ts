import mongoose from "mongoose";

export interface IUserEntity extends mongoose.Document {
  cognitoId: Readonly<string>;
  gymId: Readonly<mongoose.Types.ObjectId>;
  email: Readonly<string>;
  firstName: Readonly<string>;
  lastName: Readonly<string>;
}
