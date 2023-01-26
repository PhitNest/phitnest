import { IServer } from "./adapters/interfaces";
import {
  ConfirmRegisterController,
  ForgotPasswordController,
  ForgotPasswordSubmitController,
  LoginController,
  RefreshSessionController,
  RegisterController,
  ResendConfirmationController,
  SignOutController,
} from "./controllers/auth";
import { GetDirectMessagesController } from "./controllers/directMessage";
import {
  DenyFriendRequestController,
  SendFriendRequestController,
} from "./controllers/friendRequest";
import {
  FriendsAndMessagesController,
  FriendsAndRequestsController,
  RemoveFriendController,
} from "./controllers/friendship";
import { NearestGymsController } from "./controllers/gym";
import {
  ProfilePictureUploadController,
  UnauthorizedProfilePictureUploadController,
} from "./controllers/profilePicture";
import { ExploreController, GetUserController } from "./controllers/user";

export function buildRouter(server: IServer) {
  server.bind(new LoginController());
  server.bind(new RegisterController());
  server.bind(new ResendConfirmationController());
  server.bind(new ConfirmRegisterController());
  server.bind(new ForgotPasswordController());
  server.bind(new ForgotPasswordSubmitController());
  server.bind(new SignOutController());
  server.bind(new RefreshSessionController());
  server.bind(new GetUserController());
  server.bind(new ExploreController());
  server.bind(new NearestGymsController());
  server.bind(new SendFriendRequestController());
  server.bind(new DenyFriendRequestController());
  server.bind(new RemoveFriendController());
  server.bind(new FriendsAndRequestsController());
  server.bind(new FriendsAndMessagesController());
  server.bind(new GetDirectMessagesController());
  server.bind(new UnauthorizedProfilePictureUploadController());
  server.bind(new ProfilePictureUploadController());
}
