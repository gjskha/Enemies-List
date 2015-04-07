/* annotations : all of the notes */
<tmpl_include name="layout/header.tpl">

<table>
<tr><td><strong>Thing</strong></td><td><strong>Annotation</strong></td></tr>
<tmpl_loop name="notes">
<tmpl_if name="__odd__">
<tr class="odd">
<tmpl_else>
<tr>
</tmpl_if>
<td>
<tmpl_var name="entity">
</td>
<td>
<tmpl_var name="note">
</td>
</tr>
</tmpl_loop>
</table>

<tmpl_include name="layout/footer.tpl">
