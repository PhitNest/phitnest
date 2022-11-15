import supertest, { Response } from "supertest";
import { AddressModel } from "../server/src/models/address.model";
import { Gym } from "../server/src/models/gym.model";
import { LocationModel } from "../server/src/models/location.model";

export function getHeader(accessToken: string): string {
  return `Bearer ${accessToken}`;
}

export async function createGym(
  name: string,
  address: AddressModel,
  location: LocationModel
): Promise<string> {
  return (
    await Gym.create({ name: name, address: address, location: location })
  )._id;
}

export async function deleteUser(app: any, accessToken: string) {
  await supertest(app)
    .delete("/user")
    .set("Authorization", `Bearer ${accessToken}`)
    .send()
    .expect(200);
}

export async function createUser(
  app: any,
  email: string,
  gymId: string,
  password: string,
  firstName: string,
  lastName: string
): Promise<string> {
  await supertest(app)
    .post("/auth/register")
    .send({
      email: email,
      gymId: gymId,
      password: password,
      firstName: firstName,
      lastName: lastName,
    })
    .expect(200);
  let accessToken: string;
  await supertest(app)
    .post("/auth/login")
    .send({
      email: email,
      password: password,
    })
    .expect(200)
    .then((res: Response) => {
      accessToken = res.body.accessToken;
    });
  let cognitoId: string;
  await supertest(app)
    .get("/user")
    .set("Authorization", `Bearer ${accessToken}`)
    .send()
    .expect(200)
    .then(async (res: Response) => {
      cognitoId = res.body.cognitoId;
    });
  return cognitoId;
}
