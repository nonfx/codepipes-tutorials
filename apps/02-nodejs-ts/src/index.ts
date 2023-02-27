import express from 'express';
import bodyParser from 'body-parser';
import ejs from 'ejs';
import http from 'http';

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

app.set('view engine', 'ejs');

let hitCounter = 0;
app.get('/', async (req, res) => {
  const html = await ejs.renderFile('views/index.ejs', {
    hitCounter: ++hitCounter,
    NODE_ENV: (process.env.NODE_ENV||'development')
  });
  res.send(html);
});

const server = http.createServer(app);
server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
});
