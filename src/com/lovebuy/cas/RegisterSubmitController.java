package com.lovebuy.cas;

import java.math.BigDecimal;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jasig.cas.CentralAuthenticationService;
import org.jasig.cas.authentication.principal.UsernamePasswordCredentials;
import org.jasig.cas.ticket.TicketException;
import org.jasig.cas.util.Md5Encrypt;
import org.jasig.cas.web.support.CookieRetrievingCookieGenerator;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestUtils;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.alibaba.fastjson.JSON;
import com.alibaba.fastjson.JSONObject;
import com.lovebuy.dubbo.service.AlbumService;
import com.lovebuy.dubbo.service.AreaService;
import com.lovebuy.dubbo.service.BalanceService;
import com.lovebuy.dubbo.service.GoldBondLogService;
import com.lovebuy.dubbo.service.IntegralLogService;
import com.lovebuy.dubbo.service.SysConfigService;
import com.lovebuy.dubbo.service.UserService;
import com.lovebuy.entity.Area;
import com.lovebuy.entity.Balance;
import com.lovebuy.entity.GoldBondLog;
import com.lovebuy.entity.SysConfig;
import com.lovebuy.entity.User;

@Controller
public class RegisterSubmitController extends AbstractController{
	private UserService userService;
	private SysConfigService sysConfigService;
	private AreaService areaService;
	private AlbumService  albumService; 
	private IntegralLogService integralLogService;
	private CentralAuthenticationService centralAuthenticationService;
	private CookieRetrievingCookieGenerator ticketGrantingTicketCookieGenerator;
	private GoldBondLogService goldBondLogService;
	private BalanceService balanceService;
	
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request,HttpServletResponse response) throws Exception {
		
		String userName = request.getParameter("userName").trim();
		String password = request.getParameter("password").trim();
//		String code = request.getParameter("code");
		String area_id  = request.getParameter("area_id").trim();
		String mobile = request.getParameter("mobile").trim();
		//String password_pay  = request.getParameter("password_pay").trim();
	
		Area area = this.areaService.selectById(Long.parseLong(area_id));
		// 进一步控制用户名不能重复，防止在未开启注册码的情况下注册机恶意注册
	
		User user = new User();
		user.setUserName(userName);
		user.setUserRole("BUYER");
		user.setAddTime(new Date());
		user.setPassword(Md5Encrypt.md5(password).toLowerCase());
		user.setArea_id(area.getId());
		user.setSex(-1);
		user.setMobile(mobile);
		user.setUse_integral(new BigDecimal("0.00"));
		//删除了
		//user.setAvailableBalance(new BigDecimal("0.00000000"));
		//user.setFreezeBlance(new BigDecimal("0.00000000"));
		user.setMarket_level(-1);
		user.setPassword_pay("");
		user.setPwd_salt("");
		user.setTrueName("");
		user.setPlatform("store");//注册的平台 --商城pc注册
		
		SysConfig ff = sysConfigService.getIndexConfig();
		if (ff.getIntegral()) { //如果开启积分
			user.setIntegral(BigDecimal.valueOf(ff.getMemberRegister()));
			
			com.lovebuy.entity.IntegralLog log = new com.lovebuy.entity.IntegralLog();
			log.setAddTime(new Date());
			log.setContent("用户注册增加: "
					+ this.sysConfigService.getIndexConfig().getMemberRegister()
					+ " 积分");
			log.setIntegral_type(1);// 类型，分为0减少, 1增加
			log.setIntegral(BigDecimal.valueOf(this.sysConfigService.getIndexConfig().getMemberRegister()));
			log.setIntegral_user_id(user.getId());
			log.setRemain_integral(user.getIntegral());// 用户的可用积分余额
			log.setType("reg");
			this.integralLogService.save(log);
		} 
		
		//保存用户
		try{
			this.userService.save(user);
			bindTicketGrantingTicket(userName, password, request, response);
		}catch(Exception e){
			System.out.println("**** catch到错误了");
		}
		//m_moneyrecord 表存值
		GoldBondLog goldBondLog = new GoldBondLog();
		goldBondLog.setUsername(userName);
		goldBondLog.setTime(new Date());
		goldBondLog.setType(0);
		goldBondLog.setAmount(new BigDecimal("0.00"));
		//goldBondLog.setNotes(null);
		goldBondLog.setRemaining(new BigDecimal("0.00"));
		goldBondLog.setSequence(0L);
		boolean f  = goldBondLogService.insert(goldBondLog);
		System.out.println("*************保存m_moneyrecord"+(f?"成功":"失败"));
		//iskyshop_predeposit_log表存值
		Balance balance = new Balance();
		balance.setPd_op_type(0);
		balance.setPd_log_user_name(userName);
		balance.setPd_log_status("成功");
		String jsons = "{\"message\":\"\"}";
		JSONObject json = JSON.parseObject(jsons);
		balance.setPd_log_info( json.toJSONString());
		boolean fff  =  balanceService.saveBalance(balance);
		System.out.println("*************保存iskyshop_predeposit_log"+(fff?"成功":"失败"));
		
		// 创建用户默认相册
		com.lovebuy.entity.Album album = new com.lovebuy.entity.Album();
		album.setAddTime(new Date());
		album.setAlbum_default(true);
		album.setAlbum_name("默认相册");
		album.setAlbum_sequence(-10000);
		
		User userid = userService.findByUsername(userName);
		album.setUser_id(userid.getId());
		boolean i = this.albumService.save(album);
		System.out.println("*************保存iskyshop_album"+(i?"成功":"失败"));
		
		
		//删除验证码
		if(request.getSession()!=null){
			if(request.getSession().getAttribute("verify_code") !=null){
				request.getSession().removeAttribute("verify_code");
			}
		}
		return new ModelAndView(getSignInView(request));
	}
	
	
	 /**
		 * Invoke generate validate Tickets and add the TGT to cookie.
		 * @param loginName 	the user login name.
		 * @param loginPassword the user login password.
		 * @param request		the HttpServletRequest object.
		 * @param response		the HttpServletResponse object.
		 */
	private void bindTicketGrantingTicket(String loginName,String loginPassword, HttpServletRequest request,HttpServletResponse response) {
		try {
			UsernamePasswordCredentials credentials = new UsernamePasswordCredentials();
			credentials.setUsername(loginName);
			credentials.setPassword(loginPassword);
			String ticketGrantingTicket = centralAuthenticationService.createTicketGrantingTicket(credentials);
			ticketGrantingTicketCookieGenerator.addCookie(request, response,ticketGrantingTicket);
		} catch (TicketException te) {
			logger.error("Validate the login name " + loginName
					+ " failure, can't bind the TGT!", te);
		} catch (Exception e) {
			logger.error("bindTicketGrantingTicket has exception.", e);
		}
	}
	
	 /**
		 * Get the signIn view URL.
		 * @param request the HttpServletRequest object.
		 * @return redirect URL
		 */
	private String getSignInView(HttpServletRequest request) {
		String service = ServletRequestUtils.getStringParameter(request, "service", "");
		System.out.println("*********"+service);
		return ("redirect:login" + (service.length() > 0 ? "?service=" + service : ""));
	}


	public void setUserService(UserService userService) {
		this.userService = userService;
	}


	public void setSysConfigService(SysConfigService sysConfigService) {
		this.sysConfigService = sysConfigService;
	}


	public void setAreaService(AreaService areaService) {
		this.areaService = areaService;
	}


	public void setAlbumService(AlbumService albumService) {
		this.albumService = albumService;
	}

	

	public void setGoldBondLogService(GoldBondLogService goldBondLogService) {
		this.goldBondLogService = goldBondLogService;
	}


	public void setBalanceService(BalanceService balanceService) {
		this.balanceService = balanceService;
	}


	public void setIntegralLogService(IntegralLogService integralLogService) {
		this.integralLogService = integralLogService;
	}


	public void setCentralAuthenticationService(
			CentralAuthenticationService centralAuthenticationService) {
		this.centralAuthenticationService = centralAuthenticationService;
	}


	public void setTicketGrantingTicketCookieGenerator(
			CookieRetrievingCookieGenerator ticketGrantingTicketCookieGenerator) {
		this.ticketGrantingTicketCookieGenerator = ticketGrantingTicketCookieGenerator;
	}
}
