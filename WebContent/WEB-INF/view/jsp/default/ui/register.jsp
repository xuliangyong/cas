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
<title>用户注册 -${config.title }</title>
<meta name="keywords" content="$!config.keywords" />
<meta name="description" content="$!config.description" />
<meta name="generator" content="lovebuy v1.1" />
<meta name="author" content="www.lovebuy.com">
	<meta name="copyright" content="lovebuy Inc. All Rights Reserved">
		<link
			href="http://www.lovebuy.com.cn/resources/style/system/front/default/css/public.css"
			type="text/css" rel="stylesheet" />
		<link
			href="http://www.lovebuy.com.cn/resources/style/system/front/default/css/goods.css"
			type="text/css" rel="stylesheet" />
		<link
			href="http://www.lovebuy.com.cn/resources/style/system/front/default/css/index.css"
			type="text/css" rel="stylesheet" />
		<link id="size-stylesheet" rel='stylesheet' type='text/css' href='http://www.lovebuy.com.cn/resources/style/system/front/default/css/1002.css' />
		<script src="http://www.lovebuy.com.cn/resources/js/jquery-1.6.2.js"></script>
		<script src="http://www.lovebuy.com.cn/resources/js/jquery.form.js"></script>
		<script src="http://www.lovebuy.com.cn/resources/js/jquery.validate.min.js"></script>
		<script src="http://www.lovebuy.com.cn/resources/js/verity.js"></script>
