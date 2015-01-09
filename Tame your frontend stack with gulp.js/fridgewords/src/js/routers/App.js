"use strict";

var _ = window._,
  Backbone = window.Backbone,
  GameView = require('../views/Game'),
  SettingsView = require('../views/Settings'),
  AvailableWordsCollection = require('../collections/AvailableWords'),
  PhrasesCollection = require('../collections/Phrases');

module.exports = Backbone.Router.extend({

  initialize: function (options) {
    _.extend(this, _.pick(options, 'layout'));
  },

  routes: {
    "": "game",
    "settings": "settings"
  },

  game: function () {
    var availableWordsCollection = new AvailableWordsCollection(),
      phrasesCollection = new PhrasesCollection();

    // return the Promise for testing
    return Backbone.$.when([availableWordsCollection.fetch(), phrasesCollection.fetch()]).then(_.bind(function () {

      this.layout.setView(new GameView({
        available: availableWordsCollection,
        phrases: phrasesCollection
      }), { linkTo: GameView.linkTo });

    }, this));

  },

  settings: function () {
    this.layout.setView(new SettingsView(), { linkTo: SettingsView.linkTo });
  }

});
