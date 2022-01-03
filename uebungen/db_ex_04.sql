# author: a.voss@fh-aachen.de
# SQL-Commands Unit 0x04

# default schema
# USE matse_mhist;
USE mhist;

# Mia bzw. id von Mia suchen...
SELECT M.id, M.name FROM mitarbeiter M
WHERE M.name like 'Mia';

# Mitarbeiter/innen mit Mia als Vorgesetzte (unschön)
SELECT M.id, M.name FROM mitarbeiter M
WHERE M.vorgesetzter_mitarbeiter_id = 1;

# Subselect
SELECT M.id, M.name FROM mitarbeiter M
WHERE M.vorgesetzter_mitarbeiter_id = (
    SELECT id FROM mitarbeiter WHERE name='Mia'
);

# Subselect
SELECT M.id, M.name FROM mitarbeiter M
WHERE M.jahresgehalt > (
    SELECT jahresgehalt FROM mitarbeiter WHERE name='Luis'
);

# kombiniert
SELECT M.id,M.name FROM mitarbeiter M
WHERE M.jahresgehalt > (
    SELECT jahresgehalt FROM mitarbeiter WHERE name='Sofia'
) and M.vorgesetzter_mitarbeiter_id = (
    SELECT id FROM mitarbeiter WHERE name='Mia'
);

# mit group-fcns
SELECT M.id,M.name,jahresgehalt FROM mitarbeiter M
WHERE M.jahresgehalt = (
  SELECT min(jahresgehalt) FROM mitarbeiter
  WHERE jahresgehalt>0
);

# IN
SELECT name, jahresgehalt FROM mitarbeiter
WHERE jahresgehalt IN (10000,12000,14000);

# group-fcns mit IN
SELECT name, jahresgehalt FROM mitarbeiter
WHERE jahresgehalt IN (
    SELECT min(M.jahresgehalt) FROM mitarbeiter M
    GROUP BY M.vorgesetzter_mitarbeiter_id
);

# ANY
SELECT bezeichnung, stueckpreis, warengruppe_id
FROM produkt P WHERE P.stueckpreis < ANY (
    SELECT stueckpreis FROM produkt WHERE warengruppe_id=4
) AND P.warengruppe_id <> 4;

# ALL
SELECT bezeichnung, stueckpreis, warengruppe_id
FROM produkt P WHERE P.stueckpreis < ALL (
    SELECT stueckpreis FROM produkt WHERE warengruppe_id=4
) AND P.warengruppe_id <> 4;

# multiple arguments in IN
SELECT bezeichnung, einheit, stueckpreis, warengruppe_id FROM produkt
WHERE (einheit, stueckpreis) in (
    SELECT einheit, stueckpreis FROM produkt
    WHERE warengruppe_id=1
) and warengruppe_id <> 1;

# Inline Views
SELECT W.*, Q.A FROM warengruppe W, (
    SELECT P.warengruppe_id, avg(P.stueckpreis) A
    FROM produkt P GROUP BY warengruppe_id
) Q
WHERE W.id=Q.warengruppe_id;

# Correlated Subselects
SELECT bezeichnung, stueckpreis, warengruppe_id
FROM produkt P WHERE P.stueckpreis > (
    SELECT avg(stueckpreis) FROM produkt
    WHERE warengruppe_id=P.warengruppe_id
);

# exists
SELECT M.id, M.name FROM mitarbeiter M
WHERE EXISTS (
    SELECT id FROM mitarbeiter
    WHERE vorgesetzter_mitarbeiter_id=M.id
);

### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###



### STOP ### solutions follow ###

# A4.1:
SELECT * FROM produkt WHERE bezeichnung like 'Chips';
SELECT * FROM produkt P WHERE P.stueckpreis=1.99;
# Welche Produkte haben den gleichen Preis wie ’Chips’?
SELECT P.bezeichnung,P.stueckpreis FROM produkt P WHERE P.stueckpreis = (
    SELECT stueckpreis FROM produkt WHERE bezeichnung like 'Chips'
) and P.bezeichnung<>'Chips';

