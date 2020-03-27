--CREATE CUSTOMER ADDRESS FIELDS
alter table T_CUSTOMER add SURNAME VARCHAR2(20);
alter table T_CUSTOMER add ADDRESS VARCHAR2(40);
alter table T_CUSTOMER add ZIPCODE VARCHAR2(10);
alter table T_CUSTOMER add CITY VARCHAR2(30);
alter table T_CUSTOMER add STATE_PROV VARCHAR2(10);
alter table T_CUSTOMER add COUNTRY CHAR(2);

--UPDATE VIEW TO REFERENCE UPDATED ADDRESS COLUMN
  CREATE OR REPLACE FORCE VIEW V_CUSTOMER_HAS_FILM ("NAME", "CITY", "TITLE", "DIRECTOR") AS 
  SELECT DISTINCT c.name, c.city AS city, f.title, f.director
FROM T_CUSTOMER c, T_BORROWING b, T_EXEMPLAR e, T_FILM f
WHERE c.customer_id=b.customer_id 
and b.exemplar_id=e.exemplar_id 
and e.film_id=f.film_id;
/