import {User, IUserModel} from '../server/src/models/user.model';
import {Gym, IGymModel} from '../server/src/models/gym.model';
import { AddressModel } from '../server/src/models/address.model';
import { LocationModel } from '../server/src/models/location.model';

export const testGymAddress = new AddressModel(
    '413 E Roanoke St',
    'Blacksburg',
    'VA',
    '24060'
);

export const testGymLocation = new LocationModel(-80.4138162, 37.2294115);

export const testGym : IGymModel = new Gym({
    name: 'Planet Fitness',
    address: testGymAddress,
    location: testGymLocation
});

// This user is already created within the cognito user pool.
// Don't modify the id or email
export const testUser : IUserModel = new User({
    cognitoId: 'c38c3260-3b40-4e8b-9d12-d6734f5bca64',
    gymId: testGym._id,
    email: 'jp@phitnest.com',
    firstName: 'John',
    lastName: 'Jones'
});

// This is the password for the above user. 
export const testUserPassword = "H3llOW0RLD$$"