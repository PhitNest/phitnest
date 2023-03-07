import { kCognitoCredentials } from "@/data/auth";
import { invoke } from "./get";

describe("/auth/getCredentials request", () => {
  it("Should return the cognito credentials from the data layer", async () => {
    expect(await invoke()).toEqual({
      statusCode: 200,
      body: JSON.stringify(kCognitoCredentials),
    });
  });
});
