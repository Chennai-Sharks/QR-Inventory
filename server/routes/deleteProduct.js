const router = require('express').Router();
const User = require('../models/User');

//delete product
router.delete('/:googleId', async (req, res)=>{

    try {
        let product = await User.findOne({ googleId: req.params.googleId });
        let flag = 0;
        for(let i=0;i<product.inventory.length;i++){
          if(product.inventory[i].productId == req.body.productId){
            product.inventory[i].remove();
            const del = await product.save();
            flag = 1;
            res.status(200).send("Deleted");
          }
      }
      if(flag==0){
        res.status(400).send("Product does not exist");
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
