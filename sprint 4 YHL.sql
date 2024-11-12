-- NIVELL 1
-- Descàrrega els arxius CSV, estudia'ls i dissenya una base de dades amb un esquema d'estrella que contingui,
-- almenys 4 taules de les quals puguis realitzar les següents consultes:

CREATE DATABASE sprint4;

USE sprint4;


CREATE TABLE IF NOT EXISTS companies (
	id VARCHAR(15) PRIMARY KEY,
    company_name VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(100),
    country VARCHAR(100),
    website VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS credit_cards ( 
	id VARCHAR(50) PRIMARY KEY,
	user_id VARCHAR(20),
	iban VARCHAR(255),
	pan VARCHAR(45),
	pin CHAR(4),
	cvv CHAR(3),
	track1 VARCHAR(255),
	track2 VARCHAR(255),
	expiring_date varchar(255)
);


CREATE TABLE IF NOT EXISTS products (
	id INT PRIMARY KEY,
	product_name VARCHAR(100),
	price VARCHAR(10),
	colour VARCHAR(100),
	weight VARCHAR(100),
	warehouse_id VARCHAR(100)
);


CREATE TABLE IF NOT EXISTS transactions (
	id VARCHAR(350) PRIMARY KEY,
	card_id VARCHAR(50),
	bussiness_id VARCHAR(20),
	timestamp TIMESTAMP, 
	amount DECIMAL(10,2),
	declined BOOLEAN,
	product_ids VARCHAR(20),
	user_id INT,
	lat FLOAT,
	longitude FLOAT
);


CREATE TABLE IF NOT EXISTS users (
	id INT PRIMARY KEY,
	name VARCHAR(100),
	surname VARCHAR(100),
	phone VARCHAR(150),
	email VARCHAR(200),
	birth_date VARCHAR(100),
	country VARCHAR(150),
	city VARCHAR (100),
	postal_code VARCHAR(100),
	address VARCHAR(255),
	FOREIGN KEY (card_id) REFERENCES credit_cards(id),
    FOREIGN KEY (business_id) REFERENCES companies (company_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
		);




-- Exercici 1
-- Realitza una subconsulta que mostri tots els usuaris amb més de 30 transaccions utilitzant almenys 2 taules.


SELECT users.id, users.name, users.surname, COUNT(transactions.id) AS num_trans
FROM users
JOIN transactions ON users.id = transactions.user_id
GROUP BY users.id, users.name, users.surname
HAVING COUNT(transactions.id) > 30;


-- Exercici 2
-- Mostra la mitjana d'amount per IBAN de les targetes de crèdit a la companyia Donec Ltd, utilitza almenys 2 taules.

SELECT companies.company_name, credit_cards.iban, AVG(transactions.amount) AS avg_amount
FROM transactions
JOIN credit_cards ON transactions.card_id = credit_cards.id
JOIN companies ON transactions.business_id = companies.company_id
WHERE companies.company_name = 'Donec Ltd'
GROUP BY credit_cards.iban;


-- NIVELL 2
-- Crea una nova taula que reflecteixi l'estat de les targetes de crèdit basat en si les últimes tres transaccions van ser declinades i genera la següent consulta:

CREATE TABLE IF NOT EXISTS credit_card_status (
    card_id VARCHAR(50) PRIMARY KEY,
    status ENUM('active', 'inactive') NOT NULL
);


-- Exercici 1
-- Quantes targetes estan actives?


INSERT INTO credit_card_status (card_id, status)
SELECT credit_cards.id,
       CASE
           WHEN SUM(recent_transactions.declined) = 3 THEN 'inactive'
           ELSE 'active'
       END AS status
FROM credit_cards
JOIN (
    SELECT card_id, declined
    FROM (
        SELECT card_id, declined,
               ROW_NUMBER() OVER (PARTITION BY card_id ORDER BY timestamp DESC) AS row_num
        FROM transactions
    ) AS ranked_transactions
    WHERE row_num <= 3
) AS recent_transactions ON credit_cards.id = recent_transactions.card_id
GROUP BY credit_cards.id;


SELECT COUNT(*) AS active_cards
FROM credit_card_status
WHERE status = 'active';



-- Nivell 3
-- Crea una taula amb la qual puguem unir les dades del nou arxiu products.csv amb la base de dades creada, tenint en compte que des de transaction tens product_ids. Genera la següent consulta:

-- Exercici 1
-- Necessitem conèixer el nombre de vegades que s'ha venut cada producte.

