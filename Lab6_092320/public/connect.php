<?php
	// We connect in a non-public file for password security
	include("../DBConnect.php");

	// Enable debugging
	ini_set('display_errors', 1);
	ini_set('display_startup_errors', 1);
	error_reporting(E_ALL);

	// Get a new database connection
	$dbconn = new DBConnect();
	$conn = $dbconn->getConnection();
	
	// Ensure we connected successfully
	if($conn->errno) {
		echo "Error: Failed to make a MySQL connection.
		      Here is why: <br>";
		echo "Errno: " . $conn->connect_errno . "\n";
		echo "Error: " . $conn->connect_error . "\n";
		exit;
	} else {
		echo "Database connected successfully! <br> YAY! <br>";
	}

	// Now, let's list the databases that we have
	// Create the query
	$dblist = "SHOW DATABASES";
	$result = $conn->query($dblist);

	// Echo the result
	echo "<h4>Databases:</h4>";
	while($dbname = $result->fetch_array()) {
		echo $dbname['Database'] . "<br>";
	}

	// Lets generate a form that will allow the user to
	// search for a database and see the tables in that
	// database

	// Check and see if a database has been specified
	if(isset($_GET['db'])) {
		// If there is a database, show its tables
		// considering it exists
		$db_name = htmlspecialchars($_GET['db']);

		// Make sure there are no semicolons - possible SQL injection
		$db_name_check = explode(";", $db_name);

		// If we suspect a SQL injection, let's just stop
		if(count($db_name_check) > 1) exit;
		
		// If we get here, the DB name is okay, so we can
		// try to find the tables in the DB
		$query_db = "USE " . $db_name . ";";
		$query_tables = "SHOW TABLES;";
		$conn->query($query_db);
		$tables = $conn->query($query_tables);

		// Ensure we succeeded
		if($tables) {
			// We got the tables, so let's show the tables
			// and then provide a way to reset the form
			echo "<hr><h4>" . $db_name . " Tables:</h4>";
			while($tablename = $tables->fetch_array()) {
				echo $tablename['Tables_in_' . $db_name] . "<br>";
			}

			echo '<br>
			      <a href="/connect.php">
			      	<button>Reset</button>
			      </a>';
		} else {
			// Something didn't work
			echo '
				<hr>
				<p>Something went wrong when trying to find the
				   tables for the database ' . $db_name . '.
				   Please try again.</p>
				<br>
				<h4>Serach here for more information on
				    a database:</h4>
				<form>
					<input type="text" name="db">
					<input type="submit" value="Submit">
				</form>
			';
		}
	} else {
		// If no database specified, echo the form
		echo '
			<hr>
			<h4>Search here for more information on a database:</h4>
			<form>
				<input type="text" name="db">
				<input type="submit" value="Submit">
			</form>
		';
	}

	// Close the database connection
	$dbconn->closeConnection();
?>

