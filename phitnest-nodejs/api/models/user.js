const mongoose = require('mongoose');
const emailMatch = /[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?/

const userSchema = mongoose.Schema({
    email: {
        type: String, required: true, unique: true, match: emailMatch, trim: true
    },
    password: {
        type: String, required: true, select: false
    },
    mobile: {
        type: String, required: true, unique: true, trim: true
    },
    firstName: {
        type: String, required: true, trim: true
    },
    lastName: {
        type: String, trim: true, default: ''
    },
    bio: {
        type: String, trim: true, default: ''
    },
    friends: {
        type: Array, of: String, default: []
    },
    conversations: {
        type: Array, of: String, default: []
    },
    online: {
        type: Boolean, default: true
    },
    lastLogin: {
        type: Date, required: true
    },

}, { timestamps: true });

const userModel = mongoose.model('User', userSchema);

module.exports = {
    userModel: userModel,
    userSchema: userSchema
}