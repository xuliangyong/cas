
<%@ page language="java"  session="false" %>


<%
final String queryString = request.getQueryString();
final String service = "http://www.lovebuy.com.cn";
final String url = "http://sso.lovebuy.com.cn/login" + (queryString != null ? "?" + queryString : "?service="+response.encodeURL(service));
response.sendRedirect(response.encodeURL(url));%>