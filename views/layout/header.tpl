<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Enemies List</title>
<link href="includes/css/style.css" rel="stylesheet" type="text/css" />
<script src="includes/js/jquery-1.8.2.js"></script>
<script>
    function show_hidden(toggleClass) {
        $("." + toggleClass).slideToggle();
        bellwhistle = document.getElementById("inc");
        if (bellwhistle.innerHTML == "Show") {
            bellwhistle.innerHTML = "Hide";
        } else {
            bellwhistle.innerHTML = "Show";
        } 
    }
</script>

</head>
<body>
<div id="maincontainer">

<div id="topsection">
 <div class="innertube">
  <h1><tmpl_var name="title"></h1>
<div class="centered">
     <a href="?rm=browse">Browse The Enemies List</a> &sect;
     <a href="?rm=edit">Edit The Enemies List</a> &sect;
     <a href="?rm=log">Activity Log</a> 
</div>
 </div>
</div>

<div id="contentwrapper">
<div id="contentcolumn">
    <div class="innertube">

