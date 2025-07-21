const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from api-gateway-service');
});

app.listen(port, () => {
  console.log(`Api-gateway-service listening at http://localhost:${port}`);
});