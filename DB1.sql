CREATE TABLE employees( emp_id SERIAL,
first_name VARCHAR(100), 
last_name VARCHAR(100), 
dob DATE,
city VARCHAR(100) );

CREATE TABLE employees_cdc( emp_id SERIAL,
first_name VARCHAR(100), 
last_name VARCHAR(100), 
dob DATE,
city VARCHAR(100), action varchar(100) );


CREATE OR REPLACE FUNCTION employees_trigger_function()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employees_cdc (emp_id, first_name, last_name, dob, city, action)
        VALUES (NEW.emp_id, NEW.first_name, NEW.last_name, NEW.dob, NEW.city, 'INSERT');
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employees_cdc (emp_id, first_name, last_name, dob, city, action)
        VALUES (NEW.emp_id, NEW.first_name, NEW.last_name, NEW.dob, NEW.city, 'UPDATE');
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employees_cdc (emp_id, first_name, last_name, dob, city, action)
        VALUES (OLD.emp_id, OLD.first_name, OLD.last_name, OLD.dob, OLD.city, 'DELETE');
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER employees_trigger
AFTER INSERT OR UPDATE OR DELETE ON employees
FOR EACH ROW EXECUTE FUNCTION employees_trigger_function();