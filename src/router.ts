import { IServer } from "./adapters/interfaces";
import { LoginController } from "./controllers/auth";

export function buildRouter(server: IServer) {
  server.bind({
    route: "/auth/login",
    controller: new LoginController(),
  });
}
