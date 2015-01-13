
define(["jquery", "moment", "momenttimezone", "knockout", "log4javascript", "toastr"], 
function($, moment, momenttimezone, ko, log4javascript, toastr) {
    //*************************************************************************
    //* Enumerated value, representing the Priority for a ToDo item.
    //*************************************************************************
    var ToDoPriority = {
        HIGH:   0, 
        MEDIUM: 1, 
        LOW:    2, 
        properties: { 
            0: { value: 0, name: "High" }, 
            1: { value: 1, name: "Medium" }, 
            2: { value: 2, name: "Low" }
        }
    };

    //*************************************************************************
    //* Object representation of a ToDo item.
    //*************************************************************************
    function ToDoItem(data) {
        // Numeric / integer value.
        this.taskId = data.taskId;
        
        // Boolean value.
        this.isDone = ko.observable(data.isDone);
        
        // String value, derived from enum ToDoPriority.
        this.priority = ko.observable(
                ToDoPriority.properties[data.priority].name);
        
        // String value.
        this.task = ko.observable(data.task);
        
        // String value, reprsenting a date [format:  yyyy-mm-dd].
        this.dueBy = ko.observable(data.dueBy);
    };

    //*************************************************************************
    //* Core processing method for Knockout.js, used to define binding of 
    //* HTML form and DIV elements to Javascript variables defined within the 
    //* view model.
    //*************************************************************************
    function AppViewModel() {
        var self = this;
        
        //*********************************************************************
        //* Observable array for list of ToDo items that will be retrieved 
        //* from the server back-end via an HTTP GET to REST resource 
        //* webresources/todo.
        //*********************************************************************
        self.items = ko.observableArray([]);

        //*********************************************************************
        //* Driver method, used to load ToDo items from the database, to be 
        //* bound to an HTML table on the main page.
        //*********************************************************************
        self.loadInitialData = function() {
            jQuery.ajax({
                type: "GET",
                url: "webresources/todo",
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function(data, status, jqXHR) {
                    self.items.removeAll();

                    data.forEach(function(entry) {
                        var x = new ToDoItem({
                            taskId: entry.taskid,
                            isDone: entry.done,
                            priority: entry.priority,
                            task: entry.task,
                            dueBy: entry.dueby});
                        self.items.push(x);
                    }
                    );
                },
                error: function(jqXHR, status) {
                    alert("Something bad happened - status=" + status + 
                            " - jqXHR = " + jqXHR);
                }
            });
        };

        //*********************************************************************
        //* Variables for storing bound values to creating new ToDo items.
        //*********************************************************************
        self.newIsDone = ko.observable(false);
        self.newPriority = ko.observable("0");
        self.newTask = ko.observable("");
        self.newDueBy = ko.observable("");
        
        //*********************************************************************
        //* Collection, used to store error messages found while validating 
        //* the values bound for creating new ToDo items.  This array is bound 
        //* to a DIV on the New ToDo Item dialog.  Any messages found in this 
        //* collection will be displayed when the form on that dialog is 
        //* submitted.
        //*********************************************************************
        self.newItemErrors = ko.observableArray([]);

        //*********************************************************************
        //* Method used to persist a new ToDo item to the back-end using 
        //* an HTTP POST to REST resource webresources/todo.
        //*********************************************************************
        self.createNewItem = function() {
            
            // Data Validation
            this.newItemErrors.removeAll();
            
            if(this.newTask().length === 0) { 
                this.newItemErrors.push("The Task Field is required.");
            }
            
            var dueByDate = moment(this.newDueBy());
            if(this.newDueBy().length === 0) { 
                this.newItemErrors.push("The Due By Field is required.");
            } else { 
                if(dueByDate.isValid() === false) { 
                    this.newItemErrors.push("Invalid date format for Due By field.");
                }
            }
            
            // If any errors were found, cancel the submission of the form.
            if(this.newItemErrors().length > 0) { 
                return false;
            }
            
                                   
            // Construct a JSON object to be sent to the server.
            var request = {
                taskid: null, 
                priority: this.newPriority(), 
                done: this.newIsDone(), 
                task: this.newTask(), 
                dueby: dueByDate
            };   
            
            // jQuery ajax POST
            $.ajax({
                type: "POST",
                url: "webresources/todo",
                contentType: "application/json; charset=utf-8",
                data: JSON.stringify(request), 
                dataType: "json",
                success: function(data, status, jqXHR) {
                    toastr.success("Item created successfully.");
                    self.disposeNewItemForm();                    
                    self.loadInitialData();
                },
                error: function(jqXHR, status) {    
                    toastr.error("A critical error occurred.  Status Code [" + 
                            status + 
                            "].  Supplemental information [" + jqXHR +"]");
                }
            });   
        };
        
        //*********************************************************************
        //* Used to cleanup bound variables associated with creating new 
        //* ToDo items, empty the newItemErrors array, and to close the 
        //* #newitemmodal dialog.
        //*********************************************************************
        self.disposeNewItemForm = function() {
            self.newIsDone(false);
            self.newPriority("0");
            self.newTask("");
            self.newDueBy("");    
            this.newItemErrors.removeAll();
            $('#newitemModal').foundation('reveal', 'close');
        };

        //*********************************************************************
        //* This method deletes ToDo items, via an HTTP DELETE call to REST 
        //* resource webresources/todo/{taskId].
        //*********************************************************************
        self.removeItem = function(item) {
            var r = confirm("Are you sure you want to delete this item?");
            if (r === true) {
                $.ajax({
                    type: "DELETE",
                    url: "webresources/todo/" + item.taskId,
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    success: function(data, status, jqXHR) {
                        toastr.success("Item deleted successfully.");
                        self.loadInitialData();
                    },
                    error: function(jqXHR, status) {
                        toastr.error("A critical error occurred.  " + 
                            "Status Code [" + status + "].  Supplemental " + 
                            "information [" + jqXHR +"]");
                    }
                });
            }
        };
                
        //*********************************************************************
        //* Triggers the first load of ToDo items into the main page.
        //*********************************************************************
        self.loadInitialData();        
    };

    return {
        start: function() {
            $(document).foundation();
            var model = new AppViewModel();
            ko.applyBindings(model);
        }
    };
});