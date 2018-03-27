<?php
class Flight {
	private $conn;
	private $tableName = "Flight";

	public $flightNumber;
	public $operatingAircraft;
	public $airCrew;
	public $toAirport;
	public $fromAirport;
	public $cargoCarried;
	public $departureTime;
	public $arrivalTime;

	public function __construct($db) {
		$this->conn = $db;
	}

	public function read() {
		$stmt = $this->conn->prepare("SELECT DISTINCT flight.flightNumber, flight.tailNumber, flight.crewID, flight.destination, flight.origin, flight.departureTime, flight.arrivalTime, shipment.currentLoad, aircraft.maxLoad FROM flight LEFT JOIN (SELECT cargo.flightNumber, SUM(cargo.weight) AS currentLoad FROM cargo GROUP BY cargo.flightNumber) AS shipment ON flight.flightNumber = shipment.flightNumber LEFT JOIN aircraft ON flight.tailNumber = aircraft.tailNumber WHERE shipment.currentLoad < aircraft.maxLoad OR shipment.currentLoad IS NULL");
		$stmt->execute();

		return $stmt;
	}
}