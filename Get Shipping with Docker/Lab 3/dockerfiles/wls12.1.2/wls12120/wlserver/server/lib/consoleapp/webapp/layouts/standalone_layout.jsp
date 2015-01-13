<jsp:root version="2.0"
    xmlns:jsp="http://java.sun.com/JSP/Page"
    xmlns:c="http://java.sun.com/jsp/jstl/core"
    xmlns:template="http://beehive.apache.org/netui/tags-template-1.0"
    xmlns:html="http://struts.apache.org/tags-html"
    xmlns:fmt="http://java.sun.com/jsp/jstl/fmt"
    xmlns:wl="/WEB-INF/console-html.tld">
<jsp:directive.page session="false" />
<jsp:directive.page isELIgnored="false" />

<!--
  Template used for standalone pages. That is to say pages outside the 
  console Portal. 
  
  This layout is not to be used for normal Portal pages because it includes
  the complete html page including head and body etc.
  
-->

<jsp:scriptlet>
  <![CDATA[
      response.setHeader("Cache-Control","no-cache"); //HTTP 1.1
      response.setHeader("Pragma","no-cache"); //HTTP 1.0
      response.setDateHeader ("Expires", 0); //prevents caching at the proxy server
      response.setContentType("text/html; charset=UTF-8");
  ]]>
</jsp:scriptlet>

<wl:setBundle basename="global" var="current_bundle" scope="page" />

<c:set var="contextPath" scope="page"><jsp:expression>request.getContextPath()</jsp:expression></c:set>

<![CDATA[<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
]]>
<html>
<head>
<![CDATA[<meta http-equiv="content-type" content="text/html; charset=UTF-8" >]]>
    <template:includeSection name="headMeta"/>
<title><template:includeSection name="headTitle"/></title>
<![CDATA[
<link rel="stylesheet" type="text/css" href="${contextPath}/framework/skins/wlsconsole/css/general.css" >
<link rel="stylesheet" type="text/css" href="${contextPath}/framework/skins/wlsconsole/css/window.css" >
<link rel="stylesheet" type="text/css" href="${contextPath}/css/login.css" >
]]>
    <template:includeSection name="headExtra"/>
</head>
<body>
    <div id="header">
      <div id="console-header-logo">
        <div>
        <fmt:message key="logo.alt" bundle="${current_bundle}" var="logoAlt" scope="page" />
          <html:img StyleId="logo" src="${contextPath}/framework/skins/wlsconsole/images/OracleLogo.png" alt="${logoAlt} " />
          <span id="product-brand-name"><fmt:message key='product.brand.name' bundle="${current_bundle}"/></span>
          <span id="product-name"><fmt:message key='product.name' bundle="${current_bundle}"/></span>
        </div>
      </div>
    </div>
    <div id="message">
      <div class="wlsc-frame">
        <div class="top">
          <div><div>&amp;nbsp;</div></div>
        </div>
        <div class="middle">
          <div class="r">
            <div class="c"><div class="c2">
              <div class="wlsc-titlebar">
                <div class="float-container">
                  <div class="wlsc-titlebar-title-panel">
                    <h1><template:includeSection name="titlebarText"/></h1>
                  </div>
                  <div class="wlsc-titlebar-button-panel">&amp;nbsp;</div>
                </div>
              </div>
              <div class="wlsc-window-content">
                <div class="content">

                <template:includeSection name="content"/>
                </div>
              </div>
            </div></div>
          </div>
        </div>
        <div class="bottom">
          <div><div>&amp;nbsp;</div></div>
        </div>
      </div>
    </div>
</body>
</html>
</jsp:root>
