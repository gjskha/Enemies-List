/* about.tpl: about the app */
<tmpl_include name="layout/header.tpl">
<h2>Updates</h2>
<p>
The list of CIDRs and the rDNS are updated once day, so if you add a new AS it
won't be reflected until the next run.
</p>

<h2>Ranking the Enemies List</h2>
<table>
<tr><td><strong>Rank</strong></td><td><strong>Dispensation</strong></td><td><strong>Meaning</strong></td></tr>
<tmpl_loop name="disp">
<tmpl_if name="__odd__">
<tr class="odd">
<tmpl_else>
<tr>
</tmpl_if>
<td>
<tmpl_var name="rank">
</td>
<td>
<span class="<tmpl_var name="dispensation">"><tmpl_var name="dispensation"></span>
</td>
<td>
<tmpl_var name="meaning">
</td>
</tr>
</tmpl_loop>
</table>

<tmpl_include name="layout/footer.tpl">
