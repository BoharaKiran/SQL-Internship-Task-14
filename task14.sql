use intern_training_db;

CREATE TABLE employees11 (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    department VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DESCRIBE employees11;

#Stored Procedure to Insert Employee
DELIMITER //

CREATE PROCEDURE insert_employee(
    IN p_name VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    IN p_department VARCHAR(50)
)
BEGIN
    INSERT INTO employees11(name, salary, department)
    VALUES (p_name, p_salary, p_department);
END //

DELIMITER ;

#Call Procedure & Verify
CALL insert_employee('Kiran', 50000, 'IT');
CALL insert_employee('Moni', 55000, 'IT');

SELECT * FROM employees11;

DROP FUNCTION IF EXISTS calculate_bonus;

DELIMITER //
#Function to Calculate Bonus
CREATE FUNCTION calculate_bonus(salary DECIMAL(10,2))
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    RETURN salary * 0.10;
END//

DELIMITER ;

#Using the Function
SELECT name, salary, calculate_bonus(salary) AS bonus
FROM employees11;

#Compare Functions vs Procedures

/*
Functions                            |        Procedures
____________________________________________________________________________________
-return a value after the execution      return a value using “IN OUT” and “OUT”
-not return multiple result              return multiple result sets.
-read data                               read and modify data
-not support try-catch blocks            supports try-catch blocks for error handling
-used in SELECT statement                can’t be operated in the SELECT statement*/


#Handle Errors Inside Procedures
DELIMITER //

CREATE PROCEDURE safe_insert_employee(
    IN p_name VARCHAR(50),
    IN p_salary DECIMAL(10,2),
    IN p_department VARCHAR(50)
)
BEGIN
    -- Error handler
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SELECT 'Error occurred while inserting employee data' AS message;
    END;

    -- Insert using YOUR table columns
    INSERT INTO employees11(name, salary, department)
    VALUES (p_name, p_salary, p_department);

    -- Success message
    SELECT 'Employee inserted successfully' AS message;
END //

DELIMITER ;

CALL safe_insert_employee('Kiran', 50000, 'IT');

SELECT * FROM employees11;

# Optimize Reusable Business Logic
DELIMITER //
CREATE PROCEDURE get_employee_bonus()
BEGIN
    SELECT name, salary, calculate_bonus(salary) AS bonus
    FROM employees11;
END//
DELIMITER ;

#Map Procedures to Backend Services
cursor.callproc('insert_employee', ('Amit', 55000, 'Finance'))

