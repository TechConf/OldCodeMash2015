"use strict";

var Backbone = window.Backbone,
  template = require('../../templates/game/add-word');

module.exports = Backbone.View.extend({

  tagName: 'form',

  className: 'add-word',

  events: {
    'submit': function (e) {
      e.preventDefault();
      this.collection.add({label: this.$('input').val().trim()});
      this.$('input').val('');
    }
  },

  render: function () {
    this.$el.html(template());
    return this;
  }

});
