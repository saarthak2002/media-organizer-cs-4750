require('dotenv').config()

const express = require("express");
const routes = require("./routes")

const app = express();
const cors = require('cors');

app.use(cors({
    origin: process.env.MEDIA_APP_ALLOWED_ORIGIN,
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    credentials: true
}));
app.use(express.json());
app.use("/api", routes)

const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log("Server Listening on PORT:", PORT)
});

app.get("/", (req, res) => {
    res.send('App works');
})
