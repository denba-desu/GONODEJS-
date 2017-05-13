var express = require('express');
var mysql = require('mysql');
//var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
//var multer = require('multer');
//var upload = multer(); // for parsing multipart/form-data
//var expressValidator = require('express-validator');
var path = require('path')
var app = express();
var port = 3000;

app.set('views', './views');
app.set('view engine', 'pug');

app.use(express.static(__dirname + '/views'));
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({
	extended: false
}));
//app.use(expressValidator()); // Add this after the bodyParser middleware!

function getMySQLConnection() {
	return mysql.createConnection({
		host		: 'localhost',
		user		: 'root',
		password	: '',
		database	: 'webtek-2',
	});
}

app.get('/', function (req, res) {
	res.render('index');

})

app.get('/current_services', function (req, res) {
	var currentCustomerList = [];

	//Connect to MySQL database.
	var connection = getMySQLConnection();
	connection.connect();

	//Query to get data.
	connection.query('SELECT request_id,customer_name,service_name,scheduled_time,scheduled_day,status,IF(isPaid="T","Paid","Unpaid") as "Payment" FROM requests a, services b, customer c where (a.isAcceptedRequest="T" && b.service_id =any (select id_service from provider_specialization)) && (a.status != "Done" && id_customer = customer_id)', function (err, rows, fields) {
		if (err) {
			res.status(500).json({"status_code": 500, "status_message": "internal server error"});
		} else {

			// Loop check on each row
			for (var i = 0; i < rows.length; i++) {

				// Create on object to save current row's data
				var currentServices = {
					title: 'Current Services',
					'request_id': rows[i].request_id,
					'customer_name': rows[i].customer_name,
					'service_name':rows[i].service_name,
					'scheduled_time': rows[i].scheduled_time,
					'scheduled_day': rows[i].scheduled_day,
					'status': rows[i].status,
					'Payment': rows[i].Payment
				}
				// Add object into array
				currentCustomerList.push(currentServices);
			}

			// Render index.pug page using array
			res.render('current_services', {"currentCustomerList": currentCustomerList});
		}
	});
	connection.end();
})

app.post('/status', function (req, res) {
	var request_id = req.body.request_id;
	var connection = getMySQLConnection();
	connection.connect();

	connection.query('UPDATE requests SET status="Done" WHERE request_id = ?;', [request_id], function (err, row, fields) {
		var html = 'You successfully updated the service status of ID Request: ' + request_id + ' to "Done."' +
					'<br><a href=/current_services>Click here to go back in Current Services</a>'
		res.send(html)
	})
	connection.end();
})

app.post('/payment', function (req, res) {
	var request_id1 = req.body.request_id1;
	var connection = getMySQLConnection();
	connection.connect();

	connection.query('UPDATE requests SET isPaid="T" WHERE request_id = ?;', [request_id1], function (err, row, fields) {
		var html = 'You successfully updated the payment status of ID Request: ' + request_id1 + ' to "Paid."' +
					'<br><a href=/current_services>Click here to go back in Current Services</a>'
		res.send(html)
	})
	connection.end();
})



app.get('/service_requests', function (req, res) {
	var serviceRequestsList = [];

	//Connect to MySQL database.
	var connection = getMySQLConnection();
	connection.connect();

	//Query to get data.
	connection.query('SELECT * FROM requests a, services b, customer c where (a.isAcceptedRequest="F" && b.service_id =any (select id_service from provider_specialization)) && id_customer = customer_id', function (err, rows, fields) {
		if (err) {
			res.status(500).json({"status_code": 500, "status_message": "internal server error"});
		} else {

			// Loop check on each row
			for (var i = 0; i < rows.length; i++) {

				// Create on object to save current row's data
				var serviceRequests = {
					title: 'Service Requests',
					message: 'Service Requests',
					'request_id': rows[i].request_id,
					'service_name': rows[i].service_name,
					'customer_name': rows[i].customer_name,
					'scheduled_time': rows[i].scheduled_time,
					'scheduled_day': rows[i].scheduled_day,
				}
				// Add object into array
				serviceRequestsList.push(serviceRequests);
			}

			// Render index.pug page using array
			res.render('service_requests', {"serviceRequestsList": serviceRequestsList});

		}
	});
	connection.end();
})

app.post('/service_requests', function(req, res) {	
	var request_id = req.body.request_id;
	var connection = getMySQLConnection();
	connection.connect();

	connection.query('UPDATE requests SET isAcceptedRequest="T" WHERE request_id = ?;', [request_id], function(err, row, fields){
		var html = 'You successfully accepted the request of ID Request: ' + request_id + '!' +
					'<br><a href=/service_requests>Click here to go back in Service Requests</a>'
		res.send(html)
	})
});


app.get('/history', function (req, res) {
	var historyServicesList = [];

	//Connect to MySQL database.
	var connection = getMySQLConnection();
	connection.connect();

	//Query to get data.
	connection.query('SELECT * FROM requests where isAcceptedRequest="T" and isPaid="T" and status="Done"', function (err, rows, fields) {
		if (err) {
			res.status(500).json({"status_code": 500, "status_message": "internal server error"});
		} else {

			// Loop check on each row
			for (var i = 0; i < rows.length; i++) {

				// Create on object to save current row's data
				var historyServices = {
					'request_id': rows[i].request_id,
					'id_specialization': rows[i].id_specialization,
					'id_customer': rows[i].id_customer,
					'scheduled_time': rows[i].scheduled_time,
					'scheduled_day': rows[i].scheduled_day,
					'status': rows[i].status,
					'isPaid': rows[i].isPaid
				}
				// Add object into array
				historyServicesList.push(historyServices);
			}

			// Render index.pug page using array
			res.render('history', {"historyServicesList": historyServicesList});
		}
	});
	connection.end();
})


app.get('/profile', function (req, res) {
	var connection = getMySQLConnection();
	connection.connect();

	connection.query('SELECT * from service_provider WHERE sp_id = "3004"', function (err, rows, fields) {
		if (err) {
			throw err
		} else {
		
			res.render('profile', {
				title : 'Your Profile',
				spid: rows[0].sp_id,
				fullname: rows[0].sp_name,
				email: rows[0].sp_email,
				description : rows[0].sp_desc,
				age : rows[0].sp_age,
				contactno : rows[0].sp_contactno,
				gender : rows[0].sp_gender,
				homeaddress : rows[0].sp_homeaddress
			});
		}
		connection.end();
	})
})
	


app.get('/edit_profile', function (req, res) {
	var connection = getMySQLConnection();
	connection.connect();

	connection.query('SELECT * from service_provider WHERE sp_id = "3004"', function (err, rows, fields) {
		if (err) {
			throw err
		} else {
			res.render('edit_profile', {
				title : 'Edit your Profile',
				spid: rows[0].sp_id,
				fullname: rows[0].sp_name,
				email: rows[0].sp_email,
				description : rows[0].sp_desc,
				age : rows[0].sp_age,
				contactno : rows[0].sp_contactno,
				gender : rows[0].sp_gender,
				homeaddress : rows[0].sp_homeaddress
			})
		}
		connection.end();
	})
})

app.get('/account_settings', function (req, res) {
	res.render('account_settings', {
		title: 'Account Settings',
		message: 'Page for the account settings.'
	})
})


app.get('/update_profile', function(req, res) {
	res.render('edit_profile', {
		title : 'Your Profile has been updated'
	})

})


app.listen(port, function(){
	console.log('Server started to listen',port, '!');
})