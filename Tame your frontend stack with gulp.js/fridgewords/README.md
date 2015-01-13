fridgewords
===========
A project created for [CodeMash 2015](http://www.codemash.org/) to demostrate frontend organization with gulp.js.

Concepts illustrated include
* using CommonJS modules for frontend code
* automatically including Bower assets, loaded in dependency order
* conditionally minifying js assets based on environment
* integrating Bootstrap
* automatic builds and livereload

The slides used to describe the concepts above are in [this repo](https://github.com/bengladwell/codemash2015).

Install and run
------------
If you don't have bower and gulp installed globally, install those:
```bash
npm install -g bower
npm install -g gulp
```

Install dependencies
```bash
npm install
bower install
```

Compile assets
```bash
NODE_ENV=development gulp
```

Run the node server
```bash
NODE_ENV=development node index.js
```


Both `gulp` and `node index.js` respect the NODE_ENV environment variable. Setting it to development will produce unminified assets and source maps.

Optional - in a separate shell, run gulp watch for livereload
```bash
NODE_ENV=development gulp watch
```
