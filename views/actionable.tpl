<html>
<head>
<style>
table {
    width: 80%;
}
th {
    text-align: left;
    background-color: black;
    color: white;

}
tr {
    padding: 5px; 
    background-color:  #e7fffc;
}
.stripe {
    background-color:  #ffffff;
}

</style>
</head>
<body>
<table>
    <tr>
        <th>
            CIDR 
        </th>
        <th>
            Number
        </th>
        <th>
            Name
        </th>
        <th>
           Disp 
        </th>
        <th>
           Note
        </th>
</tr>
    <tmpl_loop name="unpromoted">
        <tmpl_if name="__odd__">
             <tr class="stripe">
        <tmpl_else>
              <tr>     
        </tmpl_if>
        <td>
            <tmpl_var name="cidr">
        </td> 

        <td>
            <tmpl_var name="number">
        </td> 
        <td> 
            <tmpl_var name="name">
        </td>
        <td> 
            <tmpl_var name="disp">
        </td>
         <td> 
            <tmpl_var name="note">
        </td>
</tr>
    </tmpl_loop>
</table>
</body>
</html>
