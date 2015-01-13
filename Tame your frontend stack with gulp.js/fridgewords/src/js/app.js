"use strict";

// our modules always declare their dependencies, even if they are syncronously-loaded,
// global window variables;
// it should be easier to switch to the future silver bullet solution to frontend dependency
// management, whatever and whenever that is :)

var $ = window.jQuery,
  Backbone = window.Backbone,
  // load depedencies in the CommonJS style; Browserify will pull these modules into the build
  LayoutView = require('./views/Layout'),
  AppRouter = require('./routers/App');

$(function () {
  var layoutView = new LayoutView(),
    router = new AppRouter({
      layout: layoutView
    });

  $('body').append(layoutView.render().el);

  if (!Backbone.history.start({pushState: true})) {
    router.navigate("", {trigger: true});
  }
});
