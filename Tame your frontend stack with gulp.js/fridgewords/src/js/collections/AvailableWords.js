"use strict";

var Backbone = window.Backbone;

module.exports = Backbone.Collection.extend({

  localStorage: new Backbone.LocalStorage('Available')

});
