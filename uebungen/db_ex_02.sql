# author: a.voss@fh-aachen.de
# SQL-Commands Unit 0x02

# default schema - ggf Namen anpassen
USE mhist;

# all data
SELECT P.id,P.bezeichnung,P.warengruppe_id
FROM produkt P;

SELECT W.id,W.bezeichnung
FROM warengruppe W;

# goal
SELECT P.id,P.bezeichnung,W.bezeichnung
FROM produkt P JOIN warengruppe W on W.id = P.warengruppe_id;

# motivation: cross
SELECT P.id,P.bezeichnung,P.warengruppe_id,W.id,W.bezeichnung
FROM produkt P, warengruppe W;

# motivation: explicit join
SELECT P.id,P.bezeichnung,P.warengruppe_id,W.id,W.bezeichnung
FROM produkt P, warengruppe W
WHERE P.warengruppe_id=W.id;

# motivation: join explicitly given
SELECT P.id,P.bezeichnung,W.bezeichnung
FROM produkt P, warengruppe W
WHERE P.warengruppe_id=W.id;

# motivation: join by command
SELECT P.id,P.bezeichnung,W.bezeichnung
FROM produkt P
JOIN warengruppe W ON W.id = P.warengruppe_id;

# cross join implicitly and explicitly
SELECT P.id, P.bezeichnung, P.warengruppe_id, W.id, W.bezeichnung
FROM produkt P,warengruppe W;

SELECT P.id, P.bezeichnung, P.warengruppe_id, W.id, W.bezeichnung
FROM produkt P CROSS JOIN warengruppe W;

# inner join, old version (but def.)
SELECT P.id, P.bezeichnung, P.warengruppe_id, W.id, W.bezeichnung
FROM produkt P,warengruppe W
WHERE P.warengruppe_id=W.id;
# inner join, use this
SELECT P.id, P.bezeichnung, P.warengruppe_id, W.id, W.bezeichnung
FROM produkt P INNER JOIN warengruppe W
ON P.warengruppe_id=W.id;

# example 1
SELECT B.id, B.kunde_id, K.id, K.name
FROM bestellung B INNER JOIN kunde K ON B.kunde_id=K.id;

# example 2
SELECT T.* FROM tier T;

SELECT T.name, M.name
FROM tier T JOIN mitarbeiter M
ON M.id = T.mitarbeiter_id;

# multiple inner joins
SELECT * FROM abteilung A;

SELECT * FROM standort S;

SELECT R.abteilung_id, R.standort_id
FROM sitzt_am R;

SELECT R.abteilung_id,A.*,R.standort_id,S.* FROM sitzt_am R
    INNER JOIN abteilung A ON R.abteilung_id=A.id
    INNER JOIN standort S ON R.standort_id=S.id;

# example 1
SELECT R.* FROM arbeitet_in_als R;

SELECT M.id,M.name,A.name,L.beschreibung FROM arbeitet_in_als R
JOIN mitarbeiter M on M.id = R.mitarbeiter_id
JOIN abteilung A on A.id = R.abteilung_id
JOIN rolle L on L.id = R.rolle_id;

# outer join (left) vs inner join
SELECT T.* FROM tier T;

SELECT T.name, M.name
FROM tier T INNER JOIN mitarbeiter M
ON M.id = T.mitarbeiter_id;

SELECT T.name, M.name
FROM tier T LEFT OUTER JOIN mitarbeiter M
ON M.id = T.mitarbeiter_id;

# outer join (right)
SELECT T.name, M.name
FROM tier T RIGHT OUTER JOIN mitarbeiter M
ON M.id = T.mitarbeiter_id;

# outer join (full)
SELECT T.name, M.name
FROM tier T LEFT OUTER JOIN mitarbeiter M
ON M.id = T.mitarbeiter_id
UNION
SELECT T.name, M.name
FROM tier T RIGHT OUTER JOIN mitarbeiter M
ON M.id = T.mitarbeiter_id;

# change types, left and right in join
# FROM tier T LEFT OUTER JOIN mitarbeiter M
SELECT T.name, M.name
FROM mitarbeiter M RIGHT OUTER JOIN tier T
ON M.id = T.mitarbeiter_id;

