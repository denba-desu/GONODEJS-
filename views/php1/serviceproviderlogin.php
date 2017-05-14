<?php
session_start();
include '../../php/dbh.php';

$email = $_POST['username'];
$pwd = $_POST['password'];

$sql = "SELECT * FROM service_provider WHERE sp_email = '$email' AND sp_password = '$pwd'";
$result = $conn->query($sql);

if (!$row = $result->fetch_assoc()) {
	$_SESSION['msg'] = 'Your username or password is incorrect.';
	header('Location: ../index.php');
} else {
	//$_SESSION['id'] = $row['id'];
	//header('Location: #');
	echo "Login Success";
}

?>