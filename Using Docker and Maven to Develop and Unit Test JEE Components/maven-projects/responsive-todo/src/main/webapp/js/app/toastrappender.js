/**
 * @namespace ToastrAppender
 * @requires log4javascript
 * @author Don Taylor
 */
define(["toastr"], function(toastr) {

    /**
     * Create new ToastrAppender to send log messages to toast
     * @class ToastrAppender
     * @returns {_L1.ToastrAppender}
     */
    function ToastrAppender() {
    }

    ToastrAppender.prototype = new log4javascript.Appender();
    ToastrAppender.prototype.layout = new log4javascript.NullLayout();
    ToastrAppender.prototype.threshold = log4javascript.Level.DEBUG;

    toastr.options = {
        "closeButton": true,
        "debug": false,
        "positionClass": "toast-bottom-full-width",
        "showDuration": "300",
        "hideDuration": "1000",
        "timeOut": "3000",
        "extendedTimeOut": "1000",
        "showEasing": "swing",
        "hideEasing": "linear",
        "showMethod": "slideDown",
        "hideMethod": "slideUp"
    };

    /**
     * Creates the toast having specified content
     * @param {String} loggingEvent
     * @returns {void}
     */
    ToastrAppender.prototype.append = function(loggingEvent) {
        var appender = this;
        var formattedMessage = appender.getLayout().formatWithException(loggingEvent);

        if (log4javascript.Level.DEBUG.isGreaterOrEqual(loggingEvent.level)) {
            toastr.success(formattedMessage);
        } else if (log4javascript.Level.INFO.isGreaterOrEqual(loggingEvent.level)) {
            toastr.info(formattedMessage);
        } else if (log4javascript.Level.WARN.isGreaterOrEqual(loggingEvent.level)) {
            toastr.warning(formattedMessage);
        } else if (log4javascript.Level.ERROR.isGreaterOrEqual(loggingEvent.level)) {
            toastr.error(formattedMessage);
        } else {
            log4javascript.handleError("Log level expected to be {DEBUG, INFO, WARN, ERROR}");
        }
    };

    ToastrAppender.prototype.toString = function() {
        return "ToastrAppender";
    };

    log4javascript.ToastrAppender = ToastrAppender;
});

