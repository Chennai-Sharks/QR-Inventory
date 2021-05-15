const router = require('express').Router();
const Logs = require('../models/User').Logs;

router.get('/:googleId', async (req, res) => {
	try {
		doc = await Logs.findOne({ googleId: req.params.googleId });
		if (doc) {
			res.send(doc.logs);
		} else res.status(400).send('No logs');
	} catch (error) {
		console.log(error);
		res.send(400).send('Error');
	}
});
module.exports = router;
