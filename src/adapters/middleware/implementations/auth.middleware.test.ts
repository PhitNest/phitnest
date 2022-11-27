import {
  Controllers,
  dependencies,
  UseCases,
} from "../../../common/dependency-injection";
import { IAuthMiddleware } from "../interfaces";
import { MockResponse, MockRequest } from "../../../../test/mocks";
import { IAuthenticateUseCase } from "../../../use-cases/interfaces";
import { AuthMiddleware } from "./auth.middleware";

class MockAuthenticateUseCase implements IAuthenticateUseCase {
  async execute(accessToken: string) {
    return accessToken == "test" ? "cognitoId" : null;
  }
}

let authMiddleware: IAuthMiddleware;

beforeAll(() => {
  dependencies
    .rebind<IAuthenticateUseCase>(UseCases.authenticate)
    .toConstantValue(new MockAuthenticateUseCase());
  dependencies
    .rebind<IAuthMiddleware>(Controllers.authenticate)
    .to(AuthMiddleware);
  authMiddleware = dependencies.get<IAuthMiddleware>(Controllers.authenticate);
});

test("Cognito ID should be added to locals if the user is properly authenticated", async () => {
  let req = new MockRequest({});
  const res = new MockResponse<{ userId: string | undefined }>({
    userId: undefined,
  });
  let nextSpy = { next: (err?: string) => {} };
  let spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.authenticate(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith("You are not authenticated");
  expect(res.locals.userId).toBeUndefined();
  req = new MockRequest({}, "notTest");
  nextSpy = { next: (err?: string) => {} };
  spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.authenticate(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith("You are not authenticated");
  expect(res.locals.userId).toBeUndefined();
  req = new MockRequest({}, "test");
  nextSpy = { next: (err?: string) => {} };
  spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.authenticate(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith();
  expect(res.locals.userId).toBe("cognitoId");
});
