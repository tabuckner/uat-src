--REMOVE CUSTOMER SOCIAL MEDIA FIELDS
alter table T_CUSTOMER drop column FACEBOOK;
alter table T_CUSTOMER drop column TWITTER;
alter table T_CUSTOMER drop column LINKEDIN;