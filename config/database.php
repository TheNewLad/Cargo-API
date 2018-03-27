<?php 
class Database {
	private $host = "sql2.njit.edu";
	private $dbname ="ktd6";
	private $username = "ktd6";
	private $password = "vtzdDjgH3";
	// private $dsn = "mysql:dbname=" . $dbname . ";host=" . $host;
	public $conn;

	public function getConnection() {
		$this->conn = null;
		
		try {
			$this->conn = new PDO("mysql:dbname=" . $this->dbname . ";host=" . $this->host, $this->username, $this->password);
			$this->conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
			$this->conn->exec("set names utf8");
		} catch (PDOException $e) {
			echo 'failed ' . $e->getMessage();
		}

		return $this->conn;
	}
}