/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.taylodl.jaxrs.maven;

import javax.ws.rs.core.Context;
import javax.ws.rs.core.UriInfo;
import javax.ws.rs.PathParam;
import javax.ws.rs.Consumes;
import javax.ws.rs.PUT;
import javax.ws.rs.Path;
import javax.ws.rs.GET;
import javax.ws.rs.Produces;

/**
 * REST Web Service
 *
 * @author Don
 */

@Path("helloworld/{fname}/{lname}")
public class HelloWorld {
    @Context
    private UriInfo context;

    /** Creates a new instance of HelloWorld */
    public HelloWorld() {
    }

    /**
     * Retrieves representation of an instance of com.taylodl.jaxrs.maven.HelloWorld
     * @return an instance of java.lang.String
     */
    @GET
    @Produces("application/json")
    public Person getText(@PathParam("fname") String fname, @PathParam("lname") String lname) {
        return new Person(fname, lname);
    }
    
//    @GET
//    @Produces("text/html")
//    public String getHtml(@PathParam("fname") String fname, @PathParam("lname") String lname) {
//        return "<html><body><p>fname=" + fname + "</br>lname=" + lname + "</p></body></html>";
//    }
    
    /**
     * PUT method for updating or creating an instance of HelloWorld
     * @param content representation for the resource
     * @return an HTTP response with content of the updated or created resource.
     */
    @PUT
    @Consumes("text/plain")
    public void putText(String content) {
    }
}
