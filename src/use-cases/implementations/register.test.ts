import { MockAuthRepo } from "../../../test/mocks";
import {
  dependencies,
  injectRepository,
  injectUseCases,
  Repositories,
  UseCases,
} from "../../common/dependency-injection";
import { IGymEntity, LocationEntity } from "../../entities";
import { IAuthRepository, IGymRepository } from "../../repositories/interfaces";
import { IRegisterUseCase } from "../interfaces";

const testGym1 = {
  name: "Planet Fitness",
  address: {
    street: "522 Pine Song Ln",
    city: "Virginia Beach",
    state: "VA",
    zipCode: "23451",
  },
  location: new LocationEntity(-75.996, 36.85),
};

let registerUseCase: IRegisterUseCase;
let gymRepo: IGymRepository;
let authRepo: IAuthRepository;

beforeAll(async () => {
  gymRepo = dependencies.get(Repositories.gym);
  injectRepository(Repositories.auth, MockAuthRepo);
  injectUseCases();
  registerUseCase = dependencies.get(UseCases.register);
  authRepo = dependencies.get(Repositories.auth);
});

describe("Register Use Case", () => {
  let gym1: IGymEntity;

  beforeAll(async () => {
    gym1 = await gymRepo.create(testGym1);
    expect(gym1).toBeDefined();
  });

  test("Register user with invalid gym", async () => {
    await expect(
      registerUseCase.execute(
        "testEmail1@gmail.com",
        "testPassword1",
        "6388d20106e6bc30a3251f06",
        "testName1",
        "testName1"
      )
    ).rejects.toThrowError("Gym not found");
  });

  test("Register user with invalid password", async () => {
    await expect(
      registerUseCase.execute(
        "testEmail1@gmail.com",
        "test",
        gym1._id,
        "testName1",
        "testName1"
      )
    ).rejects.toThrowError("Could not register user with AWS Cognito");
  });

  test("Register user with valid credentials", async () => {
    await expect(
      registerUseCase.execute(
        "testEmail1@gmail.com",
        "testPassword$$022",
        gym1._id,
        "testName1",
        "testName1"
      )
    ).resolves.not.toThrowError();
  });
});
