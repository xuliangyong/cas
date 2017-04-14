package com.lovebuy.cas;

import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.web.support.WebUtils;
import org.springframework.binding.message.MessageBuilder;
import org.springframework.binding.message.MessageContext;
import org.springframework.webflow.execution.RequestContext;

/**
 * @author Will
 * 
 *         2015-8-26 下午4:28:43
 */
public class VerificationCodeController {

	public final String submit(RequestContext context, MessageContext messageContext) throws Exception {
		UsernamePasswordCredentials credentials = (UsernamePasswordCredentials) context.getFlowScope().get("credentials");
		
		String verificationCode = context.getRequestParameters().get("verificationCode");
		HttpSession session = WebUtils.getHttpServletRequest(context).getSession();
		String sessionId = session.getId();
		String sessionVerificationCode = session.getAttribute(sessionId).toString();
		
		if (verificationCode != null && sessionVerificationCode != null && 
				sessionVerificationCode.equals(verificationCode)) {
			return "success";
		}
		credentials.setError_count(credentials.getError_count()+1);
		credentials.setRed_flag(4);
		
		MessageBuilder msgBuilder = new MessageBuilder();
		msgBuilder.defaultText("验证码错误");
		messageContext.addMessage(msgBuilder.error().build());
		return "error";
	}
}
