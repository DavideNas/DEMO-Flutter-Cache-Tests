const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());

app.get("/api/data", (req, res) => {
  const data = [
    {
      name: "Pikachu",
      marks: 100,
    },
    {
      name: "Charizard",
      marks: 95,
    },
    {
      name: "Pidgeotto",
      marks: 85,
    },
    {
      name: "Greninja",
      marks: 70,
    },
    {
      name: "Glaceon",
      marks: 75,
    },
  ];
  res.json(data);
});

const PORT = 8000;
const HOST = '0.0.0.0';
app.listen(PORT, HOST, () => {
  console.log("Server started ! Listening on port " + PORT);
});
