<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include_once "../config/database.php";
include_once "../objects/flight.php";

$database = new Database();
$db = $database->getConnection();

$flight = new Flight($db);

$stmt = $flight->read();
$num = $stmt->rowCount();

if ($num > 0) {
	$flight_arr = array();
	$flight_arr["flights"] = array();

	while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
		extract($row);

		$one_flight = array(
			"flightNumber" => $flightNumber,
			"tailNumber" => $tailNumber,
			"crewID" => $crewID,
			"destination" => $destination,
			"origin" => $origin,
			"departureTime" => $departureTime,
			"arrivalTime" => $arrivalTime,
			"currentLoad" => $currentLoad,
			"maxLoad" => $maxLoad
		);

		array_push($flight_arr["flights"], $one_flight);
	}

	echo json_encode($flight_arr);
} else {
	echo json_encode(
		array("message" => "No flights available")
	);
}