import { mockPost } from "@/common/mock";
import { invoke } from "./post";
import Auth from "@/data/auth";

describe("/auth/register request", () => {
  it("Should validate requests", async () => {
    const emptyRequest = mockPost(undefined);
    const invalidRequest1 = mockPost({
      missingEmail: "abc@gmail.com",
      missingPassword: "hi",
    });
    const invalidRequest2 = mockPost({
      email: "abc@gmail.com",
    });
    const invalidRequest3 = mockPost({
      email: "abc@gmail.com",
      password: true,
      firstName: "John",
      lastName: "Doe",
    });
    const invalidRequest4 = mockPost({
      email: "abc@gmail.com",
      password: "abcd123",
      firstName: "John",
      lastName: "Doe",
    });

    expect((await invoke(emptyRequest[0])).statusCode).toBe(500);
    expect((await invoke(invalidRequest1[0])).statusCode).toBe(500);
    expect((await invoke(invalidRequest2[0])).statusCode).toBe(500);
    expect((await invoke(invalidRequest3[0])).statusCode).toBe(500);
    expect((await invoke(invalidRequest4[0])).statusCode).toBe(500);
  });
  it("Should call the register function from the auth data layer", async () => {
    const validRequest = mockPost({
      email: "abc@gmail.com",
      password: "abcd1234",
      firstName: "John",
      lastName: "Doe",
    });
    const spy = jest.spyOn(Auth, "register");
    const validResponse = await invoke(validRequest[0]);
    expect(validResponse.statusCode).toBe(200);
    expect(spy).toHaveBeenCalledTimes(1);
  });
});
