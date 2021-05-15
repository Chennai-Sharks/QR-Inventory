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
    if(Array.isArray(alertArr) && alertArr.length == 0) res.status(200).send("There are no products which are understocked. Good to go!");
    else res.status(200).send(alertArr);
    }
   catch (err) {
      res.status(400).send(err)
  }
});

module.exports = router;
