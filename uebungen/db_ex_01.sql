# author: a.voss@fh-aachen.de
# SQL-Commands Unit 0x01

# default schema
USE Mhist; # oder matse_mhist;

# all data
#SELECT * FROM matse_mhist.produkt;
SELECT * FROM produkt;

SELECT P.* FROM produkt P;

# note column-names
SELECT
  id AS 'ID',
  bezeichnung 'Produkt',
  stueckpreis 'Preis'
FROM produkt;

# calculated values
SELECT
    id 'ID',
    concat(bezeichnung,'[',einheit,']') 'Produkt',
    stueckpreis 'Preis',
    round(stueckpreis/(1.0+umsatzsteuer),2) 'exkl. USt.'
FROM produkt;

# more calculated values involving NULL
SELECT
    name,
    ausfallrisiko_prozent,
    100-ausfallrisiko_prozent 'Erfuellung1',
    if(ausfallrisiko_prozent is NULL,
        100.00,100-ausfallrisiko_prozent) 'Erfuellung2',
   coalesce(100-ausfallrisiko_prozent,100.00) 'Erfuellung3'
FROM kunde;

# distinct values
SELECT warengruppe_id FROM produkt;
SELECT distinct warengruppe_id FROM produkt;

# count number of lines, with or without NULLs
select * from kunde;
select count(*) from kunde;
select count(rabatt_prozent) from kunde;
select count(ausfallrisiko_prozent) from kunde;

# selection with WHERE
SELECT bezeichnung, stueckpreis FROM produkt
WHERE stueckpreis=1.99;

# string comparison with like including wildcards % and _
SELECT bezeichnung, stueckpreis FROM produkt
    WHERE bezeichnung like '%pizza';
SELECT bezeichnung, stueckpreis FROM produkt
    WHERE bezeichnung like '%pizza' and
    not bezeichnung like '%Spinat%';

# between and in
SELECT bezeichnung, stueckpreis FROM produkt
WHERE stueckpreis between 1.00 and 2.00;
SELECT bezeichnung, stueckpreis FROM produkt
    WHERE stueckpreis in (0.99, 1.99, 2.99);

# different clauses
SELECT bezeichnung, stueckpreis FROM produkt
WHERE (stueckpreis<1.00 or stueckpreis>5.00)
  and warengruppe_id=11;
SELECT name, ausfallrisiko_prozent FROM kunde
  WHERE ausfallrisiko_prozent is not null;

# oder by, asc, desc
SELECT bezeichnung, stueckpreis FROM produkt
WHERE warengruppe_id in (1,3,4) ORDER BY stueckpreis desc;
SELECT bezeichnung, stueckpreis FROM produkt
WHERE warengruppe_id in (1,3,4) ORDER BY stueckpreis asc,
                                         bezeichnung desc;

# interactive usage
select now(), 1+2*3, rand();
select now(), 1+2*3, rand() FROM dual;

### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###

# A1.1:
select * from abteilung;
select * from kunde;
select * from mitarbeiter;
select * from produkt;
select * from warengruppe;
select * from rolle;

# A1.2
select distinct umsatzsteuer from produkt;
select count(distinct umsatzsteuer) from produkt;

# A1.3
select name, rabatt_prozent from kunde
    where name like '%bank%';

# A1.4
select * from mitarbeiter
    where name='Mia' or name='Ben';
# -> id=1 or id=2
select name, round(jahresgehalt/12.0,0) AS 'Monatsgehalt' from mitarbeiter
    where vorgesetzter_mitarbeiter_id in (1,2);

# A1.5
select * from mitarbeiter
    where name like 'M%';
select count(*) from mitarbeiter
    where name like 'M%';
select * from mitarbeiter
    where name like '%m%';
select count(*) from mitarbeiter
    where name like '%m%';
