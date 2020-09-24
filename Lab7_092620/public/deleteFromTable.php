<!DOCTYPE html>
<html>
<head>
    <title>Delete From Table</title>
</head>

<body>
<?php
// Connect to the database in another file for security and simplicity
include("../DBConnect.php");

// Enable debugging
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// First, let's get a connection to the database
$connection = new DBConnect();
$conn = $connection->getConnection();

// ---------- DISPLAY A RESULT SET AS AN HTML TABLE -----------------------
function result_to_table($result) {
    $qryres = $result->fetch_all(); // get array of rows from result object, so we can iterate more than once
    $n_rows = $result->num_rows; // num_rows
    $n_cols = $result->field_count; // num_col

    // Description of table -------------------------------------
    echo "<p>This table has $n_rows and $n_cols columns.</p>\n";

    // Begin header ---------------------------------------------
    echo "<table>\n<thead>\n<tr>";

    $fields = $result->fetch_fields();
    echo "<td><b>Delete</b></td>";
    for ($i=0; $i<$n_cols; $i++){
        echo "<td><b>" . $fields[$i]->name . "</b></td>";
    }
    echo "</tr>\n</thead>\n";

    // Begin body -----------------------------------------------
    echo "<form action=\"/deleteFromTable.php\", method=\"POST\">\n";
    for ($i=0; $i<$n_rows; $i++){
        echo "<tr>";
        echo "<td><input type=\"checkbox\" name=\"delete" .
            $qryres[$i][0] ."\" value=\"" .
            $qryres[$i][0] . "\">"; // Foreach row, add a checkbox
        for($j=0; $j<$n_cols; $j++){
            echo "<td>" . $qryres[$i][$j] . "</td>";
        }
        echo "</tr>\n";
    }

    echo "</tbody>\n</table>\n";
    echo "<input type=\"submit\" value=\"Delete Records\">\n"; // Submit button
    echo "</form>\n"; // End the form

    // Allow more additions to be made to the table
    echo '<form action="deleteFromTable.php" method=POST>\n
              <input type="submit" name="resetdb" value="Add extra records"/>\n
          </form>\n';
}

// END OF FUNCTIONS -------------------------------------------------------

$sql = "SELECT instrument_id, instrument_type FROM instruments";

$result = $conn->query($sql);

if(!$result = $conn->query($sql)){
    echo "Query failed!";
    exit;
}

// Now, let's handle deleting the appropriate records
$all_results = $result->fetch_all();
$all_results_rows = $result->num_rows;

// Prepare the delete statement
$stmt = $conn->prepare("DELETE FROM instruments WHERE instrument_id>?");

// Loop through all the rows and if the user requested that they be deleted, delete it
for($i = 0; $i < $all_results_rows; $i++) {
    $id = $all_results_rows[$i][0];
    if(array_key_exists("checkbox" . $id, $_POST)) {
        // Bind and execute the prepared statement
        $stmt->bind_param('i', $id);
        $stmt->execute();
    }
}

// Add more records, if requested
if(array_key_exists("resetdb", $_POST)) {
    $conn->query("SOURCE ../insert_instruments.sql");
}

result_to_table($result); // call our function!

// Close the connection
$connection->closeConnection();

?>
</body>
</html>