const mongoose = require('mongoose');
const emailMatch = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/

const userSchema = mongoose.Schema({
    email: {
        type: String, required: true, unique: true, match: emailMatch
    },
    password: {
        type: String, required: true, select: false
    },
    lastLogin: {
        type: Date,
    },

}, { timestamps: true });

const userModel = mongoose.model('User', userSchema);

module.exports = {
    userModel: userModel,
    userSchema: userSchema
}