"use strict";

var Backbone = window.Backbone,
  template = require('../templates/layout');

module.exports = Backbone.View.extend({

  className: 'layout',

  events: {
    'click .link-to a': function (e) {
      e.preventDefault();
      Backbone.history.navigate(this.$(e.target).data('link-to'), {trigger: true});
    }
  },

  setView: function (view, options) {
    if (this._view) {
      this._view.remove();
    }
    this._view = view;
    this.$('.outlet').html(view.render().el);
    if (options.linkTo) {
      this.$('.link-to').html('<a class="btn btn-default" href="#" data-link-to="' + options.linkTo.href + '">' + options.linkTo.text + '</a>');
    }
  },

  render: function () {
    this.$el.html(template());
    return this;
  }

});
