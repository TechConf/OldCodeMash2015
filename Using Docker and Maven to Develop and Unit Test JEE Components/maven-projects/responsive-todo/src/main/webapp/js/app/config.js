/**
 * RequireJS configuration
 * 
 * Specifies where all our script files are and loads them
 * 
 * @param {type} param
 */
requirejs.config({
    baseUrl: "js/lib",
    paths: {
        app: "../app",
        jquery: "foundation/js/vendor/jquery",
        jqueryui: "jquery-ui-1.11.0.custom", 
        moment: "moment/moment", 
        momenttimezone: "moment-timezone/moment-timezone", 
        jqplugins: "jquery/plugins",
        log4javascript: "log4javascript/log4javascript",
        toastr: "toastr/toastr.min",
        tablesaw: "tablesaw/tablesaw",
        knockout: "knockout/knockout-min", 
        modernizr: "foundation/js/vendor/modernizr", 
        foundation: "foundation/js/foundation.min"
    }
});

/**
 * jquery, log4javascript and tablesaw aren't modules per se so the "normal"
 * require() mechanism doesn't work. Treat them as global scripts and simply
 * load them here. This prevents having to specify all the &lt;script&gt; tags
 * in the HTML and allows us to configure our application in one spot.
 */
requirejs(["jquery", "moment", "momenttimezone", "log4javascript", "tablesaw", "toastr", "modernizr", "foundation", "app/main"]);

