describe('models/Phrase', function () {
  "use strict";

  var expect = require('chai').expect,
    PhraseModel = require('../../../models/Phrase'),
    phraseModel;

  beforeEach(function () {
    phraseModel = new PhraseModel();
  });

  // the following two tests are lame and are not meant to be examples of stuff
  // you should spend time making tests for; simply examples of how to write tests
  // with mocha/chai.expect

  it('should set sub collection data on parse', function () {
    phraseModel.parse({words: [{label: 'there'}, {label: 'are'}, {label: 'four'}, {label:'lights'}]});
    expect(phraseModel.words.length).to.equal(4);
  });

  it('should stringify correctly', function () {
    phraseModel.words.reset([{label: 'there'}, {label: 'are'}, {label: 'four'}, {label:'lights'}]);
    expect(JSON.stringify(phraseModel)).to.equal('{"words":[{"label":"there"},{"label":"are"},{"label":"four"},{"label":"lights"}]}');
  });

});