# example

SELECT B.id, B.kunde_id, K.id, K.name
FROM bestellung B INNER JOIN kunde K
ON B.kunde_id=K.id;

SELECT B.id, B.kunde_id, K.id, K.name
FROM bestellung B RIGHT OUTER JOIN kunde K
ON B.kunde_id=K.id;

# switch to kemper - ggf Namen anpassen
use kemper;

# natural join
SELECT R.* FROM hoeren R;

SELECT S.* FROM studenten S;

SELECT V.* FROM Vorlesungen V;

SELECT S.Name,V.Titel
FROM Studenten S
NATURAL JOIN hoeren R
NATURAL JOIN Vorlesungen V;

SELECT S.Name,V.Titel
FROM Studenten S
JOIN hoeren R ON S.MatrNr = R.MatrNr
JOIN Vorlesungen V ON R.VorlNr = V.VorlNr;

# switch to matse_mhist - ggf Namen anpassen
use mhist;

# self join
SELECT M.id, M.name, N.name 'Vorgesetzter'
FROM mitarbeiter M
INNER JOIN mitarbeiter N
ON M.vorgesetzter_mitarbeiter_id=N.id;

### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###

# A2.1:
SELECT * FROM bestellung;
SELECT * FROM kunde;
SELECT * FROM mitarbeiter;
# a)
SELECT B.vom 'Datum',K.name 'Kunde' FROM bestellung B
INNER JOIN kunde K on B.kunde_id = K.id;
# b)
SELECT B.vom 'Datum',K.name 'Kunde'
FROM bestellung B, kunde K WHERE B.kunde_id = K.id;
# c)
SELECT B.vom 'Datum',K.name 'Kunde',M.name 'vermittelt' FROM bestellung B
INNER JOIN kunde K on B.kunde_id = K.id
INNER JOIN mitarbeiter M on B.vermittler_mitarbeiter_id = M.id;

# A2.2:
SELECT * FROM abteilung;
SELECT * FROM standort;
SELECT * FROM sitzt_am;
# a)
SELECT A.name, S.ort FROM abteilung A
JOIN sitzt_am R on A.id = R.abteilung_id
JOIN standort S on R.standort_id = S.id;
# b)
SELECT A.name, S.ort FROM abteilung A
LEFT OUTER JOIN sitzt_am R on A.id = R.abteilung_id
LEFT OUTER JOIN standort S on R.standort_id = S.id;
# c)
SELECT A.name, S.ort FROM standort S
RIGHT OUTER JOIN sitzt_am R on R.standort_id = S.id
RIGHT OUTER JOIN abteilung A on A.id = R.abteilung_id;

SELECT A.name, S.ort FROM abteilung A
LEFT OUTER JOIN sitzt_am R on A.id = R.abteilung_id
LEFT OUTER JOIN standort S on R.standort_id = S.id
WHERE isnull(S.ort);

# A2.3:
SELECT * FROM mitarbeiter;
SELECT * FROM arbeitet_in_als;
# a)
SELECT M1.name,M2.name 'Vorgesetzte' FROM mitarbeiter M1
JOIN mitarbeiter M2 on M1.vorgesetzter_mitarbeiter_id = M2.id
WHERE M2.name like 'Mia';
# b)
SELECT M1.name,A.name,L.beschreibung,M2.name 'Vorgesetzte' FROM mitarbeiter M1
JOIN arbeitet_in_als R on M1.id = R.mitarbeiter_id
JOIN abteilung A on A.id = R.abteilung_id
JOIN rolle L on R.rolle_id = L.id
JOIN mitarbeiter M2 on M1.vorgesetzter_mitarbeiter_id = M2.id;

# A2.4:
SELECT * FROM kunde;
SELECT * FROM kennt;
# a)
SELECT K1.name, K2.name
FROM kunde K1
JOIN kennt R on K1.id = R.kunde_a_id
JOIN kunde K2 on K2.id = R.kunde_b_id
WHERE K1.name like '%bank%' or K1.name like '%kasse%';
# b)
SELECT K1.name
FROM kunde K1
LEFT OUTER JOIN kennt R on K1.id = R.kunde_a_id
WHERE isnull(R.kunde_b_id);
