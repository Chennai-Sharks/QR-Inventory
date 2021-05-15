const router = require('express').Router();
const User = require('../models/User');

router.post('/:googleId', async(req,res) => {

    //checks if product ID already exists
    var product = await User.findOne({ googleId: req.params.googleId   });
    product = product.inventory;
    for(var i=0 ;i<product.length;i++)
    if( product[i].productId == req.body.productId)
    return res.status(400).send("Product ID already exists");

    //adds product detail to
    try{
        var pro = await User.findOne({ googleId: req.params.googleId  });
        pro.inventory.push({ productId: req.body.productId, ...req.body });
        savedProduct = await pro.save();
        res.send(savedProduct.inventory.pop());
    }
    catch (err){
        res.status(400).send({message: err});
    }
});

module.exports = router;
