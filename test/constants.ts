import { User } from "../server/src/models/user.model";
import { Gym } from "../server/src/models/gym.model";
import { AddressModel } from "../server/src/models/address.model";
import { LocationModel } from "../server/src/models/location.model";

export const testGyms = [
  new Gym({
    name: "Planet Fitness",
    address: new AddressModel("413 E Roanoke St", "Blacksburg", "VA", "24060"),
    location: new LocationModel(-80.4138162, 37.2294115),
  }),
  new Gym({
    name: "Gold's Gym",
    address: new AddressModel(
      "4835 W Wendover Ave",
      "Jamestown",
      "NC",
      "27282"
    ),
    location: new LocationModel(-79.9250084, 36.0441817),
  }),
  new Gym({
    name: "Anytime Fitness",
    address: new AddressModel("606 S 42nd St", "Mt Vernon", "IL", "62864"),
    location: new LocationModel(-88.94205681362725, 38.31358323246493),
  }),
  new Gym({
    name: "Midwest Barbell Club",
    address: new AddressModel("12916 MO-21", "De Soto", "MO", "63020"),
    location: new LocationModel(-90.58006764237705, 38.14525512557396),
  }),
];

// These users are already created within the cognito user pool.
// Don't modify the id or email
export const testUsers = [
  new User({
    cognitoId: "788f8252-5383-4f0c-88f6-efe447b2b878",
    gymId: testGyms[0]._id,
    email: "jp@phitnest.com",
    firstName: "John",
    lastName: "Jones",
  }),
  new User({
    cognitoId: "ce909a14-4f1f-4632-8b65-a25414b1426f",
    gymId: testGyms[0]._id,
    email: "jpTest2@phitnest.com",
    firstName: "Joe",
    lastName: "James",
  }),
  new User({
    cognitoId: "03b7175e-1dcc-4adf-87e3-8aa2d4f7f6d8",
    gymId: testGyms[0]._id,
    email: "jpTest3@phitnest.com",
    firstName: "Jack",
    lastName: "Jonah",
  }),
  new User({
    cognitoId: "528ad8de-cd66-46ca-9236-a70e7d38d134",
    gymId: testGyms[0]._id,
    email: "jpTest4@phitnest.com",
    firstName: "Jack",
    lastName: "Sparrow",
  }),
  new User({
    cognitoId: "5c42288d-e434-4934-8809-e9c102b96771",
    gymId: testGyms[0]._id,
    email: "jpTest5@phitnest.com",
    firstName: "Jacob",
    lastName: "Jones",
  }),
  new User({
    cognitoId: "1be33f64-fc6e-488d-b151-3eb34594bc69",
    gymId: testGyms[1]._id,
    email: "jpTest6@phitnest.com",
    firstName: "Other-Gym",
    lastName: "Guy",
  }),
];

// This is the password for the above user.
export const testUserPassword = "H3llOW0RLD$$";

export async function setup() {
  await Promise.all(testGyms.map((gym) => gym.save()));
  await Promise.all(testUsers.map((user) => user.save()));
}
