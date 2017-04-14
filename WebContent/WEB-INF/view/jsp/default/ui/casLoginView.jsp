<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<%@ page session="true" %>
<%@ page pageEncoding="UTF-8" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>用户登录</title>
<link href="http://www.gtimall.com/resources/style/system/front/default/css/public.css" type="text/css" rel="stylesheet" />
<link href="http://www.gtimall.com/resources/style/system/front/default/css/goods.css" type="text/css" rel="stylesheet" />
<script src="http://www.gtimall.com/resources/js/jquery-1.6.2.js"></script>
<!-- <script src="http://www.gtimall.com/resources/js/jquery.validate.min.js"></script> -->
<link id="size-stylesheet" rel='stylesheet' type='text/css' href='http://www.gtimall.com/resources/style/system/front/default/css/1002.css' />
<style type="text/css">
label.error {
	display: inline-block;
}
/* #msg{
    background-image:url(images/user_05.png);background-repeat: no-repeat;width: 220px;display: inline-block;background-color: rgba(255, 0, 0, 0.1);line-height: 26px;padding-left: 26px;
	color: #F00;
} */

</style>
<script>
$(document).ready(function(){
	$("input").keyup(function(){//输入内容是字体颜色加深
		 $(this).css("color","#333");
	}); 
	 $("#pd").val("密码");
	 $("#verificationCode").val("验证码");
	 
	$("#ver_code").hide();
		var username = $("#username").val();
		if(username.length<1){
			$("#username").val("用户名")
		}
		var password = $("#password").val();
		if(password == ""){
			 $("#pd").show();
			 $("#password").val("");
		}else{
			$("#pd").hide();
			$("#password").val(obj.password);
		}
		
		var red_flag = $("#red_flag").val();
		
		if(red_flag == 1){
			 $("#username").css("border","1px solid #F00");
			 $("#password").css("border","1px solid #F00");
			 $("#pd").css("border","1px solid #F00");
		}
		if(red_flag == 2){
			 $("#password").css("border","1px solid #F00");
			 $("#pd").css("border","1px solid #F00");
		}
		if(red_flag == 3){
			 $("#username").css("border","1px solid #F00");
		}
		if(red_flag == 4){
			 $("#verificationCode").css("border","1px solid #F00");
		}
		
		
	  if($("#error_count").val()>5){
		 $("#ver_code").show();
		 refreshCode();
	  }
		 
	  $("#username").focus(function(){
	    if($("#username").val() == "用户名"){
			  $("#username").val("");
		  }
	  });
	  $("#username").blur(function(){
		  if($("#username").val() == ""){
			  $("#username").val("用户名");
		  }
	  });
	  
	  $("#pd").focus(function(){
				  $("#pd").hide();
				  $("#password").focus();
				  $("#password").show();
	  });
	  $("#password").blur(function(){
		  if($("#password").val() == ""){
			  $("#pd").show();
			  $("#pd").val("密码");
		  }
	  });
	  
	  $("#verificationCode").focus(function(){
		    if($("#verificationCode").val() == "验证码"){
				  $("#verificationCode").val("");
		  }
	  });
	  $("#verificationCode").blur(function(){
		  if($("#verificationCode").val() == ""){
			  $("#verificationCode").val("验证码");
		  }
	  });

  
});

function longin_validata(){//每次输入框失去焦点是调用
	 var username = $("#username").val();
	 var password = $("#password").val();
	 var code = $("#verificationCode").val();
	 var s ="";
	 if($("#error_count").val()>5){
			 s = username_validata(username)+","+password_validata(password);
			 var codestr = code_validata(code);
			 if (s.substring(0,1)=="," && s.length>0){
				 s = s.substring(1, s.length);
			 }
			 if(s.substring(s.length-1,s.length)==","){
				 s = s.substring(0, s.length-1);
			 }
			 if($.trim(s) != ""){
				 s += "不能为空";
			 }else{
				 s=codestr;
			 }
			 if(codestr !=""){
				 refreshCode();
			 }
	 }else{
			 s = username_validata(username)+","+password_validata(password);
			 if (s.substring(0,1)=="," && s.length>0){
				 s = s.substring(1, s.length);
			 }
			 if(s.substring(s.length-1,s.length)==","){
				 s = s.substring(0, s.length-1);
			 }
			 if($.trim(s) != ""){
				 s += "不能为空";
			 }
	 }
	 return s;
 }

function username_validata(obj){//用户名验证
	if($.trim(obj)!= "" && $.trim(obj)!= "用户名"){
		$("#username").css("border","1px solid #ccc");
		return "";
	}
	$("#username").css("border","1px solid #F00");
	return "用户名";
}
function password_validata(obj){//密码验证
	if($.trim(obj)!= ""){
		$("#pd").css("border","1px solid #ccc");
		return "";
	}
	$("#pd").css("border","1px solid #F00");
	return "密码";
}
function code_validata(obj){//验证码验证
	var falg = "验证码错误或已过期";
	if($.trim(obj) != "验证码"){
		$.ajax({
			 async:false,
			 type: "post",               //数据发送方式
			 dataType: "text",           //接受数据格式   
			 url:"registerjson.htm?method=code_validata",
			 data:{"type":"code_validata","verificationCode":obj },
			 success:function(data){
				 if(data=="success"){
					 falg =  "";
				 }
			}});
	}
	if(falg == ""){
		$("#verificationCode").css("border","1px solid #ccc");
	}else{
		$("#verificationCode").css("border","1px solid #F00");
	}
	return falg;
}


