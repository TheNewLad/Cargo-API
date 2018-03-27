<?php
class Cargo {
	private $conn;
	private $tableName = "cargo";

	public $skidID;
	public $weight;
	public $flightNumber;

	public function __construct($db) {
		$this->conn = $db;
	}

	public function read() {
		$stmt = $this->conn->prepare("SELECT skidID, weight, flightNumber FROM $this->tableName WHERE fromMD = 1");
		$stmt->execute();

		return $stmt;
	}

	public function readOne() {
		$stmt = $this->conn->prepare("SELECT weight, flightNumber FROM $this->tableName WHERE fromMD = 1 AND skidID = $this->skidID");
		$stmt->execute();

		$row = $stmt->fetch(PDO::FETCH_ASSOC);
		extract($row);

		$this->weight = $weight;
		$this->flightNumber = $flightNumber;
	}

	public function create() {
		$this->weight=htmlspecialchars(strip_tags($this->weight));
		$this->flightNumber=htmlspecialchars(strip_tags($this->flightNumber));
		$stmt = $this->conn->prepare("INSERT INTO cargo (weight, fromMD, flightNumber) VALUES ($this->weight, 1, '$this->flightNumber'); SELECT LAST_INSERT_ID() AS id;");
		$stmt->execute();

		$stmt->nextRowset();

		while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
			extract($row);


			$this->skidID = $id;
		}

		return isset($this->skidID);
		
	}

	public function checkWeight($flightNumber, $weight) {
		$stmt = $this->conn->prepare("SELECT DISTINCT flight.flightNumber FROM flight LEFT JOIN cargo ON cargo.flightNumber = flight.flightNumber INNER JOIN aircraft ON flight.tailNumber = aircraft.tailNumber LEFT JOIN (SELECT flightNumber, SUM(cargo.weight) AS currentLoad FROM cargo GROUP BY flightNumber) AS shipment ON shipment.flightNumber = flight.flightNumber WHERE flight.flightNumber = '$this->flightNumber' AND IFNULL(currentLoad, 0) + $this->weight <= maxLoad");
		$stmt->execute();

		return $stmt;
	}
}