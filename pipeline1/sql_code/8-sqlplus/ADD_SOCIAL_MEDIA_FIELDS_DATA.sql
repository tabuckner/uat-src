RENAME T_CUSTOMER TO T_CUSTOMER_BAK;
--ALTER TABLE GAMBITCARD_REF_DB2.T_CUSTOMER RENAME TO T_CUSTOMER_BAK;

CREATE TABLE T_CUSTOMER(
  customer_id Integer NOT NULL,
  name Varchar2(20 CHAR),
  surname Varchar2(20),
  --BEGIN NEW SOCIAL MEDIA FIELDS
  facebook Varchar2(20),
  twitter Varchar2(20),
  linkedin Varchar2(20),
  --END NEW SOCIAL MEDIA FIELDS
  address Varchar2(40),
  zipcode Varchar2(10),
  city Varchar2(30),
  state_prov Varchar2(10),
  country Char(2)
);

INSERT INTO T_CUSTOMER(
  customer_id,
  name,
  surname,
  --BEGIN NEW SOCIAL MEDIA FIELDS
  facebook,
  twitter,
  linkedin,
  --END NEW SOCIAL MEDIA FIELDS
  address,
  zipcode,
  city,
  state_prov,
  country
  ) SELECT customer_id, name, surname, NULL, NULL, NULL, address, zipcode, city, state_prov, country FROM T_CUSTOMER_BAK;

--POPULATE CUSTOMER TABLE WITH SOCIAL DATA
update T_CUSTOMER
  set FACEBOOK='@Hepburn', TWITTER='ahepburn_fb', LINKEDIN='AudreyHepburn'
  WHERE CUSTOMER_ID = 1;
update T_CUSTOMER
  set FACEBOOK='@LeBon', TWITTER='lebon_da_bomb', LINKEDIN='SimonLebon'
  WHERE CUSTOMER_ID = 2;
update T_CUSTOMER
  set FACEBOOK='@DThomas', TWITTER='dt_eat_wendys', LINKEDIN='DaveThomas'
  WHERE CUSTOMER_ID = 3;
update T_CUSTOMER
  set FACEBOOK='@Ccornell', TWITTER='soundgardenrocks', LINKEDIN='ChrisCornell'
  WHERE CUSTOMER_ID = 4;
update T_CUSTOMER
  set FACEBOOK='@ellendegen', TWITTER='ellenshow', LINKEDIN='EllenDeGeneres'
  WHERE CUSTOMER_ID = 5;

--NEED TO REMOVE CONSTRAINTS AND INDEXES ON T_CUSTOMER_BAK AND THEN APPLY TO T_CUSTOMER
DROP INDEX I_NAME;
ALTER TABLE T_CUSTOMER_BAK DROP PRIMARY KEY CASCADE DROP INDEX;

CREATE INDEX I_NAME ON T_CUSTOMER (name);
ALTER TABLE T_CUSTOMER ADD CONSTRAINT PK_T_CUSTOMER PRIMARY KEY (customer_id);
COMMIT;