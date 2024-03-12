/* Database Queries for my postgresql db (pgAdmin). I create new db named "School" for practice*/

CREATE TABLE student (
  id SERIAL PRIMARY KEY,
  first_name TEXT,
  last_name TEXT
);

/* one to one Relationships & Inner Joins - 
How to use foreign keys and inner joins in one to one relationship */
-- One to One --
CREATE TABLE contact_detail (
  id INTEGER REFERENCES student(id) UNIQUE,
  tel TEXT,
  address TEXT
);

-- Data --
INSERT INTO student (first_name, last_name)
VALUES ('Shani', 'Bider');
INSERT INTO contact_detail (id, tel, address)
VALUES (1, '+123456789', '123 Haprdes Road');


/* join 2 tables together based on cratiria "ON" (where student.id = contact_detail.id) */
-- Join --
SELECT * 
FROM student
JOIN contact_detail
ON student.id = contact_detail.id




/* each student make many homework submmission 
  student_id INTEGER REFERENCES student(id) - This is who to establish many to one connection. Using refrences key word to set up forgein key, then using "table name (field)".
  This means look for the student table, find field called id, and set this as a relation to student_id field.
  */
-- Many to One --
CREATE TABLE homework_submission (
  id SERIAL PRIMARY KEY,
  mark INTEGER,
  student_id INTEGER REFERENCES student(id)
);

-- Data --
INSERT INTO homework_submission (mark, student_id)
VALUES (98, 1), (87, 1), (88, 1)

/* select everything based on the cretiria*/
-- Join --
SELECT *
FROM student
JOIN homework_submission
ON student.id = homework_submission.student_id


/* narrow down the repeated columns */
SELECT student.id, first_name, last_name, mark
FROM student
JOIN homework_submission
ON student.id = student_id


/* Many to Many Relationships & Aliases */
/* many student to many classes */
-- Many to Many --
CREATE TABLE class (
  id SERIAL PRIMARY KEY,
  title VARCHAR(45)
);

CREATE TABLE enrollment (
  student_id INTEGER REFERENCES student(id),
  class_id INTEGER REFERENCES class(id),
  PRIMARY KEY (student_id, class_id)
);


-- Data --
INSERT INTO student (first_name, last_name)
VALUES ('Jack', 'Bauer');

INSERT INTO class (title)
VALUES ('English Literature'), ('Maths'), ('Physics');

INSERT INTO enrollment (student_id, class_id ) VALUES (1, 1), (1, 2);
INSERT INTO enrollment (student_id ,class_id) VALUES (2, 2), (2, 3);


-- Join --
SELECT *
FROM enrollment 
JOIN student ON student.id = enrollment.student_id
JOIN class ON class.id = enrollment.class_id;

SELECT student.id AS id, first_name, last_name, title
FROM enrollment 
JOIN student ON student.id = enrollment.student_id
JOIN class ON class.id = enrollment.class_id;


/* rename s.id field as id*/
-- ALIAS --
SELECT s.id AS id, first_name, last_name, title
FROM enrollment AS e
JOIN student AS s ON s.id = e.student_id
JOIN class AS c ON c.id = e.class_id;


/* shortcut for names. FROM enrollment e is equal to FROM enrollment AS e (as is optional) */
SELECT s.id AS id, first_name, last_name, title
FROM enrollment e
JOIN student s ON s.id = e.student_id
JOIN class c ON c.id = e.class_id;