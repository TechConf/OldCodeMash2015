describe('views/Settings', function () {
  "use strict";

  var expect = require('chai').expect,
    sinon = require('sinon'),
    Backbone = window.Backbone,
    SettingsView = require('../../../views/Settings'),
    settingsView;

  beforeEach(function () {
    settingsView = new SettingsView();
  });

  it('should navigate to / after form submit', function (cb) {
    var navigateSpy = sinon.spy(Backbone.history, 'navigate');

    settingsView.render().$('textarea').val('test');

    settingsView.submit().then(function () {
      expect(navigateSpy.alwaysCalledWithExactly("", {trigger: true})).to.equal(true);
      Backbone.history.navigate.restore();
      cb();
    });
  });

});
