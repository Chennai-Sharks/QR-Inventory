const router = require('express').Router();
const User = require('../models/User');

router.delete('/:googleId', async (req, res)=>{

    try {
        // deleting the product from user collection
        const product = await User.findOne({ googleId : req.params.googleId });
        let product1 = product.inventory;
        const del = product1.findOneAndDelete({ productId: req.body.productId });
        //product.inventory.productId( req.body.productId ).remove();
        //const del = await product.save();
        res.status(200).send(del);
    } catch (err) {
        res.status(400).send(err)
    }
});

module.exports = router;
