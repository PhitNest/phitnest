import {User, IUserModel} from '../server/src/models/user.model';

// This user is already created within the cognito user pool.
// Don't modify the id or email
export const testUser : IUserModel = new User({
    id: 'c38c3260-3b40-4e8b-9d12-d6734f5bca64',
    email: 'jp@phitnest.com',
    firstName: 'John',
    lastName: 'Jones'
});

// This is the password for the above user. 
export const testUserPassword = "H3llOW0RLD$$"