# A4.2
SELECT count(*) FROM produkt WHERE warengruppe_id=2;
SELECT P.warengruppe_id,P.bezeichnung,count(*)
FROM produkt P GROUP BY P.warengruppe_id;
# Welche Warengruppen haben genau so viele Produkte wie die Warengruppe 2?
SELECT P.warengruppe_id,w.bezeichnung,count(*) as 'anzahl'
FROM produkt P join warengruppe w on P.warengruppe_id = w.id
GROUP BY P.warengruppe_id, w.bezeichnung
HAVING count(*) = (
    SELECT count(*) FROM produkt WHERE warengruppe_id=2
);

# A4.3
SELECT * FROM produkt;
# Welche Produkte haben innerhalb einer Warengruppe einen gleichen Preis?
SELECT P.warengruppe_id,P.bezeichnung,P.stueckpreis FROM produkt P
WHERE EXISTS(
    SELECT 'X' FROM produkt
    WHERE stueckpreis=P.stueckpreis and warengruppe_id=P.warengruppe_id and id<>P.id
) ORDER BY P.warengruppe_id, P.stueckpreis;

# A4.4
SELECT * FROM mitarbeiter;
SELECT * FROM abteilung WHERE name like 'Marketing';
SELECT * FROM rolle WHERE beschreibung like 'Auszubildender';
SELECT * FROM arbeitet_in_als;
# Welcher Mitarbeiter arbeitet als 'Auszubildender' im Marketing?
SELECT M.* FROM arbeitet_in_als R JOIN mitarbeiter M on R.mitarbeiter_id = M.id
WHERE R.abteilung_id = (
    SELECT id FROM abteilung WHERE name like 'Marketing'
) and R.rolle_id = (
    SELECT id FROM rolle WHERE beschreibung like 'Auszubildender'
);

# A4.5
# Welche Mitarbeiter haben nur eine Gesamtstundenzahl von 5?
SELECT R.mitarbeiter_id,M.name,M.jahresgehalt,sum(R.wochenstunden) as 'sum'
FROM arbeitet_in_als R JOIN mitarbeiter M on R.mitarbeiter_id = M.id
GROUP BY R.mitarbeiter_id HAVING sum(R.wochenstunden)=5;

# A4.6
SELECT * FROM produkt P;
SELECT * FROM bestellung B;
SELECT * FROM besteht_aus R;
# Welche Mitarbeiter haben schon eine Bestellung vermittelt?
SELECT M.name,B.id FROM bestellung B
    JOIN mitarbeiter M on B.vermittler_mitarbeiter_id = M.id;

# A4.7
# Welches Produkt wurde noch nicht bestellt?
SELECT * FROM produkt P WHERE NOT EXISTS(
    SELECT 'X' FROM besteht_aus R WHERE R.produkt_id=P.id
);
# oder effizienter
select * from produkt p
where p.id not in
(select produkt_id from besteht_aus);

# A4.8
# Bestellungen
SELECT R.bestellung_id,P.bezeichnung,R.einheiten*P.stueckpreis
FROM besteht_aus R JOIN produkt P on P.id = R.produkt_id;
# Summieren Sie die Bestellungen zum jeweiligen Gesamtpreis.
SELECT R.bestellung_id,sum(R.einheiten*P.stueckpreis) as 'sum'
FROM besteht_aus R JOIN produkt P on P.id = R.produkt_id
GROUP BY R.bestellung_id;

# A4.9
SELECT B.id,B.vom,K.name,Q.sum FROM bestellung B JOIN (
    SELECT R.bestellung_id,sum(R.einheiten*P.stueckpreis) as 'sum'
    FROM besteht_aus R JOIN produkt P on P.id = R.produkt_id
    GROUP BY R.bestellung_id
) Q on B.id=Q.bestellung_id JOIN kunde K on B.kunde_id = K.id;

