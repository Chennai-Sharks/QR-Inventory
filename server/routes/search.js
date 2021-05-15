const router = require('express').Router();
const User = require('../models/User');

// query as param  , googleId in body 
router.get('/:query', async (req,res)=>{
    await User.aggregate([
        // matching the doctor document
        {
            $match:  { googleId: req.body.id} 
        },

        //unwind the inventory array
        { "$unwind": "$inventory"},

        //using match to filter the matching inventory
        { "$match":{
            "$or":[
                { "inventory.name": {"$regex": req.params.query.toString() , "$options": "i" } },
                { "inventory.id": {"$regex": req.params.query.toString() , "$options": "i" } }
            ]
        }},

        // inventory array is put back together
        {
            $group: {
                "_id": "$_id",
            //  "name":{ "$first": "$name" },  // syntax for adding non array type fields
                "inventory":{ "$push": "$inventory"}
            }
        }

     ]).exec(function (err, result) {
        if (err) return res.status(400).send(err);
        res.send(result);
      });
})

module.exports = router;