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

export function deleteUser(app: any, accessToken: string) {
  return supertest(app)
    .delete("/user")
    .set("Authorization", `Bearer ${accessToken}`)
    .send()
    .expect(200);
}

export async function login(
  app: any,
  email: string,
  password: string
): Promise<string> {
  return supertest(app)
    .post("/auth/login")
    .send({ email: email, password: password })
    .expect(200)
    .then((res: Response) => res.body.accessToken);
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
  const accessToken = await login(app, email, password);
  return await supertest(app)
    .get("/user")
    .set("Authorization", `Bearer ${accessToken}`)
    .send()
    .expect(200)
    .then(async (res: Response) => res.body.cognitoId);
}
