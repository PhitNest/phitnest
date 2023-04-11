import { mockPost } from "../../testing/mock";
import { kLocationNotFound } from "../../common/failures";
import { invoke } from "./post";

describe("POST /gym", () => {
  it("should fail for no body", async () => {
    const response = await invoke(mockPost(undefined));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should fail for an invalid body", async () => {
    const response = await invoke(mockPost({ invalid: true }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should fail for an invalid address", async () => {
    expect(
      await invoke(
        mockPost({
          street: "1234 Invalid Street",
          city: "Invalid City",
          state: "Invalid State",
          zipCode: "12345",
          name: "Invalid Gym",
        })
      )
    ).toEqual({
      statusCode: 500,
      body: JSON.stringify(kLocationNotFound),
    });
  });

  it("should create a gym for a valid address", async () => {
    const response = await invoke(
      mockPost({
        street: "501 Jackson St",
        city: "Blacksburg",
        state: "Virginia",
        zipCode: "24060",
        name: "Planet Fitness",
      })
    );
    expect(response.statusCode).toBe(200);
    const data = JSON.parse(response.body).data;
    expect(data.code).toEqual("Success");
    expect(data.message).toEqual("Done");
    expect(data.uids).toBeDefined();
    expect(Object.entries(data.uids)).toHaveLength(1);
  });
});
