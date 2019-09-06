<%
/**
 * Copyright (c) 2000-2012 Liferay, Inc. All rights reserved.
 *
 * This library is free software; you can redistribute it and/or modify it under
 * the terms of the GNU Lesser General Public License as published by the Free
 * Software Foundation; either version 2.1 of the License, or (at your option)
 * any later version.
 *
 * This library is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
 * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
 * details.
 */
%>

<%@ taglib uri="http://java.sun.com/portlet_2_0" prefix="portlet" %>
<%@ taglib uri="http://liferay.com/tld/aui" prefix="aui" %>
<%@ page import="com.liferay.portal.util.PortalUtil" %>
<%@ page import="java.util.ArrayList" %>

<portlet:defineObjects />

<h3> External Link Disclaimer</h3>

<%
	String[] INVALID_CHARS = new String[] {
		"\"", "'", "&#034;", "&#039;","<",">","3C","3E"
	};	

	//Start create whiteList
	ArrayList<String> urlWhiteList = new ArrayList<String>();
	urlWhiteList.add("http://www.hl7.org/oid/index.cfm");
	urlWhiteList.add("http://www.github.com/MeasureAuthoringTool");
	urlWhiteList.add("http://help.github.com/privacy-policy/");
	urlWhiteList.add("http://www.github.com");
	urlWhiteList.add("http://checkstyle.sourceforge.net");
	urlWhiteList.add("http://pmd.sourceforge.net");
	urlWhiteList.add("http://www.adobe.com/reader");
	urlWhiteList.add("http://get.adobe.com/reader/");
	urlWhiteList.add("http://www.adobe.com/accessibility/index.html");
	urlWhiteList.add("http://www.microsoft.com/downloads/en/details.aspx?familyid=1cd6acf9-ce06-4e1c-8dcf-f33f669dbc3a");	
	urlWhiteList.add("http://www.usa.gov/optout-instructions.shtml");
	urlWhiteList.add("http://www.youtube.com/watch?v=LSnMdAARTBY&feature=c4-overview&list=UUhHTRPxz8awulGaTMh3SAkA");
	urlWhiteList.add("http://www.nlm.nih.gov/databases/umls.html");
	urlWhiteList.add("http://apps2.nlm.nih.gov/mainweb/siebel/nlm/index.cfm");
	urlWhiteList.add("https://vsac.nlm.nih.gov/");
	urlWhiteList.add("https://uts.nlm.nih.gov/license.html");
	urlWhiteList.add("http://www.nlm.nih.gov/research/umls/support.html");
	urlWhiteList.add("http://youtu.be/FZvRrTrPflE");
	urlWhiteList.add("http://www.youtube.com/watch?v=FZvRrTrPflE&feature=youtu.be");
	urlWhiteList.add("https://bonnie.healthit.gov");
	
	urlWhiteList.add("http://youtu.be/9NlIVZ3sOYg");
	urlWhiteList.add("http://youtu.be/giU1fNczz4U");
	urlWhiteList.add("http://youtu.be/Q7RhH3UL6Q4");
	urlWhiteList.add("http://youtu.be/BhjTViDGIhY");
	urlWhiteList.add("https://www.youtube.com/watch?v=2xE9giXCQDU");
	urlWhiteList.add("https://www.youtube.com/watch?v=jQKLQ4e_Qog");
	urlWhiteList.add("https://youtu.be/NPX-23AWq5Q");
	urlWhiteList.add("https://youtu.be/m--GlbQsAHc");
	
	urlWhiteList.add("http://www.symantec.com/about/profile/policies/legal.jsp");
	urlWhiteList.add("https://youtu.be/s0HonhcTnAY");
	urlWhiteList.add("https://youtu.be/AyJrsN7WBHs");
	
	urlWhiteList.add("https://youtu.be/xz9cdR0eSwo");
	urlWhiteList.add("https://youtu.be/s_bHllHsE4c");
	urlWhiteList.add("https://youtu.be/EH5LG9oPmrk");
	urlWhiteList.add("https://youtu.be/lGvJmm2c_Mk");
	urlWhiteList.add("https://youtu.be/xiMBfPmDTow");
	
	urlWhiteList.add("https://youtu.be/p_2S22_rAYE");
	urlWhiteList.add("https://youtu.be/kXmD-llTwnA");
	urlWhiteList.add("https://telligen500.webex.com/telligen500/onstage/g.php?MTID=e40e8032f55713b5d0b35df14d163da0d");
	urlWhiteList.add("https://telligen.webex.com/telligen/onstage/g.php?MTID=e23d5db0642c4e975f0b716a93eb1b3e6");
	
	urlWhiteList.add("https://youtu.be/ptb3vVofIjY");
	
	//End create whiteList
	
	HttpServletRequest sRequest = PortalUtil.getHttpServletRequest(renderRequest);
	String linkPage = PortalUtil.getOriginalServletRequest(sRequest).getParameter("linkPage");
	
	String displayLink = linkPage;
	if(linkPage.length() > 50){
		displayLink = linkPage.substring(0,50) + "....";
	}
	
	//Check if linkPage URL present in whitelist.
	boolean isValidURL = false;
	
	if(urlWhiteList.contains(linkPage)){
		isValidURL = true;
	}
	
	//check for invalid characters in URL
	for(int i=0; i <INVALID_CHARS.length; i++){
		if(linkPage.contains(INVALID_CHARS[i])){
			linkPage = "";
			displayLink="";
			break;
		}
	}
%>


<p>
You are leaving the Measure Authoring Tool Web site and entering another Web site.
The Measure Authoring Tool cannot attest to the accuracy of information provided by linked sites. 
You will be subject to the destination site's Privacy Policy when you leave the Measure Authoring Tool Website.
</p>

<% if(!isValidURL) {%>
	<span class="portlet-msg-error" title="<%= linkPage %>">URL: <%= displayLink %> is not an approved link.</span>
<%  
	} else { 
		
%>
	<p title="<%= linkPage %>">Would you like to continue to <b><%= displayLink %></b>:</p>
	<p style=margin-top:25px;>
		<a href="<%= linkPage %>" style="padding: 10px 15px;background: #4479BA;color: #FFF;">Yes</a>&nbsp;&nbsp;&nbsp;&nbsp;
		<a href="mat-home" style="padding: 10px 15px;background: #4479BA;color: #FFF;">No</a>
	</p>
<%  
	} 
%>
<br/><br/>
