<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
  
  <html>  
  <head>  
	<style>
		body {
			font-family: Calibri,sans-serif;
		}
		
		table, th, td {
			border: 1px solid black;
			border-collapse: collapse;
			font-size: 9.0pt;
			font-weight: bold;
			padding: 1;
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
    <h1>JDBC App TESTING</h1>  
    <table width='100%'>  
      <tr>  
        <th align='left'>First Name</th>  
        <th align='left'>Last Name</th>  
		<!-- SOCIAL MEDIA HEADERS
        <th align='left'>Facebook</th> 
        <th align='left'>Twitter</th> 
        <th align='left'>LinkedIn</th> -->
        </tr>  
      <c:forEach var="democusts" items="${democusts.rows}">  
        <tr>  
           <td> ${democusts.NAME} </td>  
           <td> ${democusts.SURNAME} </td>  
           <!-- RETRIEVE SOCIAL MEDIA DATA FIELDS
           <td> ${democusts.FACEBOOK} </td>  
           <td> ${democusts.TWITTER} </td>  
           <td> ${democusts.LINKEDIN} </td> -->
        </tr>  
      </c:forEach>  
    </table>  
    <div class="footer">
      <p>version VERSION_NO</p>
    </div>
  </body>  
  </html>  