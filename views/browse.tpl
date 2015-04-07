/* this is a comment */
<tmpl_include name="layout/header.tpl">

<tmpl_if name="warning">
<div class="warning"><tmpl_var name="warning"></div>
</tmpl_if>

<tmpl_if name="content">
<a name="<tmpl_var name="fresh">">
</a>
<h2> <a href="#<tmpl_var name="random">4" onclick="showUrlInDialog('<tmpl_var name="prog">?rm=note&annote=<tmpl_var name="asn">'); return false;"> &#009998;</a>&nbsp; <tmpl_var name="name"> (<tmpl_var name="asn">)</h2>
<p>This AS has <strong><tmpl_var name="disp"></strong> status.
rDNS data is cached.</p>

<tmpl_if name="p_count">
<h3>
<a href="#<tmpl_var name="random">2" onclick="show_hidden('y')"><span id="inc">Show</span> listed allocations.</a>
</h3>
<tmpl_else>
<h3>
There are no listed allocations.
</h3>
</tmpl_if>

<tmpl_if name="u_count">
<h3>
The following allocations may need to be addressed:
</h3>
<tmpl_else>
<h3>
There are no unlisted allocations.
</h3>
</tmpl_if>


<table>
<tr><td></td><td>Alloc</td><td>Sample RDNS</td></tr>

<tmpl_loop name="content">
<!-- <li class="<tmpl_var name="prom">"> -->
<tr class="<tmpl_var name="prom">"> 
 <td>   
<a name="<tmpl_var name="alloc">"></a>
    <a onclick="showUrlInDialog('<tmpl_var name="prog">?rm=note&annote=<tmpl_var name="alloc">'); return false;" href="#<tmpl_var name="alloc">">&#009998;</a>

<td>
<tmpl_var name="alloc"> 
</td> 
<td>
<tmpl_var name="rdns">
</td>
</tr>
</tmpl_loop>
</table>

<tmpl_else>
<h3>Select an option under "Enemies List" on the left.</h3>
</tmpl_if>
<tmpl_include name="layout/footer.tpl">
