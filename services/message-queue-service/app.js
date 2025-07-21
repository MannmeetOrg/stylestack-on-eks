const express = require('express');
const app = express();
const port = 8080;

app.get('/', (req, res) => {
  res.send('Hello from message-queue-service');
});

app.listen(port, () => {
  console.log(`Message-queue-service listening at http://localhost:${port}`);
});