"use strict";

var _ = window._,
  Backbone = window.Backbone,
  WordView = require('./Word');

module.exports = Backbone.View.extend({

  className: 'available-words well',

  initialize: function () {
    // maintain a collection of subviews so that we can remove them in our remove method
    this.wordViews = this.collection.map(function (m) {
      return new WordView({model: m});
    }, this);

    // new word generated from input
    this.listenTo(this.collection, 'add', function (m) {
      m.save();
      // create and append a new WordView
      var v = new WordView({model: m});
      this.wordViews.push(v);
      if (this.collection.length === 1) {
        this.$('.new').remove();
      }
      this.$el.append(v.render().el);
    });

  },

  render: function () {
    if (!this.collection.length) {
      this.addNewText();
    }

    _.each(this.wordViews, function (v) {
      this.$el.append(v.render().el);
    }, this);

    // memory leak; $.sortable seems to prevent this view from being GC'd regardless of options
    this.$el.sortable({
      update: _.bind(function () {
        if (!this.collection.length) {
          this.$('.new').remove();
        }
        // each time an update event is triggered in response to a sort or a word being dragged in or out,
        // destroy all words in the collection and create new ones
        _.each(this.collection.pluck('id'), function (id) {
          this.collection.get(id).destroy();
        }, this);
        _.each(this.$('.word'), function (el) {
          this.collection.create({
            label: el.innerText
          }, { silent: true });
        }, this);

        if (!this.$('.word').length) {
          this.addNewText();
        }
      }, this),
      connectWith: '.phrase'
    });
    return this;
  },

  remove: function () {
    _.each(this.wordViews, function (v) {
      v.remove();
    }, this);
    // the jquery-ui destroy method doesn't seem to work;
    // this view will not be GC'd (according to the Backbone Chrome dev tool extension)
    this.$el.sortable('destroy');
    Backbone.View.prototype.remove.apply(this, arguments);
  },

  addNewText: function () {
    this.$el.prepend('<span class="new">No available words. Create one above or drag words here.</span>');
  }

});
