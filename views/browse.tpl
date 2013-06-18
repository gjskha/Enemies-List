<tmpl_include name="layout/header.tpl">

<tmpl_if name="warning">
<div class="warning"><tmpl_var name="warning"></div>
</tmpl_if>

<tmpl_if name="content">
<a name="<tmpl_var name="fresh">">
<h2><tmpl_var name="name"> (<tmpl_var name="asn">)</h2>
</a>
<p>This AS has <strong><tmpl_var name="disp"></strong> status.</p>  

<ul>
<tmpl_if name="p_count">
<li><a href="#" onclick="show_hidden('filtered')"><span id="inc">Show</span> filtered allocations.</a></li>
<tmpl_else>
<li>There are no filtered allocations.</li> 
</tmpl_if>

<tmpl_if name="u_count">
<li>The following allocations may need to be addressed:</li>
<tmpl_else>
<li>There are no unfiltered allocations.</li>
</tmpl_if>

<tmpl_loop name="content">
<li class="<tmpl_var name="status">"><tmpl_var name="alloc"></li>
</tmpl_loop>
</ul>
<tmpl_else>
select an option under "Enemies List" on the left.
</tmpl_if>
<tmpl_include name="layout/footer.tpl">
