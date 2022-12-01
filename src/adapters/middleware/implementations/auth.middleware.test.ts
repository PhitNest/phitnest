import {
  dependencies,
  Middlewares,
  injectUseCases,
  Repositories,
  injectControllers,
  injectRepository,
} from "../../../common/dependency-injection";
import { IAuthMiddleware } from "../interfaces";
import { MockResponse, MockRequest } from "../../../../test/mocks";
import { CognitoAuthRepository } from "../../../repositories/implementations";

class MockAuthenticateRepo extends CognitoAuthRepository {
  async getCognitoId(accessToken: string): Promise<string | null> {
    return accessToken === "test" ? "cognitoId" : null;
  }
}

let authMiddleware: IAuthMiddleware;

beforeAll(() => {
  injectRepository(Repositories.auth, MockAuthenticateRepo);
  injectUseCases();
  injectControllers();
  authMiddleware = dependencies.get(Middlewares.authenticate);
});

test("Cognito ID should be added to locals if the user is properly authenticated", async () => {
  let req = new MockRequest();
  const res = new MockResponse<{ userId: string | undefined }>({
    userId: undefined,
  });
  let nextSpy = { next: (err?: string) => {} };
  let spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.execute(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith("Could not authenticate user with AWS Cognito");
  expect(res.locals.userId).toBeUndefined();
  req = new MockRequest({}, "notTest");
  nextSpy = { next: (err?: string) => {} };
  spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.execute(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith("Could not authenticate user with AWS Cognito");
  expect(res.locals.userId).toBeUndefined();
  req = new MockRequest({}, "test");
  nextSpy = { next: (err?: string) => {} };
  spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.execute(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith();
  expect(res.locals.userId).toBe("cognitoId");
});
