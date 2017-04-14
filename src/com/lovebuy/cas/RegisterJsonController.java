package com.lovebuy.cas;

import java.io.PrintWriter;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.jasig.cas.util.CommUtil;
import org.jasig.cas.util.Md5Encrypt;
import org.nutz.json.Json;
import org.nutz.json.JsonFormat;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.lovebuy.dubbo.service.AlbumService;
import com.lovebuy.dubbo.service.AreaService;
import com.lovebuy.dubbo.service.GlobalConfigService;
import com.lovebuy.dubbo.service.IntegralLogService;
import com.lovebuy.dubbo.service.MobileverifyCodeService;
import com.lovebuy.dubbo.service.SMSService;
import com.lovebuy.dubbo.service.SysConfigService;
import com.lovebuy.dubbo.service.UserService;
import com.lovebuy.entity.Area;
import com.lovebuy.entity.Mobileverifycode;
import com.lovebuy.entity.SysConfig;
import com.lovebuy.entity.User;

public class RegisterJsonController extends AbstractController{
	private static Logger logger = Logger.getLogger(RegisterJsonController.class);
	
	private UserService userService;
	private SysConfigService sysConfigService;
	private  MobileverifyCodeService mobileverifyCodeService;
	private SMSService sMSService;
	private AreaService areaService;
	private AlbumService  albumService; 
	private IntegralLogService integralLogService;
	private GlobalConfigService globalConfigService;
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		String method = request.getParameter("method");//getAttribute("method");
		String result = null;
		if(method.equals("verify_username")){
			result = verify_username(request,response);
		}else if(method.equals("verify_user_mobile")){
			result = verify_user_mobile(request,response);
		}else if(method.equals("account_mobile_sms_register")){
			result = account_mobile_sms_register(request,response);
		}else if(method.equals("account_mobile_sms_validate")){
			result = account_mobile_sms_validate(request,response);
		}else if(method.equals("load_area")){
			result = load_area(request,response);
		}else if(method.equals("register_finish")){
			result = register_finish(request,response);
		}else if(method.equals("code_validata")){
			result = code_validata(request,response);
		}
		response.setContentType("text/plain");
		response.setHeader("Cache-Control", "no-cache");
		response.setCharacterEncoding("UTF-8");

		PrintWriter  writer = response.getWriter();
		writer.print(result);
		
