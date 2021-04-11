const express = require('express')
const app = express()
app.use(express.json())

const cookieParser = require('cookie-parser')
app.use(cookieParser())

const fs = require('fs')

const privateKey = fs.readFileSync('auth_private.key')
const publicKey = fs.readFileSync('auth_public.key')

const jwt = require('jsonwebtoken')

const path = require('path')

const mongoose = require('mongoose')
mongoose.connect(`mongodb://${process.env.DB_URL}/popug_auth`, { useNewUrlParser: true, useUnifiedTopology: true })

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

app.listen(process.env.PORT, _ => {
  console.log(`listening on ${process.env.PORT}`)
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

app.get('/users/:userId.json', (req, res) => {
  // TODO: check token
  const userId = req.params.userId
  User.findById(userId, (err, doc) => {
    if (err) return console.error(err)
    res.send(doc)
  })
})

app.post('/users.json', (req, res) => {
  const user = new User(req.body)
  user.save((err, _user) => {
    if (err) return console.error(err)
    res.send('ok')
  })
})

app.delete('/users/:userId.json', (req, res) => {
  const userId = req.params.userId

  User.findByIdAndDelete(userId, err => {
    if (err) return console.error(err)
    res.send('ok')
  })
})

app.get('/sign_in', (req, res) => {
  if (req.query.redirect_to) {
    res.cookie('redirect_to', req.query.redirect_to)
  }
  res.sendFile(path.join(__dirname + '/sign_in.html'))
})

const generateToken = user => {
  const payload = { login: user.login, role: user.role, id: user.id }
  const token = jwt.sign(payload, privateKey, { algorithm: 'RS256' })
  return token
}

app.post('/sign_in', (req, res) => {
  User.where({ login: req.body.login, password: req.body.password }).findOne(function (err, user) {
    if (err) return console.error(err)
    if (user) {
      res.send({ signedIn: true, token: generateToken(user) })
    } else {
      res.send({ signedIn: false, error: 'Invalid password' })
    }
  })
})

app.get('/public_key.json', (_req, res) => {
  res.send({ key: publicKey.toString() })
})
