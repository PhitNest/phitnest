import { z } from "zod";
import { validateRequest } from "./request-handling";

const basicValidator = z.object({
  name: z.string(),
  number: z.number(),
});

async function basicController(data: object) {
  return {
    statusCode: 200 as const,
    body: JSON.stringify(data),
  };
}

const ERROR_RESPONSE = { message: "Test Error" };

async function errorController() {
  throw ERROR_RESPONSE;
  return {
    statusCode: 200 as const,
  };
}

describe("validateRequest", () => {
  it("should return a 400 if the request body is invalid", async () => {
    const body = {
      name: "testName",
      number: "badNumber",
    };
    const response = await validateRequest({
      data: body,
      validator: basicValidator,
      controller: basicController,
    });
    expect(response.statusCode).toBe(400);
    expect(response.body).toBe(
      JSON.stringify({
        message: "number: Expected number, received string",
      })
    );
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
    expect(response.statusCode).toBe(200);
    expect(response.body).toBe(JSON.stringify(body));
  });

  it("should pass through errors with status code 500 and Content-Type=application/json", async () => {
    expect(
      await validateRequest({
        data: {
          name: "testName",
          number: 1,
        },
        validator: basicValidator,
        controller: errorController,
      })
    ).toEqual({
      body: JSON.stringify(ERROR_RESPONSE),
      statusCode: 500,
      headers: {
        "Content-Type": "application/json",
      },
    });
  });

  it("should pass through empty bodies with no Content-Type header", async () => {
    expect(
      await validateRequest({
        data: {
          name: "testName",
          number: 1,
        },
        validator: basicValidator,
        controller: async () => ({
          statusCode: 200,
        }),
      })
    ).toEqual({
      statusCode: 200,
      body: "",
    });
  });

  it("should pass through headers", async () => {
    const expectedHeaders = {
      "Content-Type": "text/plain" as const,
      somethingElse: "somethingElse",
    };
    expect(
      await validateRequest({
        data: {
          name: "testName",
          number: 1,
        },
        validator: basicValidator,
        controller: async () => ({
          statusCode: 200,
          headers: expectedHeaders,
        }),
      })
    ).toEqual({
      statusCode: 200,
      body: "",
      headers: expectedHeaders,
    });
  });
});
