process.once('SIGTERM', () => process.exit(0));
process.once('SIGINT', () => process.exit(0));

const https = require('https');
const fs = require('fs');
const express = require('express');
const app = express();
const { exec } = require("child_process");

app.get('/', (req, res) =>{
  res.setHeader('Content-Type', 'text/html');
  res.status(200).send(`<!DOCTYPE html>
  <html lang="en">
  <head>
  <style>
     html,body{margin:0; padding:0;}
     .center{
        height:100vh;
        width:100vw;
        display: flex;
        flex-direction: row;
        justify-content: center;
        align-items: center;
     }
  </style>
  </head>
  <body>
     <div class="center">
        <button onclick="window.location.href='/cmd/reboot';">
          reboot
        </button>
        <button onclick="window.location.href='/cmd/poweroff';">
          poweroff
        </button>
     </div>
  </body>
  </html>`);
});

app.get('/cmd/:command', (req, res) =>{
  exec(`ssh -o "StrictHostKeyChecking=no" root@${process.env.HOST_IP} ${req.params.command || date};`, (err, stdout, stderr) => {
    res.status(200).send(stdout || stderr || err.message);
  });
});

const server = https.createServer({
  key:fs.readFileSync(`/api/ssl/key.pem`, `utf8`),
  cert:fs.readFileSync(`/api/ssl/cert.pem`, `utf8`)
}, app);

server.on('error', (e) => {
  console.error('Fatal exception on HTTPS server', e);
});

server.listen(8443);