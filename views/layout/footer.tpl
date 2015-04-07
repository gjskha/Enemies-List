    </div>
</div>
</div>

<div id="leftcolumn">
    <div class="innertube">
        <h2>Enemies List</h2>
        <ul>
        <tmpl_loop name="sidebar">
	 <li><span <tmpl_if name="disp">class="<tmpl_var name="disp">"<tmpl_else>style="background-color: grey"</tmpl_if> >&nbsp;</span> <a href="<tmpl_var name="prog">?as=<tmpl_var name="asn_id">#<tmpl_var name="random">"><tmpl_var name="name"> (<tmpl_var name="asn">)</a> </li>
        </tmpl_loop> 
        </ul>
    </div>

</div>

<div id="footer">
<br />
<p>Last whois run was at <tmpl_var name="lastrun">.<br />
Last modification was at <tmpl_var name="lastmod">.</p>
</div>

</div>
</body>
</html>
