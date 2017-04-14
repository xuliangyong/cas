package com.lovebuy.cas;

import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.springframework.webflow.execution.RequestContext;


public class ErrorCountCheckController {
	public final String check(RequestContext context){
		UsernamePasswordCredentials credentials = (UsernamePasswordCredentials) context.getFlowScope().get("credentials");
		if(credentials.getError_count()>5){
			return "success";
		}
		return "error";
		
	
	}
}
