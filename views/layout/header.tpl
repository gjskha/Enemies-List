<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Enemies List</title>
<link href="includes/css/style.css" rel="stylesheet" type="text/css" />
<link href="includes/css/smoothness/jquery-ui-1.9.1.custom.css" rel="stylesheet" type="text/css" />
<script src="includes/js/jquery-1.8.2.js"></script>
<!-- <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript"></script> -->
<script src="includes/js/jquery-ui-1.9.1.custom.js" type="text/javascript"></script>
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

    function showUrlInDialog(url){
         var tag = $("<div></div>");
         $.ajax({
             url: url,
             success: function(data) {
             tag.html(data).dialog({modal: false,
height: 510,
width: 470}).dialog('open');
         }});
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
     <a href="?rm=annotations">Annotations</a> &sect;
     <a href="?rm=log">Activity Log</a> &sect;
     <a href="?rm=about">About</a> 
</div>
 </div>
</div>

<div id="contentwrapper">
<div id="contentcolumn">
    <div class="innertube">
