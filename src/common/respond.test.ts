import { z } from "zod";
import { respond, successResponse, errorResponse } from "./respond";
import { Failure } from "./failures";
import { mockPost } from "../testing/mock";

const FAILURE_RESPONSE = new Failure("Failure", "Something went wrong");
const SUCCESS_RESPONSE = '"success"';

// Mock a simple controller
const mockController = async (input: any) => {
  if (input && input.fail) {
    return FAILURE_RESPONSE;
  }
  return "success";
};

// Mock a simple validator
const mockValidator = z.object({
  fail: z.boolean().optional(),
});

// Mock a more complex validator
const complexValidator = z.object({
  fail: z.boolean().optional(),
  name: z.string().optional(),
  age: z.number().optional(),
});

describe("respond", () => {
  describe("successResponse", () => {
    it("should return a success response", () => {
      const response = successResponse("success");
      expect(response).toEqual({
        statusCode: 200,
        body: SUCCESS_RESPONSE,
      });
    });
  });

  describe("errorResponse", () => {
    it("should return an error response", () => {
      const response = errorResponse(FAILURE_RESPONSE);
      expect(response).toEqual({
        statusCode: 500,
        body: JSON.stringify(FAILURE_RESPONSE),
      });
    });
  });

  describe("Respond to POST", () => {
    let response = respond(
      mockPost({ fail: false }),
      mockController,
      mockValidator
    );
    expect(response).resolves.toEqual({
      statusCode: 200,
      body: SUCCESS_RESPONSE,
    });
    response = respond(mockPost({}), mockController, mockValidator);
    expect(response).resolves.toEqual({
      statusCode: 200,
      body: SUCCESS_RESPONSE,
    });
    response = respond(mockPost({ fail: true }), mockController, mockValidator);
    expect(response).resolves.toEqual({
      statusCode: 500,
      body: JSON.stringify(FAILURE_RESPONSE),
    });
  });

  describe("Respond to GET", () => {
    let response = respond(
      mockPost({ fail: false }),
      mockController,
      mockValidator
    );
    expect(response).resolves.toEqual({
      statusCode: 200,
      body: SUCCESS_RESPONSE,
    });
    response = respond(mockPost({}), mockController, mockValidator);
    expect(response).resolves.toEqual({
      statusCode: 200,
      body: SUCCESS_RESPONSE,
    });
    response = respond(mockPost({ fail: true }), mockController, mockValidator);
    expect(response).resolves.toEqual({
      statusCode: 500,
      body: JSON.stringify(FAILURE_RESPONSE),
    });
  });
});
