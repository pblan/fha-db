# author: a.voss@fh-aachen.de
# SQL-Commands Unit 0x03

# default schema
USE mhist;

# Group Functions verwenden
SELECT * FROM produkt;
SELECT min(stueckpreis), max(stueckpreis), sum(stueckpreis), count(stueckpreis),
       sum(stueckpreis)/count(stueckpreis), avg(stueckpreis), stddev_pop(stueckpreis),
       sqrt(var_pop(stueckpreis)) FROM produkt;

# Group Functions auf Selektion verwenden.
SELECT * FROM produkt
WHERE warengruppe_id=1;

SELECT count(*), warengruppe_id, avg(stueckpreis) FROM produkt
WHERE warengruppe_id=1;

SELECT count(stueckpreis), warengruppe_id, avg(stueckpreis) FROM produkt
WHERE warengruppe_id=1;

SELECT count(distinct stueckpreis), warengruppe_id, avg(stueckpreis) FROM produkt
WHERE warengruppe_id=1;

SELECT count(distinct stueckpreis), warengruppe_id, avg(distinct stueckpreis) FROM produkt
WHERE warengruppe_id=1;

# Group Functions auf gruppierten Daten verwenden.
SELECT count(*), warengruppe_id,
       min(stueckpreis), max(stueckpreis), avg(stueckpreis) FROM produkt
GROUP BY warengruppe_id;

# Group Functions auf gruppierten Daten einer Selektion verwenden.
SELECT count(*), warengruppe_id,
       min(stueckpreis), max(stueckpreis), avg(stueckpreis)
FROM produkt WHERE warengruppe_id IN (1,2,4)
GROUP BY warengruppe_id;

# Group Functions auf gruppierten Daten mit Bedingung verwenden.
SELECT count(*), warengruppe_id,
       min(stueckpreis), max(stueckpreis), avg(stueckpreis)
FROM produkt WHERE warengruppe_id IN (1,2,4)
GROUP BY warengruppe_id HAVING min(stueckpreis)>1;

# Group Functions korrekt verwenden.
SELECT bezeichnung, warengruppe_id, stueckpreis, einheit FROM produkt
WHERE warengruppe_id IN (1,2,4);

SELECT bezeichnung, warengruppe_id, min(stueckpreis), einheit FROM produkt
GROUP BY warengruppe_id;

# Group Functions mit Alias verwenden.
SELECT count(*), warengruppe_id,
       min(stueckpreis) S FROM produkt
WHERE warengruppe_id IN (1,2,4)
GROUP BY warengruppe_id HAVING 3*S>1
ORDER BY S;

# GROUP BY mit mehreren Attributen verwenden.
SELECT count(*) FROM produkt
WHERE einheit='KG' AND umsatzsteuer=0.07;  #  4
SELECT count(*) FROM produkt
WHERE einheit='PK' AND umsatzsteuer=0.07;  # 14
SELECT count(*) FROM produkt
WHERE einheit='ST' AND umsatzsteuer=0.07;  # 16
# ...
SELECT count(*) FROM produkt
WHERE einheit='ST' AND umsatzsteuer=0.19;  #  6

SELECT count(umsatzsteuer), umsatzsteuer,
       count(einheit), einheit,
       min(stueckpreis), max(stueckpreis)
FROM produkt GROUP BY umsatzsteuer, einheit
ORDER BY umsatzsteuer;

# Group Functions mit Joins verwenden.
SELECT P.warengruppe_id, P.stueckpreis, W.bezeichnung
FROM produkt P
INNER JOIN warengruppe W ON P.warengruppe_id=W.id
WHERE W.bezeichnung LIKE '%getränke';

SELECT count(P.stueckpreis), P.warengruppe_id, avg(P.stueckpreis), W.bezeichnung
FROM produkt P
INNER JOIN warengruppe W ON P.warengruppe_id=W.id
WHERE W.bezeichnung LIKE '%getränke' GROUP BY warengruppe_id;

### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###

# A3.1:
SELECT * FROM mitarbeiter;

