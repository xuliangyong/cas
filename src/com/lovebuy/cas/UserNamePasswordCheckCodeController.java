package com.lovebuy.cas;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.web.support.WebUtils;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.webflow.execution.RequestContext;

import com.alibaba.fastjson.JSON;

public class UserNamePasswordCheckCodeController {
	public final String check(RequestContext context, MessageContext messageContext) throws Exception {
		UsernamePasswordCredentials credentials = (UsernamePasswordCredentials) context.getFlowScope().get("credentials");
		int red_flag = 0;
		if(StringUtils.isNotBlank(credentials.getUsername()) && StringUtils.isNotBlank(credentials.getPassword())){
			return "success";
		}
		String msg = "";
		if(StringUtils.isBlank(credentials.getUsername()) && StringUtils.isBlank(credentials.getPassword())){
			msg = "用户名和密码不可为空";
			red_flag = 1;
		}else if(StringUtils.isNotBlank(credentials.getUsername())){
			msg = "密码不可为空";
			red_flag = 2;
		}else{
			msg  = "用户名不可为空";
			red_flag = 3;
		}
		
	    credentials.setError_count(credentials.getError_count()+1);
		credentials.setRed_flag(red_flag);//红边框标记
		
		
		MessageBuilder msgBuilder = new MessageBuilder();
		msgBuilder.defaultText(msg);
		messageContext.addMessage(msgBuilder.error().build());
		
		return "error";
		
	
	}
}
