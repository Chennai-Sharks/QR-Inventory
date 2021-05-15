const Logs = require('../models/User').Logs;

module.exports = async function logger(req, res , next){
    path = req.path
    var logString
    googleId= req.path.split('/').pop();
    doc = await Logs.findOne({ googleId: googleId }); 
    if(path.includes('addProduct'))
        logString = "ADDED product of Id:"+req.body.productId+" and of quantity:"+req.body.quantity+" at ";

    else if(path.includes("deleteProduct"))
        logString = "REMOVED product of Id:"+req.body.productId+" at ";

    else if(path.includes("add"))
        logString = req.body.value.toString()+" items of "+req.body.productId+" ADDED at ";

    else if(path.includes("remove"))
        logString = req.body.value.toString()+" items of "+req.body.productId+" REMOVED at ";
    
    dateTime = new Date();
    logString+=dateTime.toLocaleString()
    if(doc){
    doc.logs.push(logString)
    await doc.save();
    }
    next();
}