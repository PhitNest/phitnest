import { z } from "zod";
import {
  RequestError,
  Success,
  kDefaultHeaders,
  kZodErrorType,
  validateRequest,
} from "./request-handling";

const basicValidator = z.object({
  name: z.string(),
  number: z.number(),
});

async function basicController(data: Record<string, unknown>) {
  return new Success(data);
}

const kErrorResponse = new RequestError(
  "TestError",
  "This is an error used for a test case"
);

async function errorController() {
  return kErrorResponse;
  return new Success();
}

describe("validateRequest", () => {
  it("should return a 500 if the request body is invalid", async () => {
    const body = {
      name: "testName",
      number: "badNumber",
    };
    const response = await validateRequest({
      data: body,
      validator: basicValidator,
      controller: basicController,
    });
    expect(response.statusCode).toEqual(500);
    expect(JSON.parse(response.body)).toEqual({
      type: kZodErrorType,
      message: "number: Expected number, received string",
    });
  });

  it("should call the controller if the request body is valid", async () => {
    const body = {
      name: "testName",
      number: 1,
    };
    const response = await validateRequest({
      data: body,
      validator: basicValidator,
      controller: basicController,
    });
    expect(response.statusCode).toEqual(200);
    expect(JSON.parse(response.body)).toEqual(body);
  });

  it("should pass through errors with status code 500 and Content-Type=application/json", async () => {
    const res = await validateRequest({
      data: {
        name: "testName",
        number: 1,
      },
      validator: basicValidator,
      controller: errorController,
    });
    expect(res.statusCode).toEqual(500);
    expect(JSON.parse(res.body)).toEqual({
      message: kErrorResponse.message,
      type: kErrorResponse.type,
    });
    expect(res.headers).toEqual(kDefaultHeaders);
  });

  it("should pass through empty bodies with no Content-Type header", async () => {
    const res = await validateRequest({
      data: {
        name: "testName",
        number: 1,
      },
      validator: basicValidator,
      controller: async () => new Success(),
    });
    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual("");
    expect(res.headers).toBeUndefined();
  });

  it("should pass through headers", async () => {
    const expectedHeaders = {
      ...kDefaultHeaders,
      "Content-Type": "text/plain",
      somethingElse: "somethingElse",
    };
    const res = await validateRequest({
      data: {
        name: "testName",
        number: 1,
      },
      validator: basicValidator,
      controller: async () => new Success(undefined, expectedHeaders),
    });
    expect(res.statusCode).toEqual(200);
    expect(res.body).toEqual("");
    expect(res.headers).toEqual(expectedHeaders);
  });
});
