import { IServer } from "./adapters/interfaces";
import {
  LoginController,
  RegisterController,
  ResendConfirmationController,
} from "./controllers/auth";

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
}
