const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from frontend-service');
});

app.listen(port, () => {
  console.log(`Frontend-service listening at http://localhost:${port}`);
});