<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: access");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Credentials: true");
header('Content-Type: application/json');

include_once "../config/database.php";
include_once "../objects/cargo.php";

$database = new Database();
$db = $database->getConnection();

$cargo = new cargo($db);
$data = json_decode(file_get_contents("php://input"));

$cargo->skidID = isset($data->skidID) ? htmlspecialchars(strip_tags($data->skidID)) : die();

$cargo->readOne();

$one_cargo = array(
	"skidID" => $cargo->skidID,
	"weight" => $cargo->weight,
	"flightNumber" => $cargo->flightNumber
);

echo json_encode($one_cargo);