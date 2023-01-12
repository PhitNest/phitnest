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
import {
  DenyFriendRequestController,
  SendFriendRequestController,
} from "./controllers/friendRequest";
import { RemoveFriendController } from "./controllers/friendship";
import { NearestGymsController } from "./controllers/gym";
import { ExploreController, GetUserController } from "./controllers/user";

export function buildRouter(server: IServer) {
  server.bind({
    route: "/auth/login",
    controller: new LoginController(),
  });
  server.bind({
    route: "/auth/register",
    controller: new RegisterController(),
  });
  server.bind({
    route: "/auth/resendConfirmation",
    controller: new ResendConfirmationController(),
  });
  server.bind({
    route: "/auth/confirmRegister",
    controller: new ConfirmRegisterController(),
  });
  server.bind({
    route: "/auth/forgotPassword",
    controller: new ForgotPasswordController(),
  });
  server.bind({
    route: "/auth/forgotPasswordSubmit",
    controller: new ForgotPasswordSubmitController(),
  });
  server.bind({
    route: "/auth/signOut",
    controller: new SignOutController(),
  });
  server.bind({
    route: "/auth/refreshSession",
    controller: new RefreshSessionController(),
  });
  server.bind({
    route: "/user",
    controller: new GetUserController(),
  });
  server.bind({
    route: "/gym/nearest",
    controller: new NearestGymsController(),
  });
  server.bind({
    route: "/friendRequest",
    controller: new SendFriendRequestController(),
  });
  server.bind({
    route: "/friendRequest/deny",
    controller: new DenyFriendRequestController(),
  });
  server.bind({
    route: "/friendship",
    controller: new RemoveFriendController(),
  });
  server.bind({
    route: "/user/explore",
    controller: new ExploreController(),
  });
}
