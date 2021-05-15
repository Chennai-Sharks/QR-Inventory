const router = require('express').Router();
const User = require('../models/User');

router.get('/:googleId', async(req,res) => {
  try {
      let product = await User.findOne({ googleId: req.params.googleId });
      let alertArr = [];
      for(let i=0;i<product.inventory.length;i++){
        let check = product.inventory[i].quantity;
        if(check <= 25){
            alertArr.push(product.inventory[i]);
        }
    }
    res.status(200).send(alertArr);
    }
   catch (err) {
      res.status(400).send(err)
  }
});

module.exports = router;