function refreshCode(){
	$("#code_img").attr("src", "verificationCode?d" + new Date().getTime());
}
var i = 0;
function showCode(){
	$("#cod_lab").html("");
	$("#verificationCode").val("");
	if(i <= 0){
		$("#refresh_code").show();
		//refreshCode();
		i++;
	}
}
document.onkeydown = function(event){
	var e = event || window.event;
	if(e.keyCode == 13){
		$("#login_userbtn").click();
	}
}
function toVaild(){//登录按钮时验证
	var a = longin_validata();
	if($.trim(a) == ""){
		return true;
	}else{
		var msg = $("#msg").val();
		if(msg == undefined){
			$("#showmsg").html("<div id=\"msg\" style=\"background-image:url(images/user_05.jpg);background-repeat: no-repeat;width: 220px;display: inline-block;background-color: rgba(255, 0, 0, 0.1);line-height: 26px;padding-left: 26px;color: #F00;\">用户名和密码不可为空</div>");
		}
		$("#msg").html(a);
		var ct = $("#error_count").val();
		$("#error_count").val(Number(ct)+1);
		if($("#error_count").val()== 6){
			 $("#ver_code").show();
			 refreshCode();
		}
		return false;
	}
}
</script>
</head>
<body style="background:url(images/body_bg_2.jpg) no-repeat center top/cover;">
<div class="main">
<div class="head_login">
	<div class="login_logo" style="margin-top:30px; margin-bottom:20px; padding-left:80px; position: relative; width:201px; float:left;"> 
		<a href="http://www.gtimall.com/index.html">
			<img src="http://www.gtimall.com/resources/style/system/front/default/images/logo.gif"  border="0" />
		</a>
		<div class="logo_line" style="position: absolute; right:18px; bottom:2px;">
			<img src="http://www.gtimall.com/resources/style/system/front/default/images/logo_line.png" />
		</div>
	</div>
	<div style="float:left; margin-top:42px;"><img src="http://www.gtimall.com/resources/style/system/front/default/images/slogan_05.png"/></div>
</div>
<div class="index">
	<div class="index2">
		<div class="login_usertb">
			<div class="login_usertb_bgimg">
				<span class="imgcenter_span">
					<p><img src="images/login_image_10.png" width="490" height="480"/></p>
				</span>
			</div>
			<div class="login_usetbox">
			<div class="login_titel">
				<b>登录爱购商城</b>
				<a href="register"><p>注册</p></a>
			</div>
				<div class="login_usrin">
					<ul>
						<form:form method="post" id="theForm" onsubmit="return toVaild();" cssClass="fm-v clearfix"   commandName="${commandName}" htmlEscape="true" >
							<li id="showmsg" style="width:250px;">
								<form:errors path="*" id="msg"  element="div" cssStyle=" background-image:url(images/user_05.jpg);background-repeat: no-repeat;width: 220px;display: inline-block;background-color: rgba(255, 0, 0, 0.1);line-height: 26px;padding-left: 26px;color: #F00;" />
							</li>
							<li class="login_usertxt">
								<label class="login_icons" for="username">
									<img src="http://www.gtimall.com/resources/style/system/front/default/images/user_03.png" />
								</label>
								<form:input path="username" id="username" cssClass="login_utxt login_username" autocomplete="false" htmlEscape="true" />
							</li>
							<li class="login_usertxt">
								<label class="login_icons" for="password" style="z-index:10;">
									<img src="http://www.gtimall.com/resources/style/system/front/default/images/user_11.png" />
								</label>
								<input name="pd" type="text" id="pd"   style="left: 0px; top: 0px; position: absolute;" class="login_utxt login_userpassword"/>
								<form:password path="password" id="password"  value=""  cssClass="login_utxt login_userpassword" htmlEscape="true" autocomplete="off" />
							</li>
							<li id="ver_code" class="login_usertxt code_txt">
								<label class="login_icons" for="verificationCode">
									<img src="http://www.gtimall.com/resources/style/system/front/default/images/user_13.png" />
								</label>
								<input id="verificationCode" class="login_utxt login_vcode" type="text" autocomplete="false"
										  name="verificationCode"/>
								<span id="refresh_code"  name="refresh_code">
									<img id="code_img" style=" padding-top:2px; display: inline-block; vertical-align: top" name="code_img" alt="" src=""/>
									<a id="getCode" onclick="refreshCode();" href="javascript:void(0);" style="position: relative; left:0px; padding-left:2px; padding-right:2px;">
										<img src="http://www.gtimall.com/resources/style/system/front/default/images/u_13.png" />
									</a>
								</span>
							</li>
							<li>
								<form:hidden id="error_count" path="error_count"  autocomplete="false" htmlEscape="true" />
		                    	<form:hidden id="loginIp" path="loginIp" autocomplete="false" htmlEscape="true" />
		                    	<form:hidden id="red_flag" path="red_flag" autocomplete="false" htmlEscape="true" />
								<input type="hidden" name="lt" value="${loginTicket}" />
								<input type="hidden" name="execution" value="${flowExecutionKey}" />
								<input type="hidden" id="_eventId" name="_eventId" value="submit" />
								
								<input class="login_userbtn" name="submit" id="login_userbtn" value="登&nbsp;&nbsp;&nbsp;&nbsp;录" type="submit" />
							</li>
							<li class="login_usercheck"><a href="http://www.gtimall.com/forget1st.htm" class="forgetpsw">忘记密码?</a></li>
						</form:form>
					</ul>
				</div>
			</div>
		</div>
	</div>
</div>
</div>
</body>
</html>
