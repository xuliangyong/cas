package com.lovebuy.cas;

import org.jasig.cas.authentication.handler.AuthenticationException;
import org.jasig.cas.authentication.handler.BadUsernameOrPasswordAuthenticationException;
import org.jasig.cas.authentication.handler.support.AbstractUsernamePasswordAuthenticationHandler;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.binding.message.MessageBuilder;

import com.lovebuy.dubbo.service.UserService;

/**
 * 
 * @author 徐良永
 * @2015年7月7日 下午3:54:48
 */
public class DubboAuthenticationHandler extends AbstractUsernamePasswordAuthenticationHandler {
	private final Logger log = LoggerFactory.getLogger(DubboAuthenticationHandler.class);

	private UserService userService;

	@Override
	protected boolean authenticateUsernamePasswordInternal(UsernamePasswordCredentials upc) throws AuthenticationException {
		try {
			userService.authenticate(upc.getUsername(), upc.getPassword());
			return true;
		} catch (Exception e) {
			log.error(e.getMessage(), e);
			upc.setRed_flag(1);
			upc.setError_count(upc.getError_count()+1);
			throw new BadUsernameOrPasswordAuthenticationException("用户名或密码不正确");
		}
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
}