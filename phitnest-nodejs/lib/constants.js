module.exports = {
  millisPerYear: 1000 * 60 * 60 * 24 * 365,
  minEmailLength: 3,
  maxEmailLength: 30,
  minPasswordLength: 6,
  maxPasswordLength: 20,
  mobileRegex:
    /(^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$)/,
  minPhoneNumberLength: 1,
  maxPhoneNumberLength: 16,
  minFirstNameLength: 2,
  maxFirstNameLength: 16,
  minLastNameLength: 0,
  maxLastNameLength: 16,
  minAge: 13,
  minMessageLength: 1,
  maxMessageLength: 64,
  minBioLength: 0,
  maxBioLength: 64,
  conversationCacheHours: 24,
  conversationCachePrefix: "conversationData",
  userCacheHours: 2,
  userCachePrefix: "userData",
  messageCacheHours: 2,
  messageCachePrefix: "messageData",
  conversationRecentMessagesCacheHours: 48,
  conversationRecentMessagesCachePrefix: "conversationRecentMessages",
};
