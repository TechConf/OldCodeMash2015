"use strict";

var _ = window._,
  Backbone = window.Backbone;

module.exports = Backbone.Model.extend({

  constructor: function () {

    // standard pattern for nesting a collection within a model;
    // see parse() and toJSON() below as well as http://backbonejs.org/#Model-constructor
    this.words = new Backbone.Collection();

    Backbone.Model.apply(this, arguments);

  },

  initialize: function () {
    // each phrase should notify it's containing Phrases collection when it has gone from
    // 0 to 1 words
    this.words.on('add', function (word) {
      if (this.words.length === 1) {
        this.collection.trigger('new', this, word);
      }
    }, this);
  },

  parse: function (data, options) {
    this.words.set(data.words, options);
    return _.omit(data, 'words');
  },

  toJSON: function () {
    return _.extend(Backbone.Model.prototype.toJSON.apply(this, arguments), {
      words: this.words.toJSON()
    });
  }

});
