const joi = require("joi");
const {
  millisPerYear,
  minAge,
  minLastNameLength,
  maxLastNameLength,
  minFirstNameLength,
  maxFirstNameLength,
  minBioLength,
  maxBioLength,
  userCachePrefix,
  userCacheHours,
} = require("../../constants");
const { userModel } = require("../../models");
const { checkCacheOrQuery } = require("../helpers");

function validate(data) {
  const schema = joi.object({
    firstName: joi
      .string()
      .trim()
      .min(minFirstNameLength)
      .max(maxFirstNameLength)
      .optional(),
    lastName: joi
      .string()
      .trim()
      .min(minLastNameLength)
      .max(maxLastNameLength)
      .optional(),
    bio: joi.string().trim().min(minBioLength).max(maxBioLength).optional(),
    birthday: joi
      .date()
      .max(Date.now() - millisPerYear * minAge)
      .optional(),
  });
  return schema.validate(data);
}

module.exports = (socket) => {
  socket.on("updatePublicData", async (data) => {
    const { error } = validate(data);
    if (error) {
      socket.emit("error", error);
    } else {
      try {
        const user = await checkCacheOrQuery(
          socket.data.redis,
          userCachePrefix,
          userCacheHours,
          userModel,
          socket.data.userId
        );
        if (user) {
          user.firstName = data.firstName ?? user.firstName;
          user.lastName = data.lastName ?? user.lastName;
          user.bio = data.bio ?? user.bio;
          user.birthday = data.birthday ?? user.birthday;
          await Promise.all([
            userModel.updateOne({ _id: user._id }, user),
            socket.data.redis.set(
              `${userCachePrefix}/${user._id}`,
              JSON.stringify(user),
              { EX: 60 * 60 * userCacheHours }
            ),
          ]);
          socket.broadcast
            .to(`userListener:${user._id}`)
            .emit("userUpdated", data);
        } else {
          socket.emit("error", "You are not authenticated.");
        }
      } catch (error) {
        socket.emit("error", error);
      }
    }
  });
};
