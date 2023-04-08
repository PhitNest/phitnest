import { useDgraph } from "./dgraph";

describe("useDgraph", () => {
  it("should connect to localhost for test cases", async () => {
    await expect(
      useDgraph(async (client) => {
        const healthResponse = (await client.getHealth()) as any;
        expect(healthResponse).toBeDefined();
        expect(healthResponse).toHaveLength(2);
        expect(healthResponse[0].status).toBe("healthy");
        expect(healthResponse[0].address).toMatch(RegExp("localhost:*"));
        expect(healthResponse[1].status).toBe("healthy");
        expect(healthResponse[1].address).toMatch(RegExp("localhost:*"));
      })
    ).resolves.toBe(void 0);
  });

  it("should pass through return values", async () => {
    const testValue = {
      name: "Hello world",
      details: {
        description: "This is a test",
        value: 42,
      },
    };
    await expect(useDgraph(async () => testValue)).resolves.toBe(testValue);
  });
});
