const router = require('express').Router();
const User = require('../models/User');

router.get('/:googleId', async(req,res) => {
  try {
  let allProducts = await User.findOne({ googleId: req.params.googleId });
  allProducts = allProducts.inventory;
  if (allProducts.length === 0)
    res.status(400).send('There are no products to display');
  else res.json(allProducts);
} catch (err) {
  res.status(400).send('Invalid ID');
}
});
