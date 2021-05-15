const router = require('express').Router();
const User = require('../models/User').User;

//delete product
router.delete('/:googleId', async (req, res)=>{

    try {
        let product = await User.findOne({ googleId: req.params.googleId });
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

module.exports = router;