<script type="text/javascript">
var rclick  = 0;//注册按钮可以点击标志
var error_flag = "";//错误的提示信息
$(document).ready(function(){
	//jQuery("#save").attr("disabled", "disabled"); 
	$("input").keyup(function(){//输入内容是字体颜色加深
		 $(this).css("color","#333");
		
	}); 
	
	 $("select").change(function(){
		    var level=$(this).attr("level");
			 var id=$(this).val();
			 if(level==2){
				 $("#area3").empty();
				 $("#area3").hide();
				 $("#area_id").val("");
			 }
			 if(level==3){
				 $("#area_id").val("");
			 }
			 if(id!=""){
			  $.post("registerjson.htm?method=load_area",{"pid":id},function(data){
			     $("#area"+level).empty();
				  $("#area"+level).append("<option value=''>请选择</option>");
			    $.each(data, function(index,item){
				  $("#area"+level).append("<option value='"+item.id+"'>"+item.areaName+"</option>");
				  $("#area"+level).show();
				});
			  },"json");
			 }else{
			   for(var i=level;i<=3;i++){
			    $("#area"+i).empty();
			    $("#area"+i).hide();
			   }
			 }
		 }); 
		$("#area3").change(function(){
		  var id=$(this).val();
		  $("#area_id").val(id);
		});
	
		
	 $("select").blur(function(){
		  var obj = $("#area_id");
		  error_flag =  area_validate(obj);
		  error_labelUpdate(obj,error_flag);
	});
	
	$("#userName").focus(function(){
		//$("#save").removeAttr("disabled");
		rclick = 1;
		 if($("#userName").val() == "请输入用户名"){
			 $("#userName").val("");
		 }
	});
	$("#userName").blur(function(){
		  var obj = $("#userName");
		  if($.trim(obj.val()) == ""){
			  error_flag =  username_validate(obj);
			  error_labelUpdate(obj,error_flag);
			  $("#userName").val("请输入用户名");
			  return;
		  }
		 error_flag =  username_validate(obj);
		 error_labelUpdate(obj,error_flag);
	});
	$("#mobile").focus(function(){
		//$("#save").removeAttr("disabled");
		rclick = 1;
		if($.trim($("#mobile").val()) == "输入手机号"){
			 $("#mobile").val("");
		 }
	});
	$("#mobile").blur(function(){
		 var obj = $("#mobile");
		  if($.trim(obj.val()) == ""){
			  error_flag =  mobile_validate(obj);
			  error_labelUpdate(obj,error_flag);
			  $("#mobile").val("输入手机号");
			  return;
		  }
		 error_flag =  mobile_validate(obj);
		 error_labelUpdate(obj,error_flag);
	});
	$("#pd").focus(function(){
		//$("#save").removeAttr("disabled");
		rclick = 1;
		$("#pd").hide();
		$("#password").focus();
	});
	$("#password").blur(function(){
		 var obj = $("#password");
		 if($.trim(obj.val()) == ""){
			  error_flag =  password_validate(obj);
			  error_labelUpdate(obj,error_flag);
			  $("#pd").show();
			  $("#password_pro").hide();
			  return;
		  }
		 error_flag =  password_validate(obj);
		 error_labelUpdate(obj,error_flag);
	});
	$("#rpd").focus(function(){
		//$("#save").removeAttr("disabled");
		rclick = 1;
		$("#rpd").hide();
		$("#repassword").focus();
	});
	$("#repassword").blur(function(){
		var obj = $("#repassword");
		 if($.trim(obj.val()) == ""){
			  error_flag =  repassword_validate(obj);
			  error_labelUpdate(obj,error_flag);
			  $("#rpd").show();
			  return;
		  }
		 error_flag =  repassword_validate(obj);
		 error_labelUpdate(obj,error_flag);
	});
	$("#password").keyup(function() {
		$("#password_pro").show();
		 var strongRegex = new RegExp("^(?=.{9,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
	     var mediumRegex = new RegExp("^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
	     var enoughRegex = new RegExp("(?=.{1,}).*", "g");
	   	if (strongRegex.test($(this).val())) {
	    	 $("#strength_H").attr("style","width:50px; height:20px; border:0px; background:#00cc00; color:#555; margin-right:4px;");
	    	 $("#strength_M").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	    	 $("#strength_L").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	     } else if (mediumRegex.test($(this).val())) {
	    	$("#strength_M").attr("style","width:50px; height:20px; border:0px; background:yellow; color:#555; margin-right:4px;");
	    	 $("#strength_L").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	    	 $("#strength_H").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	     } else if(enoughRegex.test($(this).val())){
	    	 $("#strength_L").attr("style","width:50px; height:20px; border:0px; background:#ff3300; color:#555; margin-right:4px;");
	    	 $("#strength_M").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	    	 $("#strength_H").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	     }else{
	    	 $("#strength_L").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	    	 $("#strength_M").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	    	 $("#strength_H").attr("style","width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;");
	     }
	});
	
	$("#mobile_code").focus(function(){
		//$("#save").removeAttr("disabled");
		rclick = 1;
		if($.trim($("#mobile_code").val()) == "验证码"){
			 $("#mobile_code").val("");
		 }
	});
	$("#mobile_code").blur(function(){
		 var obj = $("#mobile_code");
		  if($.trim(obj.val()) == ""){
			  error_flag =  mobile_code_validate(obj);
			  error_labelUpdate(obj,error_flag);
			  $("#mobile_code").val("验证码");
			  return;
		  }
		 error_flag =  mobile_code_validate(obj);
		 error_labelUpdate(obj,error_flag);
	});
	if ($.browser.msie) { 
		$('input:checkbox').click(function () { 
		this.blur(); 
		this.focus(); 
		}); 
	}; 
	$("#agree").change(function(){
		 error_flag =  agree_validate($("#agree"));
		 error_labelUpdate($("#agree"),error_flag);
		
	});
	
	
	 
});

//********************  错误提示框的信息更新  **********************
function error_labelUpdate(obj,error_flag){
	if(error_flag != ""){
		if($(obj).attr("id") == "password"){
			$("#pd").css("border","1px solid rgb(255, 0, 0)");
		}
		if($(obj).attr("id") == "repassword"){
			$("#rpd").css("border","1px solid rgb(255, 0, 0)");
		}
		$(obj).css("border","1px solid rgb(255, 0, 0)");
	}else{
		if($(obj).attr("id") == "password"){
			$("#pd").css("border","1px solid #ccc");
		}
		if($(obj).attr("id") == "repassword"){
			$("#rpd").css("border","1px solid #ccc");
		}
		$(obj).css("border","1px solid #ccc");
	}
	$("#info_error").html("");
	$("#info_error").html(error_flag);
	
}
 //***********************用户名验证**************************
 function username_validate(obj){
	//$("#save").removeAttr("disabled");
		rclick = 1;
	var val  = obj.val();
	if(un_notNUll(val) != ""){
		return un_notNUll(val);
	}
	if(un_allnumber(val) !=""){
		return un_allnumber(val);
	}
	if(un_checkChinese(val) != ""){
		return un_checkChinese(val);
	}
	if(un_MinMaxLength(val,6,25) != ""){
		return un_MinMaxLength(val,6,25);
	}
	if(un_checkUserName(val) != ""){
		return un_checkUserName(val);
	}
	return "";
 }
 function un_notNUll(data){//非空判断
     data = $.trim(data);  
     if(data.length < 1) {  
         return "用户名不能为空"; 
     }else if(data == "请输入用户名"){
    	 return "用户名不能为空"; 
     }else{
    	 return ""; 
     }
 }
 
 function un_allnumber(data){ //用户名不能全为数字
	 var re =  /^\d+$/;
     if(re.test(data)){			
			return "用户名不能全为数字";
		}else{
		    return "";
	  }		
 }
 
 function un_checkChinese(data){//不可使用特殊字符或汉字
	 var re =  /^[a-zA-Z0-9_]*$/;  
     if(re.test(data)){			
			return "";
	 }else{
	 	    return "不可使用特殊字符或汉字";
	 }	
 }
 function un_MinMaxLength(data,min,max){//用户名的最小和最大的长度
	 if(data.length < min) {  
         return "用户名不能小于"+min+"个字符"; 
     }else if(data.length > max){  
        return "用户名不能大于"+max+"个字符"; 
     }else{
    	 return "";
     }
 }
 function un_checkUserName(val){//用户名是否存在
	 var r = "";
	 $.ajax({
		 async:false,
		 type: "post",               //数据发送方式
		 dataType: "json",           //接受数据格式   
		 url:"registerjson.htm?method=verify_username",
		 data:{"userName":val},
		 success:function(data){
			 if(data == false){
				 r = "用户名已存在";
			 }
		}});
	 return r;
 }
 //***********************用户名验证   END**************************
 //***********************  手机验证   **************************
 function mobile_validate(obj){
	//$("#save").removeAttr("disabled");
		rclick = 1;
	var val  = obj.val();
	if(mobile_notNUll(val) != ""){
		return mobile_notNUll(val);
	}
	if(mobile_number(val) != ""){
		return mobile_number(val);
	}
	if(mobile_format(val) != ""){
		return mobile_format(val);
	}
	if(mobile_exist(val) != ""){
		return mobile_exist(val);
	}
	return "";
 }
 function mobile_notNUll(data){//非空判断
     data = $.trim(data);  
     if(data.length < 1) {  
         return "手机号不能为空"; 
     } else  if(data == "输入手机号"){
    	 return "手机号不能为空"; 
     }else{
        return ""; 
     } 
 }
 function mobile_number(data){//手机号必须是数字
	 var re =  /^[0-9]*$/;  
     if(re.test(data)){			
			return "";
	 }else{
	 	    return "手机号必须是数字";
	 }
 }
 function mobile_format(data){//手机和格式
	var fag = /^1[3|4|5|8|7][0-9]\d{4,8}$/;
	if((fag.test(data)) && data.length==11){ 
		 return "";
	}else {
		  return "手机号格式不正确";
	}
 }
 function mobile_exist(data){
	 var r = "";
	 $.ajax({
		 async:false,
		 url:"registerjson.htm?method=verify_user_mobile",
		 data:{"mobile" : data},
		 success:function(data){
			if(jQuery.trim(data)=="false"){
				 r = "手机已被注册";
			} 
		}});
	 return r;
 }
 //***********************手机验证   END**************************
 //***********************密码验证    **************************
	function password_validate(obj){
		//$("#save").removeAttr("disabled");
		rclick = 1;
		var val  = obj.val();
		if(password_notNUll(val) != ""){
			return password_notNUll(val);
		}
		if(password_MinMaxLength(val,6,20) != ""){
			return password_MinMaxLength(val,6,20);
		}
		if(password_notSpace(val) != ""){
			return password_notSpace(val);
		}
		if(password_samplie(val) != ""){
			return password_samplie(val);
		}
		return "";
	}
	 function password_notNUll(data){//非空判断
	     data = $.trim(data);  
	     if(data.length < 1) {  
	         return "登录密码不能为空"; 
	     } else {  
	        return ""; 
	     } 
	 }
	 function password_notSpace(data){//登录密码前后不能有空格字符
			var first=data.charAt(0);
			var last=data.charAt(data.length-1);
		    if(first!=" "&&last!=" "){			
				return "";
			}else{
			    return "登录密码前后不能有空格字符";
			}
	 }
	 function password_samplie(data){
		var strongRegex = new RegExp("^(?=.{8,})(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*\\W).*$", "g");
	    var mediumRegex = new RegExp("^(?=.{6,})(((?=.*[A-Z])(?=.*[a-z]))|((?=.*[A-Z])(?=.*[0-9]))|((?=.*[a-z])(?=.*[0-9]))).*$", "g");
		if (strongRegex.test(data)) {
	   	 return "";
	    } else if (mediumRegex.test(data)) {
	   		return "";
	    }else{
	    	return "登录密码过于简单";
	    }
	 }
	 function password_MinMaxLength(data,min,max){//用户名的最小和最大的长度
		 if(data.length < min) {  
	         return "登录密码不能小于"+min+"个字符"; 
	     }else if(data.length > max){  
	        return "登录密码不能大于"+max+"个字符"; 
	     }else{
	    	 return "";
	     }
	 }	  
		  
 //***********************密码验证  END   **************************
 //*********************** 确认密码验证  **************************
		function repassword_validate(obj){
			//$("#save").removeAttr("disabled");
			rclick = 1;
			var val  = obj.val();
			if(repassword_notNUll(val) != ""){
				return repassword_notNUll(val);
			}
			if(repassword_equl(val) != ""){
				return repassword_equl(val);
			}
			return "";
		}
		 function repassword_notNUll(data){//非空判断
		     data = $.trim(data);  
		     if(data.length < 1) {  
		         return "密码不能为空"; 
		     } else {  
		        return ""; 
		     } 
		 }
		 function repassword_equl(data){
			 if($("#password").val() == data){
				 return "";
			 }else{
				 return "两次密码不一致";
			 }
		 }
 //*********************** 确认密码验证  END   **************************
 //*********************** 验证码验证  **************************
		function mobile_code_validate(obj){
			//$("#save").removeAttr("disabled");
			rclick = 1;
			var val  = obj.val();
			if(mobile_code_notNUll(val) != ""){
				return mobile_code_notNUll(val);
			}
			if(mobile_code_check(val) != ""){
				return mobile_code_check(val);
			}
			return "";
		}
		 function mobile_code_notNUll(data){//非空判断
		     data = $.trim(data);  
		     if(data.length < 1) {  
		         return "验证码不能为空"; 
		     } else {  
		        return ""; 
		     } 
		 }
		 function mobile_code_check(data){
			 var r ="";
			 $.ajax({
				 async:false,
				 url:"registerjson.htm?method=account_mobile_sms_validate",
				 data:{"mobile_verify_code":data,"mobile" : jQuery("#mobile").val()},
				 success:function(data){
					if($.trim(data)=="no"){
						r = "验证码错误";
					}
				}});
			 return r;
		 }		
 
 //*********************** 验证码验证  END   **************************
 //*********************** 地区验证 **************************
 function area_validate(obj){
	//$("#save").removeAttr("disabled");
		rclick = 1;
			var val  = obj.val();
			if(area_notNUll(val) != ""){
				return area_notNUll(val);
			}
			return "";
		}
 function area_notNUll(data){//非空判断
     data = $.trim(data);  
     if(data.length < 1) {  
         return "区域不能为空"; 
     } else {  
        return ""; 
     } 
 }
 //*********************** 地区验证  END   **************************
 //*********************** agree验证    **************************
  function agree_validate(obj){
	//$("#save").removeAttr("disabled");
		rclick = 1;
		if($(obj).prop("checked")){
			return "";
		}else{
			return "请接受用户协议";			
		}		 
	}
 
 //*********************** agree验证 END   **************************
 
 
var query_area=function(){
	if(jQuery("#card").val()==""||jQuery("#card").val()==null){
		jQuery("#temp").attr("style","display:none;");
		jQuery("#area_id").val("");
	}
}
 

// 注册成功的跳转首页的计时器
var count_time=3;
function go(){
	count_time--;
    if(count_time==0){
    	window.location.href="http://www.lovebuy.com.cn/";
    }
  }

//------------------------验证码倒计时--------------------
//发送短信
var count = 60;
var countdown=count;
var t;
var j = 0;
function mobile_sendmsg() {
	var mobile = $("#mobile").val();
	var res = mobile_validate($("#mobile"));
	if(res != ""){
		 error_labelUpdate($("#mobile"),"手机号格式有误");
		return ;
	}
	countdown--; 
	jQuery("#code_msg").attr("disabled", "disabled"); 
	jQuery("#code_msg").val("重新发送(" + countdown + ")"); 
		if(countdown == 57){//这里是异步所以计时器的时间不会影响
			jQuery.post("registerjson.htm?method=account_mobile_sms_register",
				    {"type":"mobile_sms_register","mobile":$("#mobile").val()},
				    function(data){
			    	data=jQuery.trim(data);
			    	if(data=="100"){
			    		
					}
					if(data=="200"){ 
						clearTimeout(t);
						jQuery("#code_msg").removeAttr("disabled");    
						jQuery("#code_msg").val("获取验证码"); 
						countdown = 60;
						$("#mobile").val(mobile);
					   alert("短信发送失败");
					}
					if(data=="300"){ 
						clearTimeout(t);
						jQuery("#code_msg").removeAttr("disabled");    
						jQuery("#code_msg").val("获取验证码"); 
						countdown = 60;
						$("#mobile").val(mobile);
					   alert("商城未开启短信服务");
					}
				  },"text");
		}
	if (countdown <= 0) { 
		jQuery("#code_msg").removeAttr("disabled");    
		jQuery("#code_msg").val("获取验证码"); 
		countdown = 60;
	} else { 
		t = setTimeout("mobile_sendmsg()",1000);
	} 
}

//是否是手机
function isMobil(s) {
  var patrn = /(^0{0,1}1[3|4|5|6|7|8|9][0-9]{9}$)/;
  if (!patrn.exec(s)) {
      return false;
  }
  return true;
}
//-------end---------------------------
    function toVaild(){
			if(rclick == 0){
				return false;
			}
    	    error_flag =  username_validate($("#userName"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#userName"),error_flag);
    	  		return false;
    	  	}
    	  	error_flag =  mobile_validate($("#mobile"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#mobile"),error_flag);
    	  		return false;
    	  	}
    	  	error_flag =  password_validate($("#password"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#password"),error_flag);
    	  		return false;
    	  	}
    	  	error_flag =  repassword_validate($("#repassword"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#repassword"),error_flag);
    	  		return false;
    	  	}
    		error_flag =  mobile_code_validate($("#mobile_code"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#mobile_code"),error_flag);
    	  		return false;
    	  	}
    	  	error_flag =  area_validate($("#area_id"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#area_id"),error_flag);
    	  		return false;
    	  	}
    	  	error_flag =  agree_validate($("#agree"));
    	  	if(error_flag != ""){
    	  		error_labelUpdate($("#agree"),error_flag);
    	  		return false;
    	  	}
       }

</script>

</head>
<body style="background:url(images/body_bg_2.jpg) no-repeat center top/cover;">
<div class="main">
	<div class="head_login">
	<div class="login_logo" style="margin-top:30px; margin-bottom:20px; padding-left:80px; position: relative; width:201px; float:left;"> 
		<a href="http://www.lovebuy.com.cn/index.html">
			<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/logo.gif"  border="0" />
		</a>
		<div class="logo_line" style="position: absolute; right:18px; bottom:2px;">
			<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/logo_line.png" />
		</div>
	</div>
	<div style="float:left; margin-top:42px;"><img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/slogan_05.png"/></div>
</div>
	<div class="index">
		<div class="index2">
			<div class="login_usertb">
				<div class="login_usertb_bgimg">
					<span class="imgcenter_span">
						<p><img src="images/login_image_10.png" width="490" height="480"/></p>
					</span>
				</div>
				<div class="login_user_bottom">
				<div class="login_titel">
					<b>注册爱购商城</b>
					<a href="login"><p>登录</p></a>
				</div>
					<div class="login_usrbotin">
						<div id="info_error" style="background-image:url(images/user_05.jpg);  background-repeat: no-repeat;width: 220px;display: inline-block;background-color: rgba(255, 0, 0, 0.1);line-height: 26px;padding-left: 26px;color:red"></div>
						<form id="theForm" name="theForm"   onsubmit="return toVaild();"  autocomplete="off" method="post" action="/registerSubmit" novalidate   >
							<table class="user_zc_table">
								<tbody>
									<tr>
									<input style="display:none"/><!-- for disable autocomplete on chrome -->
										<td><span class="login_user_input input_size">
											<label class="login_user_icons" for="userName">
												<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/user_03.png" />
											</label>
											<input type="text" id="userName" name="userName"  class="user_name" autocomplete="off" value="请输入用户名"/>
											</span>
											<!-- <label class="login_pass_point" for="userName" style="position:absolute; left:0px; top:0px; height:34px; line-height:34px; padding-left:36px; color:#ccc;">请输入用户名</label> -->
											<!-- <label  id="userName_lab"class="error uesr_error" for="userName" generated="true" ></label> -->
										</td>
											
									</tr>
									<tr>
										<td><span class="login_user_input input_size">
											<label class="login_user_icons"  for="mobile">
												<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/user_09.png" />
											</label>
											<input type="text" id="mobile" name="mobile" autocomplete="off" class="user_mobile"  value="输入手机号"/>
											</span>
											<!-- <label class="login_pass_point"  for="mobile" style="position:absolute; left:0px; top:0px; height:34px; line-height:34px; padding-left:36px; color:#ccc;">输入手机号</label> -->
											<!-- <label  class="error uesr_error" for="mobile" generated="true" ></label> -->
										</td>
									</tr>
									<tr>
										<td><span class="login_user_input input_size">
											<label class="login_user_icons" for="password" style="z-index:10;" >
												<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/user_11.png" />
											</label>
											<input type="text" class="valid user_password"  autocomplete="off"  style="left: 0px; top: 0px; position: absolute;"   id="pd" name="pd" value="输入密码"/>
											<input type="password" class="valid user_password"   autocomplete="off" id="password" name="password"/>
											</span>
											<!-- <label class="login_pass_point" for="password" style="position:absolute; left:0px; top:0px; height:34px; line-height:34px; padding-left:36px; color:#ccc;">输入密码</label> -->
											<!-- <label  class="error uesr_error" for="password" generated="true" style="z-index:10;" ></label> -->
										</td>
									</tr>
									<tr id="password_pro" style="display:none;">
										<td >
										<div class="login_nameu">密码强度：</div>
										<button id="strength_L" class="strength_L" type="submit" style=" width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;" disabled="disabled">弱</button>
										<button id="strength_M" class="strength_M" type="submit" style=" width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;" disabled="disabled">中</button>
										<button id="strength_H" class="strength_M" type="submit" style=" width:50px; height:20px; border:0px; background:#d4d4d4; color:#555; margin-right:4px;" disabled="disabled">强</button>
										</td>
									</tr>
									<tr>
										<td><span class="login_user_input input_size">
											<label class="login_user_icons" for="repassword" style="z-index:10;">
												<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/user_11.png" />
											</label>
											<input type="text" id="rpd" name="rpd"   autocomplete="off" style="left: 0px; top: 0px; position: absolute;"  class="user_repassword" value="再输入一次"/>
											<input type="password" id="repassword" name="repassword"  autocomplete="off"  class="user_repassword"/>
											</span>
											<!-- <label class="login_pass_point" for="repassword" style="position:absolute; left:0px; top:0px; height:34px; line-height:34px; padding-left:36px; color:#ccc;">再输入一次</label> -->
											<!-- <label style="z-index:10;" class="error uesr_error" for="repassword" generated="true" ></label> -->
										</td>
									</tr>
									<tr>
										<td><span class="login_user_input">
											<label class="login_user_icons"  for="mobile_code">
												<img src="http://www.lovebuy.com.cn/resources/style/system/front/default/images/user_13.png" />
											</label>
											<input type="text" style="text-transform: uppercase; width:120px;"  autocomplete="off" value="验证码" 
												id="mobile_code" name="mobile_code" class="user_mobilecode"/>
											</span>
											<!-- <label class="login_pass_point"  for="mobile_code" style="position:absolute; left:0px; top:0px; height:34px; line-height:34px; padding-left:36px; color:#ccc;">验证码</label> -->
											<!-- <label  class="error uesr_code_error" for="mobile_code" generated="true"></label> -->
											<input type="button" value="获取验证码" autocomplete="off" onclick="mobile_sendmsg();" id="code_msg" style=" background:url(http://www.lovebuy.com.cn/resources/style/system/front/default/images/code_msg_bg_14.png) no-repeat;  margin-left:10px; width:80px; height:34px; border:none; color:#fff;" />
										</td>
									</tr>
									<tr>
										<td colspan="1" class="td_select">
										<span>
											<select level="2" id="area1" name="area1">
												<option value="" selected="selected">请选择</option>
													<c:forEach var="area" items="${areas}">
													<option value="${area.id }">${area.areaName }</option> 
												</c:forEach>
											</select>
											<select level="3" style="display: none;" id="area2" name="area2">
											</select>
											<select level="4" style="display: none;" id="area3" name="area3">
											</select>
										</span>
										<!-- <span id="area_lab"><label  class="error uesr_select_error" for="area1" generated="true"></label></span> -->
										<input type="hidden" id="area_id" autocomplete="off" name="area_id"/>
										</td>
									</tr>
									<tr>
										<td class="login_nameu2"><span>
											<input type="checkbox" value="" id="agree" checked="checked" name="agree" >
											<label for="agree" style="color:#888"> &nbsp;我已阅读并同意&nbsp;</label>
											<a class="s_red" target="_blank" href="http://www.lovebuy.com.cn/doc_agree.htm">用户服务协议</a></span></td>
									</tr>
									<tr>
										<td colspan="2">
											<span class="login_user_btn_free">
											<input id="save" type="submit"  value="注&nbsp;&nbsp;&nbsp;&nbsp;册" class="login_userbtn" name="save"/>
											</span>
											<div class="success_tishi" style="display:none;">
											</div>
										</td>
									</tr>
								</tbody>
							</table>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</html>
