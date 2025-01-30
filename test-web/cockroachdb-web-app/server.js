const express = require("express");
const { Client } = require("pg");
const cors = require("cors"); 
const app = express();
const port = 3000;


app.use(
  cors({
    origin: "http://127.0.0.1:5500", 
    methods: ["GET", "POST"], // Allow POST requests
    allowedHeaders: ["Content-Type"], // Allow JSON content
  })
);

app.use(express.json());


const client = new Client({
  user: process.env.DB_USER || "mmdhossein",
  host: process.env.DB_HOST || "sour-spaniel-4371.jxf.gcp-europe-west1.cockroachlabs.cloud",
  database: process.env.DB_NAME || "telegram",
  password: process.env.DB_PASSWORD || "mbmwWrhtDTFFRkltuUFCSQ",
  port: process.env.DB_PORT || 26257,
  ssl: {
    rejectUnauthorized: false,
  },
});


client
  .connect()
  .then(() => console.log("Connected to CockroachDB"))
  .catch((err) => console.error("Connection error", err));


app.use(express.static("public"));


app.get("/table/:tableName", async (req, res) => {
  const tableName = req.params.tableName;

  try {
    const result = await client.query(`SELECT * FROM ${tableName}`);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.post("/signup", async (req, res) => {
  const { username, phoneNumber, firstName, lastName, dob } = req.body;

  try {
    // Insert into Users and Human_user tables
    const query = `
            WITH new_user AS (
                INSERT INTO Users (user_id, username, bio)
                VALUES (gen_random_uuid(), $1, '')
                ON CONFLICT (username) DO NOTHING
                RETURNING user_id
            )
            INSERT INTO Human_user (user_id, phone_number, first_name, last_name, dob)
            SELECT user_id, $2, $3, $4, $5 FROM new_user
            UNION ALL
            SELECT user_id, $2, $3, $4, $5 FROM Users WHERE username = $1
            LIMIT 1;
        `;

    const result = await client.query(query, [username, phoneNumber, firstName, lastName, dob]);

    if (result.rowCount > 0) {
      res.json({ message: "Signup successful!" });
    } else {
      res.status(400).json({ error: "Username already exists." });
    }
  } catch (err) {
    console.error("Error during signup:", err);
    res.status(500).json({ error: "An error occurred during signup." });
  }
});
app.use(express.static("public"));


app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});