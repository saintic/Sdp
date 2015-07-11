<!DOCTYPE html>
<html lang="en" class="no-js">
    <head>
        <meta charset="utf-8">
        <title>Sdp.SPMC | SaintIC PaaS Management Console</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <!-- CSS -->
        <link rel="stylesheet" href="assets/css/reset.css">
        <link rel="stylesheet" href="assets/css/supersized.css">
        <link rel="stylesheet" href="assets/css/style.css">
    </head>
    <body>
        <div class="page-container">
            <h1>SPMC:Sdp PaaS Management Console</h1>
            <form action="exec.php" method="post">
	      <input type="text" name="user" class="username" placeholder="用户名">
	      <input type="text" name="time" class="username" placeholder="使用期限">
	      <input type="text" name="service" class="username" placeholder="服务类型">
	      <input type="text" name="file" class="username" placeholder="文件类型">
	      <input type="text" name="email" class="username" placeholder="用户邮箱">
              <button type="submit">触发</button>
              <div class="error"><span>+</span></div>
            </form>
        </div>
        <p></p>
        <!-- Javascript -->
        <script src="assets/js/jquery-1.8.2.min.js"></script>
        <script src="assets/js/supersized.3.2.7.min.js"></script>
        <script src="assets/js/supersized-init.js"></script>
        <script src="assets/js/scripts.js"></script>
<br/>
<?php
$t=time();
echo date("Y-m-d H:i:s",$t);
?>
&nbsp;&nbsp;
Copyright © 2015-<?php echo date("Y")?>
<a href="https://www.saintic.com" target="_blank">SaintIC</a> 
    </body>
</html>

