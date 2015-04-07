<tmpl_include name="layout/header.tpl">
<form id="edit_form" method="post" action="<tmpl_var name="prog">">
<h2>One entry per line, ASN must be unique.</h2>
<textarea name="edit" class="edit" rows="20" cols="100">
<tmpl_loop name="enemies">
<tmpl_var name="name"> <tmpl_var name="asn"> <tmpl_var name="disp">
</tmpl_loop>
</textarea>
<br/>
<h2>Reason for change:</h2>
<input name="message" class="edit" type="text">
<h2>Who are you?</h2>
<input name="user" class="edit" type="text" <tmpl_if name="user">value="<tmpl_var name="user">"</tmpl_if>><br/>
<input name="rm" type="hidden" value="edit"><br />
<input type="submit" name="submit" value="Make Edits">
</form>
<tmpl_include name="layout/footer.tpl">
