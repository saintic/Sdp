<!DOCTYPE html>
<html lang="en" class="no-js">
<head>
  <meta charset="utf-8">
  <title>Sdp.SPMC | SaintIC PaaS Management Console</title>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <meta http-equiv="refresh" content="2; url=index.html">
</head>
<body>
<?php
$user = $_POST['user'];
$time = $_POST['time'];
system("echo password | sudo -u root -S /data/sdp/tools/renew.sh $user $time",$status);
if($status == 'true') {
  echo "<script>alert('Update Seccuss!');</script>";
} else {
  echo "<script>alert('Update Wrong!');</script>";
}
?>
</body>
</html>
