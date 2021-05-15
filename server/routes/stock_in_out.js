const router = require('express').Router();
const User = require('../models/User');

router.patch('/add/:googleId', async (req,res)=>{

    try {
       let doc = await User.findOne({ googleId: req.params.googleId });
    for (let i = 0; i < doc.inventory.length; i++) {
        if( doc.inventory[i].productId == req.body.productId)
        {   doc.inventory[i].quantity += req.body.value;
            break;
        }
    }
   const old = await doc.save();
    res.status(200).send("Updated");

    } catch (err) {
        res.status(400).send(err);    
    }
})

router.patch('/remove/:googleId', async (req,res)=>{

    try {
       let doc = await User.findOne({ googleId: req.params.googleId });
    for (let i = 0; i < doc.inventory.length; i++) {
        if( doc.inventory[i].productId == req.body.productId)
        {   doc.inventory[i].quantity -= req.body.value;
            break;
        }
    }
   const old = await doc.save();
    res.status(200).send("Updated");

    } catch (err) {
        res.status(400).send(err);    
    }
})

module.exports = router;