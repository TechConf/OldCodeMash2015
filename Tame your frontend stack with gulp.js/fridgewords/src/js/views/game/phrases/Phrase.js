"use strict";

var _ = window._,
  Backbone = window.Backbone,
  WordView = require('../Word');

module.exports = Backbone.View.extend({

  className: 'phrase well',

  events: {
    'click .close': function (e) {
      e.preventDefault();
      this.model.destroy();
    }
  },

  views: [],

  render: function () {
    this.$el.append('<a href="#" class="close"><span class="pull-right glyphicon glyphicon-remove-circle"></span></a>');
    if (!this.model.words.length) {
      this.addNewText();
    }
    this.model.words.each(function (m) {
      var wordView = new WordView({model: m});
      this.views.push(wordView);
      this.$el.append(wordView.render().el);
    }, this);

    // memory leak; $.sortable seems to prevent this view from being GC'd regardless of options
    this.$el.sortable({
      connectWith: '.available-words,.phrase',
      update: _.bind(function () {
        if (!this.model.words.length) {
          this.$('.new').remove();
        }
        // each time an update event is triggered in response to a sort or a word being dragged in or out,
        // reset the words collection with the words in the view;
        // the words are saved as a property of this PhraseModel, so we don't need to destroy/save them individually
        this.model.words.reset(_.map(this.$('.word'), function (el) {
          return {
            label: el.innerText
          };
        }, this));
        this.model.save();
      }, this),
      remove: _.bind(function () {
        if (!this.model.words.length) {
          this.addNewText();
        }
      }, this)
    });

    return this;
  },

  addNewText: function () {
    this.$el.prepend('<span class="new">Drag words here to start a new phrase</span>');
  },

  remove: function () {
    _.each(this.views, function (view) {
      view.remove();
    }, this);
    // the jquery-ui destroy method doesn't seem to work;
    // this view will not be GC'd (according to the Backbone Chrome dev tool extension)
    this.$el.sortable('destroy');
    Backbone.View.prototype.remove.apply(this, arguments);
  }

});
