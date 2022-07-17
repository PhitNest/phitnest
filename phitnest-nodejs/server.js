const express = require('express');
const bodyParser = require('body-parser');
const morgan = require('morgan');
const dotenv = require('dotenv');
const mongoose = require('./api/middleware/db');
const errorJson = require('./utils/error');
const rateLimiter = require('./api/middleware/rateLimiter');
const Routes = require('./api/routes');
const app = express();
dotenv.config();

process.on('uncaughtException', (error) => {
	console.log(error);
});

process.on('unhandledRejection', (ex) => {
	console.log(ex);
});

const PORT = process.env.port || 3000;

app.use(morgan('dev'));
app.use(rateLimiter);

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.set('trust proxy', true);
mongoose.db();

app.get('/', (req, res) => {
	res.status(200).json({ resultMessage: 'Requests are working successfully...' });
});
app.use('/', Routes);
app.use((req, res, next) => {
	res.header('Access-Control-Allow-Origin', '*');
	res.header('Access-Control-Allow-Headers',
		'Origin, X-Requested-With, Content-Type, Accept, Authorization');
	res.header('Content-Security-Policy-Report-Only', 'default-src: https:');
	if (req.method === 'OPTIONS') {
		res.header('Access-Control-Allow-Methods', 'PUT POST PATCH DELETE, GET');
		return res.status(200).json({});
	}
	next();

});

app.use((error, req, res, next) => {
	res.status(error.status || 500);
	if (res.status === 500) {
		res.json({
			resultMessage: { msg: error.message }
		})
	} else if (error.status === 404) {
		res.json({
			resultMessage: { msg: error.message }
		})
	} else {
		res.json(errorJson(error.message, 'External Error'));

	}
});

app.listen(PORT, () => console.log(`Server is running on ${PORT}`));