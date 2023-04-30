import {
  allOfTerms,
  allOfText,
  anyOfTerms,
  anyOfText,
  useDgraph,
} from "./dgraph";

describe("anyOfTerms", () => {
  it("should return a proper dql filter", () => {
    expect(anyOfTerms(["name", "description"], "test")).toBe(
      '@filter(anyofterms(name, "test") OR anyofterms(description, "test"))'
    );

    expect(anyOfTerms(["name"], "test")).toBe(
      '@filter(anyofterms(name, "test"))'
    );

    expect(anyOfTerms([], "test")).toBe("");
  });
});

describe("allOfTerms", () => {
  it("should return a proper dql filter", () => {
    expect(allOfTerms(["name", "description"], "test")).toBe(
      '@filter(allofterms(name, "test") AND allofterms(description, "test"))'
    );

    expect(allOfTerms(["name"], "test")).toBe(
      '@filter(allofterms(name, "test"))'
    );

    expect(allOfTerms([], "test")).toBe("");
  });
});

describe("anyOfText", () => {
  it("should return a proper dql filter", () => {
    expect(anyOfText(["name", "description"], "test")).toBe(
      '@filter(anyoftext(name, "test") OR anyoftext(description, "test"))'
    );

    expect(anyOfText(["name"], "test")).toBe(
      '@filter(anyoftext(name, "test"))'
    );

    expect(anyOfText([], "test")).toBe("");
  });
});

describe("allOfText", () => {
  it("should return a proper dql filter", () => {
    expect(allOfText(["name", "description"], "test")).toBe(
      '@filter(alloftext(name, "test") AND alloftext(description, "test"))'
    );

    expect(allOfText(["name"], "test")).toBe(
      '@filter(alloftext(name, "test"))'
    );

    expect(allOfText([], "test")).toBe("");
  });
});

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
