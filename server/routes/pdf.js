const router = require('express').Router();
const PDFDocument = require('pdfkit');
const fs = require('fs');
const User = require('../models/User').User;
const os = require('os');

router.get('/:googleId', async (req, res) => {
	const data = await User.findOne({
		googleId: req.params.googleId,
	}).exec();
	if (!data) {
		res.send('Invalid');
	} else {
		try {
			let pdfDoc = new PDFDocument();
			pdfDoc.pipe(
				fs.createWriteStream(`Invoice.pdf`)
			);
			pdfDoc.pipe(res);
			const data = await User.findOne({
				googleId: req.params.googleId,
			}).exec();

			pdfDoc.fontSize(25).text('Invoice', {
				height: 400,
				align: 'center',
			});

			pdfDoc.font('Times-Roman', 13).text(`Name: ${data.name}`, {
				height: 100,
				width: 200,
				align: 'left',
			});

			pdfDoc.font('Times-Roman', 13).text(`Company Name: ${data.companyName}`, {
				height: 100,
				width: 200,
				align: 'left',
			});

			pdfDoc.font('Times-Roman', 13).text(`Email: ${data.email}`, {
				height: 100,
				width: 200,
				align: 'left',
			});

			pdfDoc.font('Times-Roman', 13).text(`Phone Number: ${data.phone}`, {
				height: 100,
				width: 200,
				align: 'left',
			});

			pdfDoc.fontSize(25).text('Inventory Goods:', {
				height: 400,
				align: 'left',
			});

			data1 = data.inventory;

			for (i = 0; i < data1.length; i++) {
				let name = data1[i].name;
				let quantity = data1[i].quantity;
				let price = data1[i].price;
				pdfDoc.font('Times-Roman', 13).text(`Good Name:${name}`, {
					height: 100,
					width: 200,
					align: 'left',
				});

				pdfDoc.font('Times-Roman', 13).text(`Quantity:${quantity}`, {
					height: 100,
					width: 200,
					align: 'left',
				});

				pdfDoc.font('Times-Roman', 13).text(`Price:${price}`, {
					height: 100,
					width: 200,
					align: 'left',
				});
			}

			pdfDoc.end();
		} catch (err) {
			res.status(400).json({
				message: err,
			});
		}
	}
});

module.exports = router;
