const express = require("express");
const { Client } = require("pg");
const cors = require("cors"); 
const app = express();
const port = 3000;


app.use(
  cors({
    origin: "http://127.0.0.1:5500", 
    methods: "GET", 
  })
);


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

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});