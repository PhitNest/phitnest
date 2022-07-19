const mongoose = require('mongoose');

const conversationSchema = mongoose.Schema({
    participants: {
        type: Array, of: String, required: true
    }
}, { timestamps: true });

const conversationModel = mongoose.model('Conversation', conversationSchema);

module.exports = {
    conversationModel: conversationModel,
    conversationSchema: conversationSchema,
}