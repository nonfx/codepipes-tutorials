const express = require('express');
const ejs = require('ejs');

const app = express();
const port = process.env.PORT || 3000;

app.set('view engine', 'ejs');

let hitCounter = 0;
app.get('/', async (req, res) => {
  const html = await ejs.renderFile('views/index.ejs', {
    hitCounter: ++hitCounter,
    NODE_ENV: (process.env.NODE_ENV||'development')
  });
  res.send(html);
});

let server = app.listen(port, () => {
  console.log(`App running at http://localhost:${port}`);
});

module.exports = {app, server};