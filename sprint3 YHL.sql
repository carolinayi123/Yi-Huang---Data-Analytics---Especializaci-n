-- SPRINT 3

-- EXERCICI 1
 -- La teva tasca és dissenyar i crear una taula anomenada "credit_card" que emmagatzemi detalls crucials sobre les targetes de crèdit.
 -- La nova taula ha de ser capaç d'identificar de manera única cada targeta i establir una relació adequada amb les altres dues taules ("transaction" i "company").
 -- Després de crear la taula serà necessari que ingressis la informació del document denominat "dades_introduir_credit".
 -- Recorda mostrar el diagrama i realitzar una breu descripció d’aquest.
 
 -- Creamos la tabla credit card
  
CREATE INDEX idx_credit_card_id ON transaction(credit_card_id);

CREATE TABLE IF NOT EXISTS credit_card (
    id VARCHAR(15) PRIMARY KEY,
    FOREIGN KEY(id) REFERENCES transaction(credit_card_id), 
	iban VARCHAR(50),
    pan VARCHAR(20),
    pin smallint,
    cvv smallint,
    expiring_date VARCHAR(15)
);
	
-- EXERCICI 2
 -- El departament de Recursos Humans ha identificat un error en el número de compte de l'usuari amb ID “CcU-2938”.
 -- La informació que ha de mostrar-se per a aquest registre és: “R323456312213576817699999”.
 -- Recorda mostrar que el canvi es va realitzar.

UPDATE credit_card
SET iban = 'R323456312213576817699999'
WHERE id = 'CcU-2938';

SELECT * FROM credit_card
WHERE id = 'CcU-2938';

-- EXERCICI 3
 -- En la taula "transaction" ingressa un nou usuari amb la següent informació:
 
INSERT INTO company (id)
VALUES ('b-9999');

INSERT INTO transaction (id, credit_card_id, company_id, user_id, lat, longitude, amount, declined)
VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD', 'CcU-9999', 'b-9999', '9999', '829.999', '-117.999', '111.11', '0');

SELECT*
FROM transaction
WHERE id= '108B1D1D-5B23-A76C-55EF-C568E49A99DD';

-- Exercici 4
 -- Des de recursos humans et sol·liciten eliminar la columna "pan" de la taula credit_card.
 -- Recorda mostrar el canvi realitzat.

ALTER TABLE credit_card
DROP COLUMN pan;

SELECT* 
FROM credit_card;

-- Nivell 2

 -- Exercici 1
 -- Elimina de la taula transaction el registre amb ID 02C6201E-D90A-1859-B4EE-88D2986D3B02 de la base de dades.
 
SET FOREIGN_KEY_CHECKS = 0;

UPDATE transaction SET user_id = NULL WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

DELETE FROM transaction WHERE id = '02C6201E-D90A-1859-B4EE-88D2986D3B02';

SET FOREIGN_KEY_CHECKS = 1;


 -- Exercici 2
  -- La secció de màrqueting desitja tenir accés a informació específica per a realitzar anàlisi i estratègies efectives.
  -- S'ha sol·licitat crear una vista que proporcioni detalls clau sobre les companyies i les seves transaccions.
  -- Serà necessària que creïs una vista anomenada VistaMarketing que contingui la següent informació:
  -- Nom de la companyia. Telèfon de contacte. País de residència. Mitjana de compra realitzat per cada companyia.
  -- Presenta la vista creada, ordenant les dades de major a menor mitjana de compra.

CREATE VIEW VistaMarketing AS
SELECT 
    company.company_name, 
    company.phone,
    company.country,
    AVG(transaction.amount) AS avg_transaction
FROM company 
JOIN transaction ON company.id = transaction.company_id
WHERE declined = 0
GROUP BY company.company_name, company.phone, company.country;
    
SELECT * FROM VistaMarketing
ORDER BY avg_transaction DESC;


 -- Exercici 3
 -- Filtra la vista VistaMarketing per a mostrar només les companyies que tenen el seu país de residència en "Germany".

SELECT *
FROM VistaMarketing
WHERE country = 'Germany'
ORDER BY avg_transaction DESC;

	-- NIVELL 3
-- Exercici 1
-- La setmana vinent tindràs una nova reunió amb els gerents de màrqueting.
-- Un company del teu equip va realitzar modificacions en la base de dades,
-- però no recorda com les va realitzar. Et demana que l'ajudis a deixar els comandos
-- executats per a obtenir el següent diagrama:

ALTER TABLE user RENAME TO data_user;
ALTER TABLE data_user RENAME COLUMN email TO personal_email;

ALTER TABLE credit_card ADD COLUMN fecha_actual DATE;
ALTER TABLE credit_card MODIFY COLUMN id VARCHAR(20);
ALTER TABLE credit_card MODIFY COLUMN pin VARCHAR(4);
ALTER TABLE credit_card MODIFY COLUMN cvv INT;
ALTER TABLE credit_card MODIFY COLUMN expiring_date VARCHAR(10);

ALTER TABLE company DROP website;


 -- Exercici 2
 -- L'empresa també et sol·licita crear una vista anomenada "InformeTecnico" que contingui la següent informació:
 -- ID de la transacció
 -- Nom de l'usuari/ària
 -- Cognom de l'usuari/ària
 -- IBAN de la targeta de crèdit usada.
 -- Nom de la companyia de la transacció realitzada.
 -- Assegura't d'incloure informació rellevant de totes dues taules i utilitza àlies per a canviar de nom columnes segons sigui necessari.
 -- Mostra els resultats de la vista, ordena els resultats de manera descendent en funció de la variable ID de transaction.


CREATE VIEW InformeTecnico AS
SELECT 
    transaction.id AS número_transacción,
    data_user.name AS nombre,
    data_user.surname AS apellido,
    credit_card.iban AS iban,
    company.company_name AS compañía
FROM transaction
JOIN data_user ON transaction.user_id = data_user.id
JOIN credit_card ON transaction.credit_card_id = credit_card.id
JOIN company ON transaction.company_id = company.id;


SELECT * FROM InformeTecnico
ORDER BY número_transacción DESC;



