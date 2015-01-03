/**
 * Main application entry point. 
 * 
 * Application initialization performed here, and the global 
 * variable logger is defined here.
 * 
 * @param {type} require
 * @returns {undefined}
 */

define(function(require) {

    // Initialize logging
    /*** logger is GLOBAL ***/
    logger = log4javascript.getLogger();
    logger.addAppender((function() {
        require("app/toastrappender");
        var appender = new log4javascript.ToastrAppender();
        return appender;
    })());
    
    // Demonstation of using the log4javascript library to put growl messages 
    // on the screen, using the toastr framework.
    //logger.debug("log4javascript debug");
    //logger.info("log4javascript info");
    //logger.warn("log4javascript warn");
    //logger.error("log4javascript error");

    var viewmodel = require("app/viewmodel");
    viewmodel.start();
});

