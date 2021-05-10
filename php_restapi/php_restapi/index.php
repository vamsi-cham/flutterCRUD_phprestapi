<?php
// Cross Origin Access
require('config/cors.php');
require('config/connection.php');

$table="user";
$api_key=$_POST["api_key"];
$api_secret=$_POST["api_secret"];
$action = $_POST["action"];
$verify_api;

$sql="SELECT * FROM api_credential WHERE api_key='$api_key' AND api_secret='$api_secret' ";
$result = $conn->query($sql); // run query
if($result->num_rows){ //if exist something
    // $ret = $result->fetch_array(MYSQLI_ASSOC); 
    $verify_api="done";
    //fetch data
}else{
   $verify_api="notdone";
}

if($verify_api=="done"){
     // Get all employee records from the database
     if("getdata" == $action){
        $sort=$_POST["sort"];
        $db_data = array();
        $sql = "SELECT * from $table ORDER BY id $sort ";
        $result = $conn->query($sql);
        if($result->num_rows > 0){
            while($row = $result->fetch_assoc()){
                $db_data[] = $row;
            }
            // Send back the complete records as a json
            echo json_encode($db_data);
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
    // Add an Employee
    if("adduser" == $action){
        // App will be posting these values to this server
        
        $name = $_POST['name'];
        $age = $_POST['age'];
        $email=$_POST['email'];
        $mobile=$_POST['mobile'];
        $sql = "INSERT INTO $table (name, age, mobile, email) VALUES ('$name', $age, '$mobile', '$email')";
        $result = $conn->query($sql);
        echo "success";
        $conn->close();
        return;
    }
 
    // Remember - this is the server file.
    // I am updating the server file.
    // Update an Employee
    if("updateuser" == $action){
        // App will be posting these values to this server
        $user_id = $_POST['user_id'];
        $name = $_POST['name'];
        $age = $_POST['age'];
        $email=$_POST['email'];
        $mobile=$_POST['mobile'];
        $sql = "UPDATE $table SET name = '$name', age = $age, mobile='$mobile', email='$email' WHERE id = $user_id ";
        if($conn->query($sql) === TRUE){
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }
 
    // Delete an Employee
    if('deleteuser' == $action){
        $user_id = $_POST['user_id'];
        $sql = "DELETE FROM $table WHERE id =$user_id "; // don't need quotes since id is an integer.
        if($conn->query($sql) === TRUE){
            echo "success";
        }else{
            echo "error";
        }
        $conn->close();
        return;
    }

    $conn->close();
}

?>