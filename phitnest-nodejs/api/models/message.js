const mongoose = require('mongoose');

const messageSchema = mongoose.Schema({
    conversation: {
        type: String, required: true
    },
    message: {
        type: String, required: true, trim: true
    },
    sender: {
        type: String, required: true
    },
    readBy: {
        type: Map, of: Boolean, default: {}
    },
}, { timestamps: true });

const messageModel = mongoose.model('Message', messageSchema);

module.exports = {
    messageModel: messageModel,
    messageSchema: messageSchema
}