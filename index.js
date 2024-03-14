// Project include postgreSQL, queries, EJS, routes, body-parser.
/*Instructions-
- modify to add the multi user functionality.
-  fetch the data (country_code and color) for the selected user in the tab up top from postgres.
- link the user to the visited_countries table. the users table should contain user names and their colors for the map.

(hints: change te queries to JOIN certain tables, figure out how to query for the current user's data, add code under "/user", "/new" and "/add",
try using the RETURNING keyword to return the data that was inserted, and use the data to render the map and the user tabs).
*/

// One-to-one Relationships - using forgein keys and inner joins in one to one relationships.

import express from "express";
import bodyParser from "body-parser";
import pg from "pg";
import dotenv from 'dotenv';


const app = express();
const port = process.env.PORT || 3000; // Use the PORT provided by the environment or default to 3000

dotenv.config();

const db = new pg.Client({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: String(process.env.DB_PASSWORD), // Convert to string
  port: process.env.DB_PORT,
});
db.connect();

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static("public"));

let currentUserId = 1;  //by defult currentUserId is 1 (the first user from users table)

let users = [
  { id: 1, name: "Shani", color: "teal" },
  { id: 2, name: "Jack", color: "powderblue" },
];


//  fetches the countries visited by the current user, return the country codes. 
/* result return :
"country_code"
"FR"
"IL"
"TZ"
"TZ"
"AF"
 */
async function checkVisisted() {
  const result = await db.query(
    "SELECT country_code FROM visited_countries JOIN users ON users.id = user_id WHERE user_id = $1; ",
    [currentUserId]
  );

  let countries = [];
  result.rows.forEach((country) => {
    countries.push(country.country_code);
  });
  return countries;
}

// each user has id/name/color.

async function getCurrentUser() {
  const result = await db.query("SELECT * FROM users");
  console.log("result", result);
  users = result.rows;
  console.log("users", users);
  return users.find((user) => user.id == currentUserId); // == and not === because sometimes we compare string with number
  // console.log (typeof currentUserId);  
  // console.log (typeof user.id);
}

app.get("/", async (req, res) => {
  const countries = await checkVisisted();
  const currentUser = await getCurrentUser();
   
  res.render("index.ejs", {
    countries: countries,
    total: countries.length,
    users: users,
    color: currentUser.color,
  });
});


// get the countryCode from user input, then insert it into the visited_countries table.
app.post("/add", async (req, res) => {
  const input = req.body["country"];
  const currentUser = await getCurrentUser();

  try {
    const result = await db.query(
      "SELECT country_code FROM countries WHERE LOWER(country_name) LIKE '%' || $1 || '%';",
      [input.toLowerCase()]
    );

    const data = result.rows[0];
    const countryCode = data.country_code;
    try {
      await db.query(
        "INSERT INTO visited_countries (country_code, user_id) VALUES ($1, $2)",
        [countryCode, currentUserId]
      );
      res.redirect("/");
    } catch (err) {
      console.log(err);
    }
  } catch (err) {
    console.log(err);
  }
});



// get the user id that got clicked from the form, then render the index.ejs page.
app.post("/user", async (req, res) => {
  if (req.body.add === "new") {
    res.render("new.ejs");
  } else {
    currentUserId = req.body.user; // get the user id from the form
    res.redirect("/");
  }
});


  //Hint: The RETURNING keyword can return the data that was inserted.
  //https://www.postgresql.org/docs/current/dml-returning.html
app.post("/new", async (req, res) => {
  const name = req.body.name;
  const color = req.body.color;

  const result = await db.query(
    "INSERT INTO users (name, color) VALUES($1, $2) RETURNING *;",
    [name, color]
  );

  const id = result.rows[0].id;
  currentUserId = id;

  res.redirect("/");
});



app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
