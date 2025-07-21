const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from business-logic-service');
});

app.listen(port, () => {
  console.log(`Business-logic-service listening at http://localhost:${port}`);
});