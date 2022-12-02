import {
  dependencies,
  Middlewares,
  injectUseCases,
  Repositories,
  injectAdapters,
  injectRepository,
} from "../../../common/dependency-injection";
import { IAuthMiddleware } from "../interfaces";
import {
  MockResponse,
  MockRequest,
  MockAuthRepo,
} from "../../../../test/mocks";

let authMiddleware: IAuthMiddleware;

beforeAll(() => {
  injectRepository(Repositories.auth, MockAuthRepo);
  injectUseCases();
  injectAdapters();
  authMiddleware = dependencies.get(Middlewares.authenticate);
});

test("Cognito ID should be added to locals if the user is properly authenticated", async () => {
  let req = new MockRequest();
  const res = new MockResponse<{ cognitoId: string | undefined }>({
    cognitoId: undefined,
  });
  let nextSpy = { next: (err?: string) => {} };
  let spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.execute(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith("Could not authenticate user with AWS Cognito");
  expect(res.locals.cognitoId).toBeUndefined();
  req = new MockRequest({}, "notTest");
  nextSpy = { next: (err?: string) => {} };
  spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.execute(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith("Could not authenticate user with AWS Cognito");
  expect(res.locals.cognitoId).toBeUndefined();
  req = new MockRequest({}, "test");
  nextSpy = { next: (err?: string) => {} };
  spy = jest.spyOn(nextSpy, "next");
  await authMiddleware.execute(req, res, nextSpy.next);
  expect(spy).toBeCalledTimes(1);
  expect(spy).toBeCalledWith();
  expect(res.locals.cognitoId).toBe("cognitoId");
});
