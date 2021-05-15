const mongoose = require('mongoose');

const inventorySchema = new mongoose.Schema({
  productId: String,
  name : String,
  quantity :{
    type : Number,
    default: 0
  },
  price: String
});

const userSchema = new mongoose.Schema({
  googleId : String,
  name : String,
  companyName: String,
  email: String,
  phone : String,
  inventory: [inventorySchema]
});

const logsSchema = new mongoose.Schema({
  googleId : String,
  logs: [String],
})
exports.Logs = mongoose.model('Logs', logsSchema);
exports.User = mongoose.model('User', userSchema);