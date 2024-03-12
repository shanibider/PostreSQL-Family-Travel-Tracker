-- Family Travel Tracker Queries AND SETUP --

DROP TABLE IF EXISTS visited_countries, users;

CREATE TABLE users(
id SERIAL PRIMARY KEY,
name VARCHAR(15) UNIQUE NOT NULL,
color VARCHAR(15)
);

/* one to many relation -
by creating a foreign key that points to the primary key of the other table.
(REFERENCES - set user_id to foreign key)
*/
CREATE TABLE visited_countries(
id SERIAL PRIMARY KEY,
country_code CHAR(2) NOT NULL,
user_id INTEGER REFERENCES users(id)
);

/*
vs previous version:
CREATE TABLE visited_countries(
  id SERIAL PRIMARY KEY,
  country_code CHAR (2)
);
*/

INSERT INTO users (name, color)
VALUES ('Shani', 'teal'), ('Jack', 'powderblue');

INSERT INTO visited_countries (country_code, user_id)
VALUES ('FR', 1), ('GB', 1), ('CA', 2), ('FR', 2 );

SELECT *
FROM visited_countries
JOIN users
ON users.id = user_id;

/*
"id"	"country_code"	"user_id"	"id"	"name"	"color"
1	"FR"	1	1	"Shani"	"teal"
2	"IL"	1	1	"Shani"	"teal"
3	"CA"	2	2	"Jack"	"powderblue"
4	"FR"	2	2	"Jack"	"powderblue"
*/



/*
"FR"
"DE"
"GR"
"IL"
"IT"
"NL"
"US"
"SZ"
"AT"
"BG"
*/
