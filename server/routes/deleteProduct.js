const router = require('express').Router();
const User = require('../models/User');

//delete product
router.delete('/:googleId', async (req, res)=>{

    try {
        // deleting the product from user collection
        // const product = await User.findOne({ googleId : req.params.googleId });
        // let product1 = product.inventory;
        //const del = await product1.findOneAndDelete({ productId: req.body.productId });
        // product.inventory.productId( req.body.productId ).remove();
        // const del1 = await product.save();
        // res.status(200).send(del1);

        const doc = await User.findOne({ googleId : req.params.googleId });
        for (let i = 0; i < doc.inventory.length; i++) 
            if (doc.inventory[i].productId == req.body.productId)
                did = doc.inventory[i]._id
        doc.inventory.pull({_id : did })
            
        //doc.inventory.remove({productId : req.body.productId})
        //const doc = await User.findOneAndUpdate({ googleId : req.params.googleId} ,{ $pull:{ "inventory.productId" : req.body.productId }},{new: true, useFindAndModify: false});
        doc.save();
        res.status(200).send(doc);

    } catch (err) {
        res.status(400).send(err)
    }
});

//delete user
router.delete('/user/:googleId',async (req,res)=>{
    try {
        const del = await User.findOneAndDelete({ googleId: req.params.googleId });
        res.status(200).send(del)
    } catch (err) {
        res.status(400).send(err)
    }
});

module.exports = router;
