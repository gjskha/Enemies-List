    </div>
</div>
</div>

<div id="leftcolumn">
    <div class="innertube">
        <h2>Enemies List</h2>
        <ul>
        <tmpl_loop name="sidebar">
	 <li> <a href="<tmpl_var name="prog">?as=<tmpl_var name="asn">#<tmpl_var name="random">"><tmpl_var name="name"></a> </li>
        </tmpl_loop> 
        </ul>
    </div>

</div>

<div id="footer">
<br />
<p><em>Last whois run was at <tmpl_var name="lastrun">.</br />
Last modification was at <tmpl_var name="lastmod">.</em></p>
</div>

</div>
</body>
</html>
