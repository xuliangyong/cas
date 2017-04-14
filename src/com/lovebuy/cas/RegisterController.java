package com.lovebuy.cas;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.constraints.NotNull;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.lovebuy.dubbo.service.AreaService;
import com.lovebuy.dubbo.service.NavigationService;
import com.lovebuy.dubbo.service.SysConfigService;
import com.lovebuy.entity.Area;
import com.lovebuy.entity.Navigation;
import com.lovebuy.entity.SysConfig;

@Controller
public   class RegisterController extends AbstractController{
	@NotNull
    private String registerView;
	@Autowired
	private AreaService areaService;
	@Autowired
	private SysConfigService sysConfigService;
	@Autowired
	private NavigationService navigationService;
	
	@Override
	protected ModelAndView handleRequestInternal(HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		ModelAndView mv = new ModelAndView(this.registerView);
		/**   register页      */
		String op_title = request.getParameter("op_title");
		List<Area> areas = this.areaService.selectParentIsNullArea();
		if(op_title!=null&&op_title!=""){
			String title="";
			if(op_title.equals("unique")){
				title="用户名已存在,请重新注册信息！";
				mv.addObject("op_title", title);
			}
		}
		if(request.getSession(false) != null){
			if(request.getSession(false).getAttribute("verify_code") != null){
				request.getSession(false).removeAttribute("verify_code");
			}
		}
		mv.addObject("areas",areas);
		/**  top页   */
		SysConfig config = sysConfigService.getIndexConfig();
		mv.addObject("config", config);
		/** head页  */
		String type = (String) request.getAttribute("type");
		if(type == null || type.trim().equals("")){
			type="goods";
		}
		mv.addObject("type", type);
		
		
		return mv;
	}

	public String getRegisterView() {
		return registerView;
	}

	public void setRegisterView(String registerView) {
		this.registerView = registerView;
	}

	public AreaService getAreaService() {
		return areaService;
	}

	public void setAreaService(AreaService areaService) {
		this.areaService = areaService;
	}

	public SysConfigService getSysConfigService() {
		return sysConfigService;
	}

	public void setSysConfigService(SysConfigService sysConfigService) {
		this.sysConfigService = sysConfigService;
	}

	public NavigationService getNavigationService() {
		return navigationService;
	}

	public void setNavigationService(NavigationService navigationService) {
		this.navigationService = navigationService;
	}
	
	

}
