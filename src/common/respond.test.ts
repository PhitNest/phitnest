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

describe("respond", () => {
  test("successResponse", () => {
    const response = successResponse("success");
    expect(response).toEqual({
      statusCode: 200,
      body: JSON.stringify("success"),
    });
  });

  test("errorResponse", () => {
    const response = errorResponse(kMockFailure);
    expect(response).toEqual({
      statusCode: 500,
      body: JSON.stringify(kMockFailure),
    });
  });

  describe("respond", () => {
    test("Successful controller call without validator", async () => {
      const response = await respond({
        controller: mockController,
      });

      expect(response).toEqual(successResponse("success"));
    });

    test("Successful controller call with validator", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: JSON.stringify({ fail: false }),
      });

      expect(response).toEqual(successResponse("success"));
    });

    test("Controller call returns Failure", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: JSON.stringify({ fail: true }),
      });

      expect(response).toEqual(errorResponse(kMockFailure));
    });

    test("Invalid input to controller with validator", async () => {
      const response = await respond({
        controller: mockController,
        validator: mockValidator,
        body: JSON.stringify({ fail: "not a boolean" }),
      });

      expect(response.statusCode).toBe(500);
      expect(response.body).toBeDefined();
    });
  });
});
