<?php
class DBConnect {

	private $connection;

	function __construct() {
		$dbhost = "localhost";
		$dbuser = "iancowan";
		$dbpass = "password";

		$this->connection = mysqli_connect($dbhost, $dbuser, $dbpass);
	}

	public function getConnection() {
		return $this->connection;
	}

	public function closeConnection() {
		$this->connection->close();
	}
}
?>
