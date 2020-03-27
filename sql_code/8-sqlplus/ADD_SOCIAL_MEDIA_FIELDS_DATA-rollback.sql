DROP TABLE T_CUSTOMER CASCADE CONSTRAINTS;
RENAME T_CUSTOMER_BAK TO T_CUSTOMER;
--ALTER TABLE GAMBITCARD_REF_DB2.T_CUSTOMER_BAK RENAME TO T_CUSTOMER;

CREATE INDEX I_NAME ON T_CUSTOMER (name);
ALTER TABLE T_CUSTOMER ADD CONSTRAINT PK_T_CUSTOMER PRIMARY KEY (customer_id);