SELECT M.id, M.name, M.jahresgehalt, M.vorgesetzter_mitarbeiter_id, V.name as 'Boss'
FROM mitarbeiter M JOIN mitarbeiter V on M.vorgesetzter_mitarbeiter_id = V.id
WHERE M.jahresgehalt>0 ORDER BY M.vorgesetzter_mitarbeiter_id;
# (a)
SELECT V.name, count(M.vorgesetzter_mitarbeiter_id),min(M.jahresgehalt), max(M.jahresgehalt)
FROM mitarbeiter M JOIN mitarbeiter V on M.vorgesetzter_mitarbeiter_id = V.id
WHERE M.jahresgehalt>0
GROUP BY M.vorgesetzter_mitarbeiter_id;
# (b)
SELECT V.name, count(M.vorgesetzter_mitarbeiter_id),min(M.jahresgehalt), max(M.jahresgehalt),
       avg(M.jahresgehalt) as 'avg'
FROM mitarbeiter M JOIN mitarbeiter V on M.vorgesetzter_mitarbeiter_id = V.id
WHERE M.jahresgehalt>0
GROUP BY M.vorgesetzter_mitarbeiter_id HAVING avg>50000;

# A3.2:
SELECT * FROM produkt;
SELECT * FROM produkt WHERE bezeichnung like '%pizza%';

# (a)
SELECT count(id) as 'pizzen', avg(stueckpreis) as 'avg'
FROM produkt WHERE bezeichnung like '%pizza%';

# (b)
SELECT * FROM produkt WHERE warengruppe_id IN (1,2);

SELECT W.bezeichnung, count(P.id)
FROM produkt P JOIN warengruppe W on W.id = P.warengruppe_id
WHERE P.warengruppe_id IN (1,2)
GROUP BY P.warengruppe_id;

# (c)
SELECT W.bezeichnung, count(P.id), min(P.stueckpreis) as 'min'
FROM produkt P JOIN warengruppe W on W.id = P.warengruppe_id
GROUP BY P.warengruppe_id HAVING min>2;

# (d)
SELECT * FROM produkt P
WHERE P.stueckpreis>=1 and P.stueckpreis<=2;

SELECT count(P.umsatzsteuer),P.umsatzsteuer FROM produkt P
WHERE P.stueckpreis>=1 and P.stueckpreis<=2
GROUP BY P.umsatzsteuer;

# A3.3:
SELECT * FROM arbeitet_in_als;
SELECT M.name, A.name, L.beschreibung FROM mitarbeiter M
    JOIN arbeitet_in_als R on M.id = R.mitarbeiter_id
JOIN abteilung A on A.id = R.abteilung_id
JOIN rolle L on L.id = R.rolle_id
ORDER BY M.name,A.id;

SELECT M.name,A.name,count(L.id) FROM mitarbeiter M
    JOIN arbeitet_in_als R on M.id = R.mitarbeiter_id
    JOIN abteilung A on A.id = R.abteilung_id
    JOIN rolle L on L.id = R.rolle_id
GROUP BY M.id,A.id;

SELECT M.name,A.name,count(L.id) as 'rollen' FROM mitarbeiter M
    JOIN arbeitet_in_als R on M.id = R.mitarbeiter_id
    JOIN abteilung A on A.id = R.abteilung_id
    JOIN rolle L on L.id = R.rolle_id
GROUP BY M.id,A.id HAVING rollen>2;

### genauer:

SELECT M.id,A.id,count(L.id) as 'rollen' FROM mitarbeiter M
    JOIN arbeitet_in_als R on M.id = R.mitarbeiter_id
    JOIN abteilung A on A.id = R.abteilung_id
    JOIN rolle L on L.id = R.rolle_id
GROUP BY M.id,A.id HAVING rollen>2;

SELECT A.name,M.name,Q.rollen FROM (
    SELECT M.id as 'mid',A.id as 'aid',count(L.id) as 'rollen' FROM mitarbeiter M
        JOIN arbeitet_in_als R on M.id = R.mitarbeiter_id
        JOIN abteilung A on A.id = R.abteilung_id
        JOIN rolle L on L.id = R.rolle_id
    GROUP BY M.id,A.id
) Q
JOIN abteilung A on A.id = Q.aid JOIN mitarbeiter M on M.id=Q.mid
WHERE Q.rollen>2;


