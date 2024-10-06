CREATE DATABASE sqlproject;

use sqlproject;

CREATE TABLE students (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100),
    last_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    gender VARCHAR(10),
    address VARCHAR(255)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    course_name VARCHAR(100),
    course_description TEXT,
    credits INT
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

INSERT INTO students (first_name, last_name, email, date_of_birth, gender, address)
VALUES 
('karthik', 'kumar', 'karthik12345@gmail.com', '2000-05-15', 'Male', '25 new St'),
('Jane', 'Smith', 'jane.smith@example.com', '1999-10-22', 'Female', '456 Elm St'),
('Jakie',  'Chan', 'jakiechan235432.doe@example.com', '2000-05-15', 'Male', '26 Main St'),
('Arun', 'Kumar', 'kumaran2324@example.com', '1999-10-22', 'Female', '45 first St'),
('Rahul', 'Kumar', 'rahulkumar35236@gmail.com', '2005-03-25', 'Male', '250 new St'),
('Ashwanth', 'Joel', 'aswanthjoel3265@example.com', '2003-06-20', 'Female', '423 St');






INSERT INTO courses (course_name, course_description, credits)
VALUES 
('Mathematics', 'Study of numbers and equations', 4),
('Physics', 'Study of matter and energy', 3),
('Mathematics', 'Study of numbers and equations', 4),
('Physics', 'Study of matter and energy', 3);

SELECT * FROM students;

SELECT * FROM courses;


UPDATE students
SET address = '25 new St',email ='karthik12345@gmail.com',first_name = 'karthik',last_name = 'kumar'
WHERE student_id = 1;


UPDATE courses
SET credits = 5
WHERE course_id = 2;


UPDATE courses
SET credits = 5
WHERE course_id = 5;


DELETE FROM students
WHERE student_id = 2;


DELETE FROM courses
WHERE course_id = 1;


SELECT students.first_name, students.last_name 
FROM enrollments
JOIN students ON enrollments.student_id = students.student_id
JOIN courses ON enrollments.course_id = courses.course_id
WHERE courses.course_name = 'Mathematics';

SELECT courses.course_name, COUNT(enrollments.student_id) AS student_count
FROM enrollments
JOIN courses ON enrollments.course_id = courses.course_id
GROUP BY courses.course_name;

SELECT students.first_name, students.last_name, GROUP_CONCAT(courses.course_name SEPARATOR ', ') AS courses_enrolled
FROM enrollments
JOIN students ON enrollments.student_id = students.student_id
JOIN courses ON enrollments.course_id = courses.course_id
GROUP BY students.student_id;



DELIMITER $$

CREATE PROCEDURE AddStudent(
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_dob DATE,
    IN p_gender VARCHAR(10),
    IN p_address VARCHAR(255)
)
BEGIN
    INSERT INTO students (first_name, last_name, email, date_of_birth, gender, address)
    VALUES (p_first_name, p_last_name, p_email, p_dob, p_gender, p_address);
END$$

DELIMITER ;


CALL AddStudent('Mark', 'Twain', 'mark.twain@example.com', '1998-03-25', 'Male', '101 River St');


DELIMITER $$

CREATE PROCEDURE AddCourse(
    IN p_course_name VARCHAR(100),
    IN p_course_description TEXT,
    IN p_credits INT
)
BEGIN
    INSERT INTO courses (course_name, course_description, credits)
    VALUES (p_course_name, p_course_description, p_credits);
END$$

DELIMITER ;

CALL AddCourse('History', 'Study of past events', 3);


DELIMITER $$

CREATE PROCEDURE EnrollStudent(
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_enrollment_date DATE
)
BEGIN
    INSERT INTO enrollments (student_id, course_id, enrollment_date)
    VALUES (p_student_id, p_course_id, p_enrollment_date);
END$$

DELIMITER ;


CALL EnrollStudent(1, 2, '2024-01-10');


DELIMITER $$

CREATE PROCEDURE GetStudentCourses(
    IN p_student_id INT
)
BEGIN
    SELECT s.first_name, s.last_name, s.email, c.course_name, e.enrollment_date
    FROM students s
    JOIN enrollments e ON s.student_id = e.student_id
    JOIN courses c ON e.course_id = c.course_id
    WHERE s.student_id = p_student_id;
END$$

DELIMITER ;


CALL GetStudentCourses(1);


DELIMITER $$

CREATE PROCEDURE UpdateStudent(
    IN p_student_id INT,
    IN p_first_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_dob DATE,
    IN p_gender VARCHAR(10),
    IN p_address VARCHAR(255)
)
BEGIN
    UPDATE students
    SET first_name = p_first_name,
        last_name = p_last_name,
        email = p_email,
        date_of_birth = p_dob,
        gender = p_gender,
        address = p_address
    WHERE student_id = p_student_id;
END$$

DELIMITER ;


CALL UpdateStudent(1, 'John', 'Doe', 'john.doe@example.com', '2000-05-15', 'Male', '789 Oak St');



DELIMITER $$

CREATE PROCEDURE DeleteStudent(
    IN p_student_id INT
)
BEGIN
    DELETE FROM students
    WHERE student_id = p_student_id;
END$$

DELIMITER ;
CALL DeleteStudent(1);


DELIMITER $$

CREATE PROCEDURE GetAllStudents()
BEGIN
    SELECT * FROM students;
END$$

DELIMITER ;

CALL GetAllStudents();

DELIMITER $$

CREATE PROCEDURE CountStudentsInCourse(
    IN p_course_id INT
)
BEGIN
    SELECT COUNT(student_id) AS student_count
    FROM enrollments
    WHERE course_id = p_course_id;
END$$

DELIMITER ;


CALL CountStudentsInCourse(2);