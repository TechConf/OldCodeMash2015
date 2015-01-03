/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.aep.ea.responsivetodo.zold.services;

import com.aep.ea.responsivetodo.zold.model.Priority;
import com.aep.ea.responsivetodo.zold.model.ToDo;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.Consumes;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;

/**
 * REST Web Service
 *
 * @author S001350
 */
@Path("todolist")
public class TodoListResource {

    @Context
    private UriInfo context;

    /**
     * Creates a new instance of TodoResource
     */
    public TodoListResource() {
    }

    /**
     * Retrieves representation of an instance of com.aep.ea.responsivetodo.services.TodoResource
     * @return 
     */
    @GET
    @Path("list")
    @Produces("application/json")    
    public List<ToDo> getJson() {
        ArrayList<ToDo> result = new ArrayList<>();
        
        result.add(new ToDo(1, false, Priority.HIGH, "This is test number 1", "06/01/2014"));
        /*
         result.add(new ToDo(2, true, Priority.MEDIUM, "This is test number 2", "07/01/2014"));
         result.add(new ToDo(3, false, Priority.LOW, "This is test number 3", "07/01/2014"));
         result.add(new ToDo(4, true, Priority.MEDIUM, "This is test number 4", "07/01/2014"));
         result.add(new ToDo(5, false, Priority.MEDIUM, "This is test number 5", "07/01/2014"));
         */
        return result;
    }

    /**
     * PUT method for updating or creating an instance of TodoResource
     * @param content representation for the resource
     * @return an HTTP response with content of the updated or created resource.
     */
    @PUT
    @Consumes("application/json")
    public void putJson(ToDo content) {
    }
}
