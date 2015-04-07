<tmpl_include name="layout/header.tpl">
<table>
<tr><th>When</th><th>Who</th><th>What</th></tr>
<tmpl_loop name="log">
<!-- <tr <tmpl_if name="__odd__">class="odd"</tmpl_if> ></td><td><tmpl_var name="when"></td><td><tmpl_var name="who"></td><td><tmpl_var name="what"></td></tr>  -->
<tr <tmpl_if name="__odd__">class="odd"</tmpl_if> ></td><td><tmpl_var name="creation_time"></td><td><tmpl_var name="who"></td><td><tmpl_var name="what"></td></tr> 
</tmpl_loop>
</table>
<tmpl_include name="layout/footer.tpl">
