<?php
/*
*   Ian Cowan
*   CSC 362 Database Systems
*   Lab 7
*   9/26/2020
*
*   This is a short PHP file that will handle database connections and
*   pull all of the necessary database information from the .env
*   file. Use the following instructions to setup the .env file:
*
*   1) Ensure your current directory is the directory including
*      .env.example and perform the command `cp .env.example .env`
*   2) Open the new .env file and fill in the appropriate information
*       NOTE: If the database either does not exist or no database is
*             specified in .env, a connection will be made without a
*             specific database
*/

class DBConnect {

    private $connection;

    function __construct() {
        // Open the file and retrieve the required information
        $env = fopen(".env", "r") or die(".env file does not exist! Please
                                              reference DBConnect.php for setup instructions");
        $information = array();

        while(! feof($env)) {
            $exploded = explode("=", fgets($env));
            if(count($exploded) == 2) {
                $information[$exploded[0]] = trim(trim($exploded[1]), '"');
            } else {
                $information[$exploded[0]] = "";
            }
        }

        // Retrieve the information
        $dbhost = $information["db_host"];
        $dbuser = $information["db_username"];
        $dbpass = $information["db_password"];
        $dbname = $information["db_name"];

        // If host, username, or password don't exist, lets stop
        if($dbhost == "" || $dbuser == "" || $dbpass == "")
            die("Please specify a database host, user, and password in .env!");

        // If there was no database name specified, we will create a general connection
        // If there was a database name specified, we will connect to that database
        if($dbname == "") {
            $this->connection = mysqli_connect($dbhost, $dbuser, $dbpass);
        } else {
            $connection = mysqli_connect($dbhost, $dbuser, $dbpass, $dbname);

            // If the connection didn't work, we'll try to connect without the specific database
            if(! $connection)
                $this->connection = mysqli_connect($dbhost, $dbuser, $dbpass);
            else
                $this->connection = $connection;
        }

        // If there was an error with the connection, let's exist and output the reason
        if(! $this->connection) {
            echo "Error: Unable to connect to MySQL.\n";
            echo "Debugging errno: " . mysqli_connect_errno() . "\n";
            echo "Debugging error: " . mysqli_connect_error() . "\n";
            exit;
        }
    }

    public function getConnection() {
        return $this->connection;
    }

    public function closeConnection() {
        $this->connection->close();
    }
}

?>