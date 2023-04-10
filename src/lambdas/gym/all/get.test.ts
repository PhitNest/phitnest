import { mockGet } from "../../../common/mock";
import { invoke } from "./get";

describe("GET /gym/all", () => {
  it("should fail for a negative or 0 limit", async () => {
    let response = await invoke(mockGet({ limit: "-10" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
    response = await invoke(mockGet({ limit: "0" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should fail for a negative page", async () => {
    const response = await invoke(mockGet({ page: "-10" }));
    expect(response.statusCode).toBe(500);
    expect(JSON.parse(response.body)).toHaveProperty("name", "ZodError");
  });

  it("should pass for page zero", async () => {
    const response = await invoke(mockGet({ page: "0" }));
    expect(response.statusCode).toBe(200);
    expect(response.body).toBe("[]");
  });
});
