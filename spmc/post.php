<html>
<body>

<?php
$user = $_POST['user'];
$time = $_POST['time'];
$service = $_POST['service'];
$file = $_POST['file'];
$email = $_POST['email'];
system("echo YouPassword | sudo -u root -S /bin/sh /data/sdp/start.sh $user $time $service $file $email 2>&1",$status);
if($status == 'true') {
  echo "<script>alert('Build Seccuss!');</script>";
} else {
  echo "<script>alert('Build Wrong!');</script>";
}
?>

</body>
</html>
