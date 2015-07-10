<?php   
$url = "https://ci.saintic.com/";
?> 
<html>
 <head>
  <meta http-equiv="refresh" content="2; url=<?php echo $url; ?>">
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
  <title>Sdp.SPMC | Simple Docker PaaS</title>
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
//password:of sudo USER.
system("echo password | sudo -u root -S /bin/sh -x /data/sdp/start.sh $user $time $service $file $email",$status);
if($status == 'true') {
  echo "<script>alert('Build Seccuss!');</script>";
} else {
  echo "<script>alert('Build Wrong!');</script>";
}
?>
 </body>
</html>
