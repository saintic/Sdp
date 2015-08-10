<!DOCTYPE html>
<?php   
$url = "https://ci.saintic.com/";
?>
<html lang="en" class="no-js">
    <head>
        <meta charset="utf-8">
        <title>Sdp.SPMC | SaintIC PaaS Management Console</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<meta http-equiv="refresh" content="2; url=<?php echo $url; ?>">
        <!-- CSS -->
        <link rel="stylesheet" href="style/css/style.css">
    </head>
    <body>
<?php
//disable error reporting.
error_reporting(0);
$user = $_POST['user'];
$time = $_POST['time'];
$service = $_POST['service'];
$file = $_POST['file'];
$email = $_POST['email'];

system("echo password | sudo -u root -S /data/sdp/start.sh $user $time $service $file $email",$status);
if($status == 'true') {
  echo "<script>alert('Build Seccuss!');</script>";
} else {
  echo "<script>alert('Build Wrong!');</script>";
}
?>
        <!-- Javascript -->
        <script src="style/js/jquery-1.8.2.min.js"></script>
        <script src="style/js/supersized.3.2.7.min.js"></script>
        <script src="style/js/supersized-init.js"></script>
        <script src="style/js/scripts.js"></script>
    </body>
</html>

