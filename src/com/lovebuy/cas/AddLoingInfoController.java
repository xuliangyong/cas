package com.lovebuy.cas;

import org.jasig.cas.authentication.principal.Credentials;
import org.jasig.cas.web.support.WebUtils;
import org.springframework.binding.message.MessageContext;
import org.springframework.webflow.execution.RequestContext;


public class AddLoingInfoController{
	
	 public final void addInfo(final RequestContext context, final Credentials credentials, final MessageContext messageContext) throws Exception {
		    System.out.println(credentials.toString());
	   	 	//WebUtils.longinInfoReturn(context, credentials);
	}
}
