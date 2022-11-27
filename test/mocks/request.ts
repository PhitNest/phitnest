import { IRequest } from "../../src/adapters/types";

export class MockRequest implements IRequest {
  data: any;
  accessToken?: string;

  constructor(data: any, accessToken?: string) {
    this.data = data;
    this.accessToken = `Bearer ${accessToken}`;
  }

  content() {
    return this.data;
  }

  authorization() {
    return this.accessToken ?? null;
  }
}
