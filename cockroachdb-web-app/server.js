const express = require("express");
const {Client} = require("pg");
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


// Fetch table data
app.get("/table/:tableName", async (req, res) => {
    const tableName = req.params.tableName;

    try {
        const result = await client.query(`SELECT *
                                           FROM ${tableName}`);
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
});

// Fetch table schema
app.get("/tableSchema/:tableName", async (req, res) => {
    const tableName = req.params.tableName;

    try {
        const result = await client.query(
            `SELECT column_name
             FROM information_schema.columns
             WHERE table_name = $1`,
            [tableName]
        );
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({error: err.message});
    }
});

// Add data to a table
app.post("/addData/:tableName", async (req, res) => {
    const tableName = req.params.tableName;
    const data = req.body;

    try {
        const columns = Object.keys(data).join(", ");
        const values = Object.values(data)
            .map((value) => `'${value}'`)
            .join(", ");
        const query = `INSERT INTO ${tableName} (${columns})
                       VALUES (${values})`;

        console.log("Executing query:", query); // Log the query for debugging

        await client.query(query);
        res.sendStatus(200);
    } catch (err) {
        console.error("Error executing query:", err); // Log the full error
        res.status(500).json({error: err.message});
    }
});

app.post("/signup", async (req, res) => {
    const {username, phoneNumber, firstName, lastName, dob} = req.body;

    try {
        // Insert into Users and Human_user tables
        const query = `
            WITH new_user AS (
            INSERT
            INTO Users (user_id, username, bio)
            VALUES (gen_random_uuid(), $1, '')
            ON CONFLICT (username) DO NOTHING
                RETURNING user_id
                )
            INSERT
            INTO Human_user (user_id, phone_number, first_name, last_name, dob)
            SELECT user_id, $2, $3, $4, $5
            FROM new_user
            UNION ALL
            SELECT user_id, $2, $3, $4, $5
            FROM Users
            WHERE username = $1 LIMIT 1;
        `;

        const result = await client.query(query, [username, phoneNumber, firstName, lastName, dob]);

        if (result.rowCount > 0) {
            res.json({message: "Signup successful!"});
        } else {
            res.status(400).json({error: "Username already exists."});
        }
    } catch (err) {
        console.error("Error during signup:", err);
        res.status(500).json({error: "An error occurred during signup."});
    }
});


app.get('/conversations', async (req, res) => {
    const userId = req.query.user_id;
    const query = `
        SELECT c.conv_id, pc.title
        FROM User_Conversations uc
                 JOIN Conversation c ON uc.conv_id = c.conv_id
                 LEFT JOIN Public_Conversation pc ON c.conv_id = pc.conv_id
        WHERE uc.user_id = $1;
    `;
    const result = await client.query(query, [userId]);
    res.json(result.rows);
});

app.post('/createConversation', async (req, res) => {
    const {user_id, title} = req.body;

    const query = `
        WITH new_conversation AS (
        INSERT
        INTO Conversation (conv_id)
        VALUES (gen_random_uuid())
            RETURNING conv_id
            ), new_public_conversation AS (
        INSERT
        INTO Public_Conversation (conv_id, owner_user_id, title)
        SELECT conv_id, $1, $2
        FROM new_conversation
            RETURNING conv_id
            )
        INSERT
        INTO User_Conversations (conv_id, user_id)
        SELECT conv_id, $1
        FROM new_public_conversation;
    `;

    await client.query(query, [user_id, title]);
    res.sendStatus(200);
});

app.get('/messages', async (req, res) => {
    const convId = req.query.conv_id;
    const query = `
        SELECT m.message_id, m.sender_user_id, m.message_type, nm.text, pm.question
        FROM Message m
                 LEFT JOIN Normal_Message nm ON m.message_id = nm.message_id
                 LEFT JOIN Poll_Message pm ON m.message_id = pm.message_id
        WHERE m.conv_id = $1 ORDER BY m.send_time ASC;
    `;
    const result = await client.query(query, [convId]);
    res.json(result.rows);
});

app.post('/sendMessage', async (req, res) => {
    const {sender_id, conv_id, text} = req.body;
    const query = `
        WITH new_message AS (
        INSERT
        INTO Message (sender_user_id, conv_id, message_type)
        VALUES ($1, $2, 'normal')
            RETURNING message_id
            )
        INSERT
        INTO Normal_Message (message_id, text)
        SELECT message_id, $3
        FROM new_message;
    `;
    await client.query(query, [sender_id, conv_id, text]);
    res.sendStatus(200);
});

app.use(express.static("public"));


app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});