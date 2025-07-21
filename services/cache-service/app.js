const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from cache-service');
});

app.listen(port, () => {
  console.log(`Cache-service listening at http://localhost:${port}`);
});