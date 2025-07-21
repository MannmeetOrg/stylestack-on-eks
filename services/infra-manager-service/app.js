const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from infra-manager-service');
});

app.listen(port, () => {
  console.log(`Infra-manager-service listening at http://localhost:${port}`);
});