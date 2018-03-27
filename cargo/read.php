<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once "../config/database.php";
include_once "../objects/cargo.php";

$database = new Database();
$db = $database->getConnection();

$cargo = new cargo($db);

$stmt = $cargo->read();
$num = $stmt->rowCount();

if ($num > 0) {
	$cargo_arr = array();
	$cargo_arr["cargo"] = array();

	while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
		extract($row);

		$one_cargo = array(
			"skidID" => $skidID,
			"weight" => $weight,
			"flightNumber" => $flightNumber
		);

		array_push($cargo_arr["cargo"], $one_cargo);
	}

	echo json_encode($cargo_arr);
} else {
	echo json_encode(
		array("message" => "No cargo available for Overwhelmed Commerce")
	);
}