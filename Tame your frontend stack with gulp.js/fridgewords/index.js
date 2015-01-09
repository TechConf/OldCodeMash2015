"use strict";

var express = require('express'),
  // express 4.x packages serve-static as an independent package
  serveStatic = require('serve-static'),
  // use handlebars for our view templates for consistency
  hbs = require('express-hbs'),
  app = express();

app.engine('hbs', hbs.express3());
app.set('views', __dirname + '/server/views');
app.set('view engine', 'hbs');

// serve static assets like js and css files from the public directory
app.use(serveStatic(__dirname + '/public'));

// if $NODE_ENV=development, inject the live-reload js snippet tag
if (process.env.NODE_ENV === 'development') {
  app.use(require('connect-livereload')());
}

// we only have one server-side route; always serve up the server/views/app.hbs template
app.get('/*', function (req, res, next) {
  // server/views/app.hbs will have an isDev variable
  res.render('app', {
    isDev: process.env.NODE_ENV === 'development'
  });
});

app.listen(3000, 'localhost', function () {
  console.log('Listening at http://localhost:3000');
});
