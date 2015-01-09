describe('views/Game', function () {
  "use strict";

  var expect = require('chai').expect,
    sinon = require('sinon'),
    GameView = require('../../../views/Game'),
    AvailableWordsCollection = require('../../../collections/AvailableWords'),
    PhrasesCollection = require('../../../collections/Phrases'),
    gameView;

  beforeEach(function () {
    gameView = new GameView({
      available: new AvailableWordsCollection(),
      phrases: new PhrasesCollection()
    });
  });

  it('should append subviews on render', function () {
    expect(gameView.$el.children().length).to.equal(0);
    gameView.render();
    expect(gameView.$(gameView.addWordView.el).length).to.equal(1);
    expect(gameView.$(gameView.availableWordsView.el).length).to.equal(1);
    expect(gameView.$(gameView.phrasesView.el).length).to.equal(1);
  });

  it('should remove subviews on remove', function () {
    var s1 = sinon.spy(gameView.addWordView, 'remove'),
      s2 = sinon.spy(gameView.availableWordsView, 'remove'),
      s3 = sinon.spy(gameView.phrasesView, 'remove');

    gameView.render();
    expect(gameView.$el.children().length).to.equal(3);

    gameView.remove();
    expect(gameView.$el.children().length).to.equal(0);
    expect(s1.callCount).to.equal(1);
    expect(s2.callCount).to.equal(1);
    expect(s3.callCount).to.equal(1);

  });

});
