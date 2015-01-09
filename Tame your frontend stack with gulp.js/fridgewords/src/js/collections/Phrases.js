"use strict";

var Backbone = window.Backbone,
  PhraseModel = require('../models/Phrase');

module.exports = Backbone.Collection.extend({

  localStorage: new Backbone.LocalStorage('Phrases'),

  model: PhraseModel

});
