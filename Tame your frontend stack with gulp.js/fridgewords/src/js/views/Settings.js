"use strict";

var _ = window._,
  Backbone = window.Backbone,
  template = require('../templates/settings'),
  AvailableWordsCollection = require('../collections/AvailableWords'),
  View;

View = Backbone.View.extend({

  tagName: 'form',

  className: 'settings',

  events: {
    submit: function (e) {
      e.preventDefault();
      this.submit();
    }
  },

  render: function () {
    this.$el.html(template());
    return this;
  },

  submit: function () {
    var words = new AvailableWordsCollection(_.map(this.$('textarea').val().split(/\n/), function (token) {
      return { label: token.trim() };
    }));

    // return the promise for testing
    return Backbone.$.when(words.map(function (word) {
      word.save();
    })).then(function () {
      Backbone.history.navigate("", {trigger: true});
    });
  }

});

// "class" variables; other classes need only to require this class (but not instantiate it)
// to get access to these
View.linkTo = {
  href: "",
  text: "Game"
};

module.exports = View;
