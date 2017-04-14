
<%@ page language="java"  session="false" %>


<%
final String queryString = request.getQueryString();
final String url = "http://www.lovebuy.com.cn";
response.sendRedirect(response.encodeURL(url));%>
