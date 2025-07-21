const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from data-access-service');
});

app.listen(port, () => {
  console.log(`Data-access-service listening at http://localhost:${port}`);
});