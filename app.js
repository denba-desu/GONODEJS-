var path = require('path')
var mysql = require('mysql');
var cookieParser = require('cookie-parser');
var bodyParser = require('body-parser');
var expressValidator = require('express-validator');
var express = require('express');
var session = require('express-session');
var app = express();
var port = 3000;

app.set('views', './views');
app.set('view engine', 'pug');

app.use(expressValidator());
app.use(cookieParser());
app.use(express.static(__dirname + '/views'));
app.use(session({secret: 'ssshhhhh'}));
app.use(bodyParser.json()); // for parsing application/json
app.use(bodyParser.urlencoded({extended: true}));

function getMySQLConnection() {
	return mysql.createConnection({
		host		: 'localhost',
		user		: 'root',
		password	: 'root',
		database	: 'webtek-2',
	});
}

var sess;

app.get('/', function (req, res) {
	res.render('login');
})



app.post('/', function (req, res) {
	sess = req.session;
	sess.email = req.body.email;
	sess.password = req.body.password;

	var connection = getMySQLConnection();
	connection.connect();

	console.log(sess.email);
	console.log(sess.password);

	connection.query('SELECT * FROM service_provider where sp_email = ? and sp_password = ?;', [sess.email, sess.password], function (err, rows, fields) {
		//console.log(rows.length);
		if(rows.length == 1) {
			res.redirect('current_services')
		}else{
			res.send(`
			<!doctype html>
			<html>
			<head><title>Check Out</title></head>
			<body>
				<h1>Wrong credentials!</h1>
				<p>Check if your email and password is correct.</p>
				<p>Go back to the <a href='/'>Log-in Page</a></p>
			</body>
			</html>
			`);
		}
		
	})
	connection.end();
})

app.get('/current_services', function (req, res) {
	var currentCustomerList = [];

	//Connect to MySQL database.
	var connection = getMySQLConnection();
	connection.connect();

	//Query to get data.
	connection.query('SELECT request_id, customer_name, service_name,  scheduled_time, scheduled_day, status,IF(isPaid="T","Paid","Unpaid") as "Payment" FROM requests a, customer b, services c where ((status = "Ongoing" && isPaid = "F") || (status = "Done" && isPaid = "F")) &&  (a.customer_id = b.customer_id && a.service_id = c.service_id)', function (err, rows, fields) {
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
	connection.query('SELECT request_id,service_name, customer_name, scheduled_time, scheduled_day FROM requests a, customer b, services c where (status = "Pending" && a.customer_id = b.customer_id) && a.service_id = c.service_id', function (err, rows, fields) {
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

	connection.query('UPDATE requests SET status="Ongoing" WHERE request_id = ?;', [request_id], function(err, row, fields){
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
	connection.query('SELECT request_id, customer_name, service_name,  scheduled_time, scheduled_day, status,IF(isPaid="T","Paid","Unpaid") as "Payment",rate FROM requests a, customer b, services c where (status = "Done" && a.customer_id = b.customer_id) && (a.service_id = c.service_id && isPaid = "T")', function (err, rows, fields) {
		if (err) {
			res.status(500).json({"status_code": 500, "status_message": "internal server error"});
		} else {

			// Loop check on each row
			for (var i = 0; i < rows.length; i++) {

				// Create on object to save current row's data
				var historyServices = {
					'request_id': rows[i].request_id,
					'customer_name': rows[i].customer_name,
					'service_name': rows[i].service_name,
					'scheduled_time': rows[i].scheduled_time,
					'scheduled_day': rows[i].scheduled_day,
					'status': rows[i].status,
					'Payment': rows[i].Payment,
					'rate': rows[i].rate
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

	connection.query('SELECT * from service_provider WHERE sp_email = ?',[sess.email], function (err, rows, fields) {
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

	connection.query('SELECT * from service_provider WHERE sp_email = ?',[sess.email], function (err, rows, fields) {
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

app.get('/logout', function(request, response) {
	sess.destroy();
	response.send(`
		<!doctype html>
		<html>
		<head><title>Logged out</title></head>
		<body>
			<h1>Goodbye!</h1>
			<p>See you again.</p>
			<p>You have been logged out.</p>
			<p>Go back to the <a href='/login'>Home Page</a></p>
		</body>
		</html>
	`);
});



app.listen(port, function(){
	console.log('Server started to listen',port, '!');
})