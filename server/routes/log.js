const router = require('express').Router();
const Logs = require('../models/User').Logs;

router.get('/:googleId', async (req,res)=>{
    doc = await Logs.findOne({ googleId: req.params.googleId}); 
    if(doc)
    {
    res.send(doc.logs)
    }
})
module.exports = router;
