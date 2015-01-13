"use strict";

var _ = window._,
  Backbone = window.Backbone,
  template = require('../../templates/game/word');

module.exports = Backbone.View.extend({

  className: 'word',

  initialize: function (options) {
    _.extend(this, _.pick(options, 'color'));
  },

  colors: [
    'rgb(174, 195, 157)', // washed out blue green
    'rgb(136, 187, 141)', // green
    '#8dc1bc', // blue
    'rgb(213, 198, 119)', // yellowish
    'rgb(186, 131, 121)', // brownish red
    'rgb(221, 183, 129)'  // gold yellow
  ],

  render: function () {
    this.$el.html(template(this.model.toJSON()));
    this.$el.css('background-color', this.color || this.colors[Math.floor(Math.random() * this.colors.length)]);
    return this;
  }

});
