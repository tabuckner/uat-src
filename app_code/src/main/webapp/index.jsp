<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  
  <html>  
  <head>  
    <title>GambitCard</title>  
	<style>
		body {
			font-family: Calibri,sans-serif;
		}
		
		table, td {
			border: 1px solid black;
			border-collapse: collapse;
			font-size: 12.0pt;
			font-weight: normal;
			padding: 1;
		}
		
		th {
			border: 1px solid black;
			border-collapse: collapse;
			font-size: 15.0pt;
			font-weight: bold;
			padding: 1;
			color: white;
		}
		
		.footer {
		   position: fixed;
		   left: 0;
		   bottom: 0;
		   width: 100%;
		   text-align: center;
		}
	</style>  
    
	<sql:query var="democusts" dataSource="jdbc/appdb">  
       select * from T_CUSTOMER
    </sql:query>  
  
  </head>  
  <body>  
    <h1 style="color:crimson;">GambitCard</h1>    
    <table width='100%'>  
      <tr>  
        <th height="10px" color="white" bgcolor="#b73347" align='left'>First Name</th>  
        <th height="10px" color="white" bgcolor="#b73347" align='left'>Last Name</th>  
		<!-- SOCIAL MEDIA HEADERS -->
        <th height="10px" color="white" bgcolor="#b73347" align='left'>Facebook</th> 
        <th height="10px" color="white" bgcolor="#b73347" align='left'>Twitter</th> 
        <th height="10px" color="white" bgcolor="#b73347" align='left'>LinkedIn</th>
      </tr>  
      <c:forEach var="democusts" items="${democusts.rows}">  
        <tr>  
           <td> ${democusts.NAME} </td>  
           <td> ${democusts.SURNAME} </td>  
           <!-- RETRIEVE SOCIAL MEDIA DATA FIELDS -->
           <td> ${democusts.FACEBOOK} </td>  
           <td> ${democusts.TWITTER} </td>  
           <td> ${democusts.LINKEDIN} </td>
        </tr>  
      </c:forEach>  
    </table>  
    <div class="footer">
      <p>version VERSION_NO</p>
    </div>
  </body>  
  </html>  