const router = require('express').Router();
const jwt = require('jsonwebtoken');
const User = require('../models/User').User;
const Logs = require('../models/User').Logs;

//function to create jwt tokens
function jwtToken(user) {
	//create and assigning the tokens
	const token = jwt.sign({ _id: user._id }, process.env.TOKEN_SECRET);
	return token;
}

//register and log in route
router.post('/', async (req, res) => {
	//create a user
	const user = new User({
		googleId: req.body.googleId,
		name: req.body.name,
		companyName: req.body.companyName,
		email: req.body.email,
		phone: req.body.phone,
	});
	const log = new Logs({
		googleId : req.body.googleId
	})
	try {
		const savedUser = await user.save();
		const savedLog = await log.save();
		let token = jwtToken(savedUser._id);
		res.header('auth_Token', token).send({
			authToken: token,
			companyName: savedUser.companyName,
		});

	} catch (err) {
		res.status(400).send({
			message: err,
		});
	}
});

router.post('/checkIfUserExist', async (req, res) => {
	console.log('here');
	//this is for logging in, if the user exists then just send the googleID
	const emailExist = await User.findOne({
		googleId: req.body.googleId,
	});
	if (emailExist) {
		let token = jwtToken(emailExist._id);
		res.header('auth_Token', token).send({
			authToken: token,
			companyName: emailExist.companyName,
		});
	} else {
		//if the user does not exist, create a user
		res.status(404).send('isNotThere');
	}
});

module.exports = router;
