describe('routers/App', function () {
  "use strict";

  var expect = require('chai').expect,
    AppRouter = require('../../../routers/App'),
    LayoutView = require('../../../views/Layout'),
    GameView = require('../../../views/Game'),
    SettingsView = require('../../../views/Settings'),
    router;

  beforeEach(function () {
    router = new AppRouter({
      layout: new LayoutView()
    });
  });

  it('should load a GameView for the root route', function (cb) {
    // router.game() returns a promise
    router.game().then(function () {
      expect(router.layout._view).to.be.instanceOf(GameView);
      cb();
    });
  });

  it('should load a SettingsView for the settings route', function () {
    router.settings();
    expect(router.layout._view).to.be.instanceOf(SettingsView);
  });

});
