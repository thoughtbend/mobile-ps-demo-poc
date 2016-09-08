package com.thoughtbend.abouttownapi.endpoint;

import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.core.Request;
import javax.ws.rs.core.Response;

@Path("/caborder")
public class CabOrderApi {

	private final static String ABOUTTOWN_TABLE_ARN = System.getProperty("dynamodb.arn");/*"arn:aws:dynamodb:us-west-2:672998018676:table/ChecklistTemplate";*/
	
	@POST
	public Response createCabOrder(Request request) {
		
		return null;
	}
}
