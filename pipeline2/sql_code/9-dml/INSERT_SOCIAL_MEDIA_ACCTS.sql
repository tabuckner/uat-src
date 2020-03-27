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
COMMIT;