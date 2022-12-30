// These are the HTTP routes for the backend
const kNearestGymsRoute = '/gym/nearest';
const kLogin = '/auth/login';
const kRegister = '/auth/register';
const kRefreshSession = '/auth/refreshSession';
const kGetUser = '/user';
const kAuth = '/auth';
const kTutorialExplore = '/user/tutorialExplore';
const kExplore = '/user/explore';
const kGym = '/gym';
const kFriends = '/relationship/friends';
const kRecentConvos = '/conversation/recents';
const kConfirmRegister = '/auth/confirmRegister';
const kResendConfirmation = '/auth/resendConfirmation';
const kForgotPassword = '/auth/forgotPassword';
const kResetPassword = '/auth/forgotPasswordSubmit';
const kGetMessages = '/message';
const kGetIncomingFriendRequests = '/relationship/receivedFriendRequests';
const kDenyFriendRequest = '/relationship/denyFriendRequest';
const kRemoveFriend = '/relationship/removeFriend';

// These are socket io events
const kMessage = 'message';
const kDirectMessage = 'directMessage';
const kFriendRequest = 'friendRequest';
