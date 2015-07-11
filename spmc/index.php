<!DOCTYPE html>
<html>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>Sdp.SPMC | Simple Docker PaaS</title>
<body>
<center><h1>Sdp:SaintIC PaaS Management Console!<h1></center>
<center><h1>Remote execution and create application services<h1></center>

<?php
echo "Sdp Usage:user use_time service_type file_type email";
?>

<form method="post" action="post.php">
User:         <input type="text" name="user"><br>
Use_time:     <input type="text" name="time"><br>
Service_type: <input type="text" name="service"><br>
File_type:    <input type="text" name="file"><br>
E-mail:       <input type="text" name="email"><br>
<input type="submit">
</form>

<?php
$t=time();
echo date("Y-m-d H:i:s",$t);
?>
<br>
Copyright © 2015-<?php echo date("Y")?>
<br>
</body>
</html>
