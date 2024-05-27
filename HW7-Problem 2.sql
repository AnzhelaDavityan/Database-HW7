/*Problem 2, Subtask 1*/
CREATE TABLE CUSTOMER (
    SSN VARCHAR(11) PRIMARY KEY,
    name VARCHAR(150),
    surname VARCHAR(175),
    phone_number VARCHAR(12),
    plan VARCHAR(10)
);

CREATE TABLE BILL (
    SSN VARCHAR(11),
    month INT,
    year INT,
    bill_amount DECIMAL(10, 2),
    PRIMARY KEY (SSN, month, year),
    FOREIGN KEY (SSN) REFERENCES CUSTOMER(SSN)
);

CREATE TABLE PHONECALL (
    SSN VARCHAR(11),
    date DATE,
    time TIME,
    called_number VARCHAR(12),
    duration INT,
    PRIMARY KEY (SSN, date, time),
    FOREIGN KEY (SSN) REFERENCES CUSTOMER(SSN)
);

CREATE TABLE PRICINGPLAN (
    plan_code VARCHAR(10) PRIMARY KEY,
    connection_fee DECIMAL(5, 2),
    price_per_second DECIMAL(5, 3)
);

/*Problem 2, Subtask 2*/

CREATE OR REPLACE FUNCTION update_bill_after_call()
RETURNS TRIGGER AS $$
DECLARE
    fee DECIMAL(5, 2);
    price_per_sec DECIMAL(5, 3);
    seconds INT;
    amount DECIMAL(10, 2);
BEGIN
    SELECT connection_fee, price_per_second INTO fee, price_per_sec
    FROM PRICINGPLAN
    WHERE plan_code = (SELECT plan FROM CUSTOMER WHERE SSN = NEW.SSN);

    seconds := NEW.duration;
    amount := fee + price_per_sec * seconds;

    UPDATE BILL
    SET bill_amount = bill_amount + amount
    WHERE SSN = NEW.SSN AND month = EXTRACT(MONTH FROM NEW.date) AND year = EXTRACT(YEAR FROM NEW.date);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER CallCharges
AFTER INSERT ON PHONECALL
FOR EACH ROW
EXECUTE FUNCTION update_bill_after_call();

/*Problem 2, Subtask 3*/

INSERT INTO CUSTOMER (SSN, name, surname, phone_number, plan)
SELECT
    ssn,
    'Name' || ssn AS name,
    'Surname' || ssn AS surname,
    '1234567890' || ssn AS phone_number,
    CASE WHEN random() < 0.5 THEN 'PlanA' ELSE 'PlanB' END AS plan
FROM generate_series(1, 10) ssn;

SELECT * FROM customer

INSERT INTO PRICINGPLAN VALUES
('PlanA', 12.00, 0.04),
('PlanB', 16.00, 0.07);

SELECT * FROM pricingplan

INSERT INTO BILL
SELECT
    ssn,
    EXTRACT(MONTH FROM CURRENT_DATE) AS month,
    EXTRACT(YEAR FROM CURRENT_DATE) AS year,
    0.00 AS bill_amount
FROM CUSTOMER;

SELECT * FROM bill

INSERT INTO PHONECALL (SSN, date, time, called_number, duration)
SELECT
    ssn,
    CURRENT_DATE + (random() * 28)::INTEGER AS date,
    CURRENT_TIME - make_interval(secs => (random() * 3600)::INTEGER) AS time,
    '9876543210' || (random() * 10)::INTEGER AS called_number,
    (random() * 300)::INTEGER AS duration
FROM CUSTOMER;

SELECT * FROM phonecall


SELECT * FROM bill