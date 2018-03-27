<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8; application/x-www-form-urlencoded");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Max-Age: 3600");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

include_once "../config/database.php";
include_once "../objects/cargo.php";

$database = new Database();
$db = $database->getConnection();

$cargo = new Cargo($db);

$data = json_decode(file_get_contents("php://input"));

$cargo->weight = $data->weight;
$cargo->flightNumber = $data->flightNumber;

$stmt = $cargo->checkWeight($cargo->flightNumber, $cargo->weight);
$num = $stmt->rowCount();

if ($num == 1) {
	if ($cargo->create()) {
		$shipment = array(
		"skidID" => $cargo->skidID,
		"weight" => $cargo->weight,
		"flightNumber" => $cargo->flightNumber
		);

		echo json_encode($shipment);
	}
} else {
	echo json_encode(
		array("message" => "Error! Please check Cargo Weight and/or Flight Number.")
	);
}