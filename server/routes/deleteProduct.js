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

        let product = await User.findOne({ googleId: req.params.googleId });
        //product.inventory.id(_id).remove();
        for(let i=0;i<product.inventory.length;i++){
          if(product.inventory[i].productId == req.body.productId){
            product.inventory[i].remove();
            const del = await product.save();
            res.status(200).send("Deleted");
          }else{
          res.status(400).send("Product does not exist");
        }
      }
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
