create or replace PROCEDURE SP_Customer_Social_Accts(cid IN integer, num OUT integer)
AS
BEGIN
    SELECT count(*)
    INTO num
    FROM V_CUSTOMER_HAS_FILM x, T_CUSTOMER c, T_BORROWING b, T_FILM f
    WHERE c.customer_id=cid
        and c.customer_id=b.customer_id
        and f.film_id=f.film_id
		and f.min_age = 16;
	BEGIN
		execute immediate 'GRANT SELECT ON T_CUSTOMER TO public';
	END;
END;