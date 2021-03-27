const express = require('express')
const app = express()

const mongoose = require('mongoose')
mongoose.connect('mongodb://localhost:27017/popug_auth', { useNewUrlParser: true, useUnifiedTopology: true })

const db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))
db.once('open', function () {
  console.log('connected to db')
})

app.listen(3001, _ => {
  console.log('listening on 3001')
})

app.get('/', (_req, res) => {
  res.send('Hello World')
})
