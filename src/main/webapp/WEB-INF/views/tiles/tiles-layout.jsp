<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="tiles" uri="http://tiles.apache.org/tags-tiles"  %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core_rt" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
  <head>
	<meta charset="UTF-8">
	<title>main</title>
  </head>
  <body>
		<div id="header">
			<tiles:insertAttribute name="header" />
		</div>
		<div id="body">
			<tiles:insertAttribute name="body" />
		</div>
  </body>
</html>