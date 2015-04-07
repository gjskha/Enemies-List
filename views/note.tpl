<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title><tmpl_var name="title"></title>
<link href="includes/css/style.css" rel="stylesheet" type="text/css" />
<link href="includes/css/smoothness/jquery-ui-1.9.1.custom.css" rel="stylesheet" type="text/css" />
<script src="includes/js/jquery-1.8.2.js"></script>
<!-- <script src="//ajax.googleapis.com/ajax/libs/jqueryui/1.10.3/jquery-ui.min.js" type="text/javascript"></script> -->
<script src="includes/js/jquery-ui-1.9.1.custom.js" type="text/javascript"></script>
<script>
function replacer(annote) {
    new_annotation = $("#annotation").attr("value");
              user = $("#user").attr("value");
       $.post( "<tmpl_var name="prog">", 
                   { annotation : new_annotation, 
                             rm : "note", 
                         annote : annote, 
                           user : user, 
                         submit : 1, 
                        success : function(data) {
                                      $("#flash").css( "color", "red" );
                                      $("#flash").html("Changes saved.");
                                  }  
                   }
               );
}
</script>
</head>
<body>
<!-- <p id="area_to_replace"> -->
<div id="flash"></div>
<h4><tmpl_var name="title"></h4>
<form name="notes" id="notes" action="<tmpl_var name="prog">" method="post">
<input type="hidden" name="rm" value="note" /> 
<input type="hidden" name="annote" value="<tmpl_var name="annote">" />
<strong>Notes</strong>
<br />
<textarea id="annotation" name="annotation">
<tmpl_var name="note">
</textarea>
<br />
<strong>Who are you?</strong>
<br />
<input type="text" id="user" name="user" value="<tmpl_var name="user">" />
<br />
<input onclick="replacer('<tmpl_var name="annote">'); return false" type="submit" name="submit" id="submit" value="submit" />
</form>
<!-- </p> -->
</body>
