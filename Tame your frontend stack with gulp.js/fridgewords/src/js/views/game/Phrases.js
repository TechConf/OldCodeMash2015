"use strict";

// contains one or more PhraseViews

var _ = window._,
  Backbone = window.Backbone,
  PhraseView = require('./phrases/Phrase');

module.exports = Backbone.View.extend({

  className: 'phrases',

  views: [],

  initialize: function () {
    // if the backing collection is empty, create an empty Phrase (model)
    if (!this.collection.length || this.collection.last().words.length) {
      this.collection.add({});
    }

    // when a phrase model is destroyed, find and remove the associated PhraseView
    this.listenTo(this.collection, 'destroy', function (phrase) {
      var v = _.findWhere(this.views, {model: phrase});
      if (v) {
        v.remove();
      }
    });

    // when a PhraseModel goes from 0 to 1 word, add an empty PhraseView;
    // see src/js/models/Phrase.js where the new event is triggered
    this.listenTo(this.collection, 'new', function () {
      if (this.collection.every(function (phrase) { return phrase.words.length; })) {
        var v = new PhraseView({
          model: this.collection.add({})
        });
        this.views.push(v);
        this.$el.append(v.render().el);
      }
    });
  },

  render: function () {
    this.collection.each(function (m) {

      var phraseView = new PhraseView({
        model: m
      });
      this.views.push(phraseView);
      this.$el.append(phraseView.render().el);
    }, this);

    return this;
  },

  remove: function () {
    _.each(this.views, function (view) {
      view.remove();
    }, this);
    Backbone.View.prototype.remove.apply(this, arguments);
  }

});
