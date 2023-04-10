import { z } from "zod";
import { respond, successResponse, errorResponse } from "./respond";
import { Failure } from "./failures";

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
const mockControllerWithError = async (input: any) => {
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

  describe("controller", () => {
    it("should return a success response without validator", async () => {
      const response = await respond({
        controller: mockController,
      });

      expect(response).toEqual(successResponse("success"));
    });

    it("should return a success response with validator", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: JSON.stringify({ fail: false }),
      });

      expect(response).toEqual(successResponse("success"));
    });

    it("should return a failure response with validator", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: JSON.stringify({ fail: true }),
      });

      expect(response).toEqual(errorResponse(kMockFailure));
    });

    it("should return an error response with invalid input and validator", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: JSON.stringify({ fail: "not a boolean" }),
      });

      expect(response.statusCode).toBe(500);
      expect(response.body).toBeDefined();
    });

    it("should return a success response with APIGatewayProxyEventPathParameters", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: { fail: "false" },
      });

      expect(response).toEqual(successResponse("success"));
    });

    it("should return a success response with null body", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: null,
      });

      expect(response).toEqual(successResponse("success"));
    });

    it("should return a success response with undefined body", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: undefined,
      });

      expect(response).toEqual(successResponse("success"));
    });

    it("should return an error response when the controller throws an error", async () => {
      const response = await respond({
        controller: mockControllerWithError,
        validator: mockValidator,
        body: JSON.stringify({ fail: false }),
      });

      expect(response.statusCode).toBe(500);
      expect(response.body).toBeDefined();
    });

    describe("complex validator", () => {
      it("should return a success response with different input types", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: JSON.stringify({
            fail: false,
            name: "John",
            age: 30,
          }),
        });

        expect(response).toEqual(successResponse("success"));
      });

      it("should return a success response with string input values", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: { fail: "false", name: "John", age: "30" },
        });

        expect(response).toEqual(successResponse("success"));
      });

      it("should return an error response with invalid string input values", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: { fail: "not a boolean", name: "John", age: "not a number" },
        });

        expect(response.statusCode).toBe(500);
        expect(response.body).toBeDefined();
      });

      it("should return a success response with missing input values", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: JSON.stringify({}),
        });

        expect(response).toEqual(successResponse("success"));
      });

      it("should return a success response with empty string as input and validator", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: "",
        });

        expect(response).toEqual(successResponse("success"));
      });

      it("should return an error response with incorrect JSON string input", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: "{fail: false, name: 'John', age: 30}",
        });

        expect(response.statusCode).toBe(500);
        expect(response.body).toBeDefined();
      });

      it("should return an error response with invalid JSON string input", async () => {
        const response = await respond({
          controller: mockController,
          validator: complexValidator,
          body: "{fail: false, name: 'John', age: 30",
        });

        expect(response.statusCode).toBe(500);
        expect(response.body).toBeDefined();
      });
    });
  });
});