		return null;
	}
	private String code_validata(HttpServletRequest request,
			HttpServletResponse response) {
		String verificationCode = request.getParameter("verificationCode").trim();
		HttpSession session = request.getSession();
		String sessionVerificationCode = session.getAttribute("verificationCode").toString().trim();
		
		if (verificationCode != null && sessionVerificationCode != null && 
				sessionVerificationCode.equals(verificationCode)) {
			return "success";
		}
		return "error";
	}
	/**
	 *  注册完成界面
	 * @param request
	 * @param response
	 * @return
	 */
	private String register_finish(HttpServletRequest request,
			HttpServletResponse response) {
			String userName = request.getParameter("userName");
			String password = request.getParameter("password");
			String code = request.getParameter("code");
			String area_id  = request.getParameter("area_id");
			String mobile = request.getParameter("mobile");
			String password_pay  = request.getParameter("password_pay");
		
		Area area = this.areaService.selectById(Long.parseLong(area_id));
		// 进一步控制用户名不能重复，防止在未开启注册码的情况下注册机恶意注册
		/*Map params = new HashMap();
		params.put("userName", userName);*/
		com.lovebuy.entity.User users = this.userService.findByUsername(userName);
		if (users == null) {
			com.lovebuy.entity.User user = new com.lovebuy.entity.User();
			user.setUserName(userName);
			user.setUserRole("BUYER");
			user.setAddTime(new Date());
			user.setPassword(Md5Encrypt.md5(password).toLowerCase());
			user.setArea_id(area.getId());
			user.setSex(-1);
			user.setMobile(mobile);
			user.setUse_integral(new BigDecimal("0.00"));
			//user.setAvailableBalance(new BigDecimal("0.00000000"));
			//user.setFreezeBlance(new BigDecimal("0.00000000"));
			user.setMarket_level(-1);
			user.setPassword_pay(Md5Encrypt.md5(password_pay).toLowerCase());
			user.setPwd_salt("");
	 		SysConfig ff = sysConfigService.getIndexConfig();
			if (sysConfigService.getIndexConfig().getIntegral()) {
				user.setIntegral(BigDecimal.valueOf(this.sysConfigService.getIndexConfig().getMemberRegister()));
				try {
					this.userService.save(user);
				} catch (Exception e) {
					return "no";
				}
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
			} else {
				try {
					this.userService.save(user);
				} catch (Exception e) {
					return "no";
				}
			}
			// 创建用户默认相册
			com.lovebuy.entity.Album album = new com.lovebuy.entity.Album();
			album.setAddTime(new Date());
			album.setAlbum_default(true);
			album.setAlbum_name("默认相册");
			album.setAlbum_sequence(-10000);
			
			User userid = userService.findByUsername(userName);
			album.setUser_id(userid.getId());
			this.albumService.save(album);
			if(request.getSession(false) != null){
				if(request.getSession(false).getAttribute("verify_code") != null){
					request.getSession(false).removeAttribute("verify_code");
				}
			}
			return "yes";
		} else {
			return "no";
		}
	}
	/**
	 * 地区级联显示
	 * @param request
	 * @param response
	 * @return
	 */
	private String load_area(HttpServletRequest request,
			HttpServletResponse response) {
		String result = ""; 
		String pid = request.getParameter("pid");

		List<Area> areas = this.areaService.selectAreaByParentId(Long.parseLong(pid));

		List<Map> list = new ArrayList<Map>();
		List<Area> ar=new ArrayList<Area>();
		for (Area area : areas) {
			int i=0;
			for(Area a:areas){
				if(area.getAreaName().equals(a.getAreaName())){
						i++;
						if(i>1){
							ar.add(a);
						}
				}
			}
		}
		areas.removeAll(ar);
		 
		for(Area area:areas){
			Map map = new HashMap();
			map.put("id", area.getId());
			map.put("areaName", area.getAreaName());
			list.add(map);
		}
		result = Json.toJson(list, JsonFormat.compact());
		return result;
	}
	/**
	 * 短信验证码 验证
	 * @param request
	 * @param response
	 * @return
	 */
	private String account_mobile_sms_validate(HttpServletRequest request,
			HttpServletResponse response) {
		String mobile_verify_code = request.getParameter("mobile_verify_code");
		String mobile = request.getParameter("mobile");
		Mobileverifycode mvc = this.mobileverifyCodeService.getMobileverifyCodeByMobileTable(mobile);
		String flag = "no";
		/*if(mvc != null){
			if(mvc.getCode().equalsIgnoreCase(mobile_verify_code)){
				flag = "yes";
			}
		}*/
		if(mvc != null){
			Date addTime = mvc.getAddTime();
			if(addTime != null){
				if(timeToFailure(addTime)){
					String code = mvc.getCode()==null?"":mvc.getCode().trim();
					if(!code.trim().equals("") && code.trim().equalsIgnoreCase(mobile_verify_code)){
						flag = "yes";
					}else{
						logger.info("***Mobileverifycode的code字段错误。");
					}
				}else{
					logger.info("***短信验证码15分钟过期了");
				}
			}else{
				logger.error("！！！ERROR	: Mobileverifycode的addtime字段为空。");
			}
		}
		return flag;
	}
	/**
	 * 判断记录时间是否超过15分钟
	 * @param addTime
	 * @return
	 */
	private  boolean  timeToFailure(Date addTime){
		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		logger.info("参数addTime的值：("+df.format(addTime)+")");
		
		Calendar cal = Calendar.getInstance();
		cal.setTime(addTime);
		cal.add(Calendar.MINUTE, +15);
		Date date = cal.getTime();
		Date now =  new Date();
		logger.info("***当前时间和addTime是否相差15分钟："+(now.getTime()<date.getTime() && addTime.getTime()<now.getTime()));
		
		return  now.getTime()<date.getTime() && addTime.getTime()<now.getTime();
	}
	/**
	 * 发送短信
	 * @param request
	 * @param response
	 * @return
	 */
	private String account_mobile_sms_register(HttpServletRequest request,
			HttpServletResponse response) {
		String ret = "100";
		String type = request.getParameter("type");
		String mobile = request.getParameter("mobile");
		if (type.equals("mobile_sms_register")) {
			String code = CommUtil.randomInt(4);//CommUtil.randomString(4).toUpperCase();
			String content = "尊敬的用户 ，您本次的手机验证码为：" + code + "。【爱购商城】";
		//	globalConfigService.reload();//doublo 缓存重新读表的数据
			SysConfig sysConfig = sysConfigService.getIndexConfig();
			System.out.println("----------"+sysConfig.getSmsEnbale());
			if (sysConfig.getSmsEnbale()) {
				//boolean ret1 = this.sMSService.sendSMS(mobile, content);
				boolean ret1 = this.sMSService.sendSMS(mobile, content);
				System.out.println("----------ret1:"+ret1);
				if (ret1) {
					Mobileverifycode mvc = this.mobileverifyCodeService.getMobileverifyCodeByMobileTable(mobile);
					System.out.println("mvc == null:"+(mvc == null));
					if (mvc == null) {
						mvc = new Mobileverifycode();
						mvc.setAddTime(new Date());
						mvc.setDeleteStatus(true);
						mvc.setCode(code);
						mvc.setMobile(mobile);
						this.mobileverifyCodeService.saveMobileverifyCode2Table(mvc);
					}else{
						mvc.setAddTime(new Date());
						mvc.setCode(code);
						mvc.setMobile(mobile);
						this.mobileverifyCodeService.updateMobileverifyCodeTable(mvc);
					}
				} else {
					ret = "200";
				}
			} else {
				ret = "300";
			}
		}
		return ret;
	}
	/**
	 *  手机号是否被注册了
	 * @param request
	 * @param response
	 * @return
	 */
	private String verify_user_mobile(HttpServletRequest request,
			HttpServletResponse response) {
		String s = "true";
		String mobile = request.getParameter("mobile");
		List<User> user = userService.getUserByMobile(mobile);
		if(user.size()>0){
			s = "false";
		}
		return s;
		
		 
	}
	/**
	 *  验证用户名是否重复
	 * @param request
	 * @param response
	 * @return
	 */
	private String verify_username(HttpServletRequest request,
			HttpServletResponse response) {
		String s = "true";
		String userName = request.getParameter("userName");
		User user = userService.findByUsername(userName);
		if(user != null){
			s = "false";
		}
		return s;
	}

	public UserService getUserService() {
		return userService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	public SysConfigService getSysConfigService() {
		return sysConfigService;
	}
	public void setSysConfigService(SysConfigService sysConfigService) {
		this.sysConfigService = sysConfigService;
	}
	public MobileverifyCodeService getMobileverifyCodeService() {
		return mobileverifyCodeService;
	}
	public void setMobileverifyCodeService(
			MobileverifyCodeService mobileverifyCodeService) {
		this.mobileverifyCodeService = mobileverifyCodeService;
	}
	public SMSService getsMSService() {
		return sMSService;
	}
	public void setsMSService(SMSService sMSService) {
		this.sMSService = sMSService;
	}
	public AreaService getAreaService() {
		return areaService;
	}
	public void setAreaService(AreaService areaService) {
		this.areaService = areaService;
	}
	public AlbumService getAlbumService() {
		return albumService;
	}
	public void setAlbumService(AlbumService albumService) {
		this.albumService = albumService;
	}
	public IntegralLogService getIntegralLogService() {
		return integralLogService;
	}
	public void setIntegralLogService(IntegralLogService integralLogService) {
		this.integralLogService = integralLogService;
	}
	public GlobalConfigService getGlobalConfigService() {
		return globalConfigService;
	}
	public void setGlobalConfigService(GlobalConfigService globalConfigService) {
		this.globalConfigService = globalConfigService;
	}
	
	
	
}
