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
	var currentCustomerList = [];

	//Connect to MySQL database.
	var connection = getMySQLConnection();
	connection.connect();

	//Query to get data.
	connection.query('SELECT * FROM requests a, services b, customer c where (a.isAcceptedRequest="T" && b.service_id =any (select id_service from provider_specialization)) && a.status != "Done"', function (err, rows, fields) {
		if (err) {
			res.status(500).json({"status_code": 500, "status_message": "internal server error"});
		} else {

			// Loop check on each row
			for (var i = 0; i < rows.length; i++) {

				// Create on object to save current row's data
				var currentServices = {
					title: 'Current Services',
					message: 'Current Services',
					'request_id': rows[i].request_id,
					'customer_name': rows[i].customer_name,
					'service_name':rows[i].service_name,
					'scheduled_time': rows[i].scheduled_time,
					'scheduled_day': rows[i].scheduled_day,
					'status': rows[i].status,
					'isPaid': rows[i].isPaid
				}
				// Add object into array
				currentCustomerList.push(currentServices);
			}

			// Render index.pug page using array
			res.render('index', {"currentCustomerList": currentCustomerList});
		}
	});
	connection.end();
})


app.get('/service_requests', function (req, res) {
	var serviceRequestsList = [];

	//Connect to MySQL database.
	var connection = getMySQLConnection();
	connection.connect();

	//Query to get data.
	connection.query('SELECT * FROM requests where isAcceptedRequest="F"', function (err, rows, fields) {
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
					'id_specialization': rows[i].id_specialization,
					'id_customer': rows[i].id_customer,
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
		var html = 'The ID Request ' + request_id + ' successfuly accepted.'
		res.send(html)
	})
	connection.end();
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

/*
app.get('/history', function (req, res) {
	res.render('history', {
		title: 'History',
		message: 'Page for viewing client history.'
	})
})
*/
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

/*
app.('/update_profile', function(req, res) {
	var connection = getMySQLConnection();
	connection.connect();

	connection.query('UPDATE serviceprovider SET fullname: ', function (err, rows, fields) {

	})
})
*/
/*
app.get('/accept_request', function(req, res) {

	var html = '<form action="/accept_request" method="post">'+
					'Enter Request ID: ' +
					'<input type="text" name="request_id" placeholder="Enter here"/>'+
					'<br>' +
					'<button type="submit">Accept</button>'
				'</form>';
				
	res.send(service_requests);

});
*/


app.get('/update_profile', function(req, res) {
	res.render('edit_profile', {
		title : 'Your Profile has been updated'
	})

})


app.listen(port, function(){
	console.log('Server started to listen',port, '!');
})