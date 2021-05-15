const express = require('express');
const app = express();
const dotenv = require('dotenv');
const colors = require('colors');
dotenv.config(); //To access/config the DB connection token

//import routes
const authRoute = require('./routes/auth.js');
const pdfRoute = require('./routes/pdf.js');
const searchRoute = require('./routes/search');
dotenv.config();

//Connect to DB
const connectDB = require('./config/db');
connectDB();
const port = process.env.PORT;

//Middleware
app.use(express.json());

//Route Middlewares
app.use('/api/search', searchRoute);
app.use('/api/oauth', authRoute);
app.use('/api/pdf', pdfRoute);

app.listen(port, () =>
	console.log(`Server is running on port ${port}`.yellow.bold)
);
