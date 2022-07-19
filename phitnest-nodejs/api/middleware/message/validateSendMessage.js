const { conversationModel } = require('../../models/conversation');
const errorJson = require('../../../utils/error');
const { messageValidator } = require('../validators');
const joi = require('joi');

function validateMessage(req) {
    const schema = joi.object({
        conversation: joi.string(),
        message: messageValidator,
    });
    return schema.validate(req);
}

module.exports = async (req, res, next) => {
    const { error } = validateMessage(req.body);
    if (error) {
        let errorMessage = '';
        if (error.details[0].message.includes('conversation')) {
            errorMessage = 'Please provide a valid conversation id.';
        }
        else if (error.details[0].message.includes('message')) {
            errorMessage = 'Please provide a valid message.';
        }
        else {
            errorMessage = 'Please provide the required fields.';
        }

        return res
            .status(400)
            .json(errorJson('Invalid Request', errorMessage));
    }

    try {
        const conversation = await conversationModel.findById(req.body.conversation);
        if (conversation) {
            return next();
        }
    } catch (error) { }
    return res.status(500).json(errorJson('Invalid ID', 'The query contained an invalid conversation id.'));
};