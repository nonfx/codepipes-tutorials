import express from 'express';
import bodyParser from 'body-parser';
import ejs from 'ejs';
import { createClient } from 'redis';
import http from 'http';

const app = express();
const port = process.env.PORT || 3000;

app.use(bodyParser.urlencoded({ extended: true }));
app.use(express.static('public'));

app.set('view engine', 'ejs');

function appendIfVal(val: string|undefined, prefix: string, suffix: string): string {
  if(!val) return '';
  return `${prefix}${val}${suffix}`
}

let redisHost = process.env.REDIS_HOST || 'localhost'
let redisPort = process.env.REDIS_PORT || 6379
let redisPass = appendIfVal(encodeURIComponent(process.env.REDIS_PASSWORD||''), ':', '')
let redisUser = process.env.REDIS_USER || ''
let redisAuth = appendIfVal(redisUser+redisPass, '', '@')
let redisDatabase = appendIfVal(process.env.REDIS_DATABASE, '/', '')

const redisClient = createClient({
  url: `redis://${redisAuth}${redisHost}:${redisPort}${redisDatabase}`
});

// Retry connection if Redis is down
redisClient.on('error', (error) => {
  console.debug(`Error connecting to Redis: ${error}`);
});

const retryInterval = 5000; // 5 seconds
let retryTimeout: NodeJS.Timeout | undefined;

function connectRedis() {
  redisClient.connect();
  redisClient.on('ready', () => {
    console.log('Connected to Redis');
    clearIntervalRetryTimeout();
  });

  redisClient.on('end', () => {
    console.log('Disconnected from Redis');
    setRetryTimeout();
  });
}

function setRetryTimeout() {
  retryTimeout = setTimeout(connectRedis, retryInterval);
}

function clearIntervalRetryTimeout() {
  if (retryTimeout) {
    clearInterval(retryTimeout);
    retryTimeout = undefined;
  }
}

setTimeout(connectRedis, 0);

app.get('/', async (req, res) => {
  let redisUp = redisClient.isReady
  let hitCounter = 0;
  if(redisUp) {
    hitCounter = await redisClient.incr('hitCounter');
  }

  const html = await ejs.renderFile('views/index.ejs', {
    hitCounter,
    redisUp,
    NODE_ENV: (process.env.NODE_ENV||'development')
  });
  res.send(html);
});

// Handle shutdown gracefully
async function shutdown() {
  console.log('Closing Redis connection and shutting down server');
  await redisClient.quit()
  console.log('Redis connection closed');
}

process.on('SIGTERM', shutdown);
process.on('SIGINT', shutdown);

const server = http.createServer(app);
server.listen(port, () => {
  console.log(`Server running on http://localhost:${port}/`);
});
