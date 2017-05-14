<?php

session_start();
include '../../php/dbh.php';


$sp = (int) $_SESSION['sp_id'];
if(!empty($_POST['service'])) {
    foreach($_POST['service'] as $cat) {
    	$sql2 = "INSERT INTO provider_specialization (id_sp, id_service) 
		VALUES ($sp, $cat)";
		$result2 = $conn->query($sql2);
    }
}

unset($_SESSION['sp_id']);
echo "You are now registered";
echo "<br><a href='../../../'> Back to HOME </a>";

?>