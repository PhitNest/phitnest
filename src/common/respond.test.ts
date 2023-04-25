import { z } from "zod";
import { respond, successResponse, errorResponse } from "./respond";
import { Failure } from "./failures";
import { mockPost } from "../testing/mock";

const kMockFailure = new Failure("Failure", "Something went wrong");

// Mock a simple controller
const mockController = async (input: any) => {
  if (input && input.fail) {
    return kMockFailure;
  }
  return "success";
};

// Mock a simple validator
const mockValidator = z.object({
  fail: z.boolean().optional(),
});

// Mock a controller that throws an error
const mockControllerWithError = async () => {
  throw new Error("Unexpected error");
};

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
        body: JSON.stringify("success"),
      });
    });
  });

  describe("errorResponse", () => {
    it("should return an error response", () => {
      const response = errorResponse(kMockFailure);
      expect(response).toEqual({
        statusCode: 500,
        body: JSON.stringify(kMockFailure),
      });
    });
  });

  describe("Respond to POST", () => {
    const response = respond(
      mockPost({ fail: false }),
      mockController,
      mockValidator
    );
    expect(response).resolves.toEqual({
      statusCode: 200,
      body: JSON.stringify("success"),
    });
  });
});
