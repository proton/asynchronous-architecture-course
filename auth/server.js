const express = require('express')
const app = express()

const path = require('path')

const mongoose = require('mongoose')
mongoose.connect('mongodb://localhost:27017/popug_auth', { useNewUrlParser: true, useUnifiedTopology: true })

const userSchema = new mongoose.Schema({
  login: String,
  password: String,
  role: String
})

const User = mongoose.model('User', userSchema)

const db = mongoose.connection
db.on('error', console.error.bind(console, 'connection error:'))
db.once('open', function () {
  console.log('connected to db')
})

// const admin = new User({ login: 'admin', password: 'password', role: 'admin' })
// admin.save((err, _user) => {
//   if (err) return console.error(err)
// })

app.listen(3001, _ => {
  console.log('listening on 3001')
})

app.get('/users', (_req, res) => {
  res.sendFile(path.join(__dirname + '/users.html'))
})

app.get('/users.json', (_req, res) => {
  User.find({}, (err, users) => {
    if (err) return console.error(err)
    res.send(users.map(user => ({ id: user.id, login: user.login, role: user.role })))
  })
})

app.delete('/users/:userId.json', (req, res) => {
  const userId = req.params.userId

  User.findByIdAndDelete(userId, err => {
    if (err) return console.error(err)
    res.send('ok')
  })
})
