<%--
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
--%>

<%@ include file="/init.jsp" %>

<%
String title = LocalizationUtil.getPreferencesValue(preferences, "title", themeDisplay.getLanguageId());
String description = LocalizationUtil.getPreferencesValue(preferences, "description", themeDisplay.getLanguageId());
boolean requireCaptcha = GetterUtil.getBoolean(preferences.getValue("requireCaptcha", StringPool.BLANK));
String successURL = preferences.getValue("successURL", StringPool.BLANK);
%>

<portlet:actionURL var="saveDataURL">
	<portlet:param name="<%= ActionRequest.ACTION_NAME %>" value="saveData" />
</portlet:actionURL>

<aui:form action="<%= saveDataURL %>" method="post" name="fm" enctype="multipart/form-data">
	<c:if test="<%= Validator.isNull(successURL) %>">
		<div id="<portlet:namespace/>validationError"><aui:input name="redirect" type="hidden" value="<%= currentURL %>" /></div>
	</c:if>

	<aui:fieldset label="<%= HtmlUtil.escape(title) %>">
		<em class="description"><%= HtmlUtil.escape(description) %></em>

		<div tabindex="0"><liferay-ui:success key="success" message="the-form-information-was-sent-successfully"/></div>
		
		<div tabindex="0" id="errordiv">
		<%
		int g = 1;
		String fieldName_top = "field" + g;
		String fieldLabel_top = LocalizationUtil.getPreferencesValue(preferences, "fieldLabel" + g, themeDisplay.getLanguageId());
		String optionalErrorFieldNames = "";
		while ((g == 1) || Validator.isNotNull(fieldLabel_top)) {
			String fieldValidationScript_top = preferences.getValue("fieldValidationScript" + g, StringPool.BLANK);
			String fieldValidationErrorMessage_top = preferences.getValue("fieldValidationErrorMessage" + g, StringPool.BLANK);
			boolean fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + g, false);
		%>
		
		<!-- Changing the line below to default to VALIDATION_SCRIPT_ENABLED = true every time. -->
		<!-- After spending some time I cant seem to find how to turn VALIDATION_SCRIPT_ENABLED to true/false anymore. -->
		<!-- The 'true' in the line below used to be 'PortletPropsValues.VALIDATION_SCRIPT_ENABLED' -->
			
		<c:if test="<%= true %>">
			<liferay-ui:error key='<%= "error" + fieldLabel_top %>' message="<%= fieldValidationErrorMessage_top %>" />
		</c:if>
		<c:if test="<%= !fieldOptional %>">
			<%optionalErrorFieldNames += fieldLabel_top +","; %>
		</c:if>
		
		<%
			g++;
			fieldName_top = "field" + g;
			fieldLabel_top = LocalizationUtil.getPreferencesValue(preferences, "fieldLabel" + g, themeDisplay.getLanguageId());
		}
		%>
		<div class="aui-helper-hidden" id="<portlet:namespace/>fieldOptionalError">
			<span class="portlet-msg-error">The following field(s) are mandatory: <span id="<portlet:namespace/>reqdFields"></span></span>
		</div>
		</div>
		
		<liferay-ui:error exception="<%= CaptchaMaxChallengesException.class %>" message="maximum-number-of-captcha-attempts-exceeded" />
		<liferay-ui:error exception="<%= CaptchaTextException.class %>" message="text-verification-failed" />
		<liferay-ui:error key="error" message="an-error-occurred-while-sending-the-form-information" />

		<c:if test='<%= SessionErrors.contains(renderRequest, "validationScriptError") %>'>
			<liferay-util:include page="/script_error.jsp" />
		</c:if>

		<%
		int i = 1;

		String fieldName = "field" + i;
		String fieldLabel = LocalizationUtil.getPreferencesValue(preferences, "fieldLabel" + i, themeDisplay.getLanguageId());
		boolean fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + i, false);
		String fieldValue = ParamUtil.getString(request, fieldName);
		
		while ((i == 1) || Validator.isNotNull(fieldLabel)) {
			String fieldType = preferences.getValue("fieldType" + i, "text");
			String fieldOptions = LocalizationUtil.getPreferencesValue(preferences, "fieldOptions" + i, themeDisplay.getLanguageId());
			String fieldValidationScript = preferences.getValue("fieldValidationScript" + i, StringPool.BLANK);
			String fieldValidationErrorMessage = preferences.getValue("fieldValidationErrorMessage" + i, StringPool.BLANK);
		%>
 
		
			

			<c:choose>
				<c:when test='<%= fieldType.equals("paragraph") %>'>
					<p class="lfr-webform" id="<portlet:namespace /><%= fieldName %>"><%= HtmlUtil.escape(fieldOptions) %></p>
				</c:when>
				<c:when test='<%= fieldType.equals("text") %>'>
					<aui:input cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label='<%= HtmlUtil.escape(fieldLabel)+":" + (fieldOptional ? StringPool.BLANK : "  *") %>' name="<%= fieldName %>" value="<%= HtmlUtil.escape(fieldValue) %>" size="50"/>
				</c:when>
				<c:when test='<%= fieldType.equals("textarea") %>'>
					<aui:input cssClass='<%= "lfr-textarea-container" + (fieldOptional ? "optional" : StringPool.BLANK) %>' label="<%= HtmlUtil.escape(fieldLabel)+":" + (fieldOptional ? StringPool.BLANK : "  *") %>" name="<%= fieldName %>" type="textarea" value="<%= HtmlUtil.escape(fieldValue) %>" wrap="soft" />
				</c:when>
				<c:when test='<%= fieldType.equals("checkbox") %>'>
					<aui:input cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" type="checkbox" value="<%= GetterUtil.getBoolean(fieldValue) %>" />
				</c:when>
				<c:when test='<%= fieldType.equals("radio") %>'>
					<aui:field-wrapper cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>">

						<%
						for (String fieldOptionValue : WebFormUtil.split(fieldOptions)) {
						%>

							<aui:input checked="<%= fieldValue.equals(fieldOptionValue) %>" label="<%= HtmlUtil.escape(fieldOptionValue) %>" name="<%= fieldName %>" type="radio" value="<%= HtmlUtil.escape(fieldOptionValue) %>" />

						<%
						}
						%>

					</aui:field-wrapper>
				</c:when>
				<c:when test='<%= fieldType.equals("options") %>'>

					<%
					String[] options = WebFormUtil.split(fieldOptions);
					%>

					<aui:select cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>">

						<%
						for (String fieldOptionValue : WebFormUtil.split(fieldOptions)) {
						%>

							<aui:option selected="<%= fieldValue.equals(fieldOptionValue) %>" value="<%= HtmlUtil.escape(fieldOptionValue) %>"><%= HtmlUtil.escape(fieldOptionValue) %></aui:option>

						<%
						}
						%>

					</aui:select>
				</c:when>
				<c:when test='<%= fieldType.equals("file") %>'>
					<aui:input cssClass='<%= fieldOptional ? "optional" : StringPool.BLANK %>' label="<%= HtmlUtil.escape(fieldLabel) %>" name="<%= fieldName %>" type="file" value="<%= HtmlUtil.escape(fieldValue) %>"/>
				</c:when>
			</c:choose>

		<%
			i++;

			fieldName = "field" + i;
			fieldLabel = LocalizationUtil.getPreferencesValue(preferences, "fieldLabel" + i, themeDisplay.getLanguageId());
			fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + i, false);
			fieldValue = ParamUtil.getString(request, fieldName);
		}
		%>

		<c:if test="<%= requireCaptcha %>">
			<portlet:resourceURL var="captchaURL">
				<portlet:param name="<%= Constants.CMD %>" value="captcha" />
			</portlet:resourceURL>

			<liferay-ui:captcha url="<%= captchaURL %>" />
		</c:if>

		<aui:button onClick="" type="submit" value="send" />
		<br/><br/>
	</aui:fieldset>
</aui:form>

<aui:script use="aui-base,selector-css3">
	var form = A.one('#<portlet:namespace />fm');

	if (form) {
		form.on(
			'submit',
			function(event) {
				var keys = [];

				var fieldLabels = {};
				var fieldOptional = {};
				var fieldValidationErrorMessages = {};
				var fieldValidationFunctions = {};
				var fieldsMap = {};

				<%
				int i = 1;

				String fieldName = "field" + i;
				String fieldLabel = preferences.getValue("fieldLabel" + i, StringPool.BLANK);

				while ((i == 1) || Validator.isNotNull(fieldLabel)) {
					boolean fieldOptional = PrefsParamUtil.getBoolean(preferences, request, "fieldOptional" + i, false);
					String fieldType = preferences.getValue("fieldType" + i, "text");
					String fieldValidationScript = preferences.getValue("fieldValidationScript" + i, StringPool.BLANK);
					String fieldValidationErrorMessage = preferences.getValue("fieldValidationErrorMessage" + i, StringPool.BLANK);
				%>

					var key = "<%= fieldName %>";

					keys[<%= i %>] = key;

					fieldLabels[key] = "<%= HtmlUtil.escape(fieldLabel) %>";
					fieldValidationErrorMessages[key] = "<%= fieldValidationErrorMessage %>";

					function fieldValidationFunction<%= i %>(currentFieldValue, fieldsMap) {
						<c:choose>
							<c:when test="<%= Validator.isNotNull(fieldValidationScript) %>">
								<%= fieldValidationScript %>
							</c:when>
							<c:otherwise>
								return true;
							</c:otherwise>
						</c:choose>
					};

					fieldOptional[key] = <%= fieldOptional %>;
					fieldValidationFunctions[key] = fieldValidationFunction<%= i %>;

					<c:choose>
						<c:when test='<%= fieldType.equals("radio") %>'>
							var radioButton = A.one('input[name=<portlet:namespace />field<%= i %>]:checked');

							fieldsMap[key] = '';

							if (radioButton) {
								fieldsMap[key] = radioButton.val();
							}
						</c:when>
						<c:otherwise>
							var inputField = A.one('#<portlet:namespace />field<%= i %>');

							fieldsMap[key] = (inputField && inputField.val()) || '';
						</c:otherwise>
					</c:choose>

				<%
					i++;

					fieldName = "field" + i;
					fieldLabel = preferences.getValue("fieldLabel" + i, "");
				}
				%>

				var validationErrors = false;
				var missingFields = "";
				for (var i = 1; i < keys.length; i++) {
					var key = keys [i];					
					var currentFieldValue = fieldsMap[key];
																		
					if (!fieldOptional[key] && currentFieldValue.match(/^\s*$/)) {
						validationErrors = true;
						missingFields = missingFields.concat(fieldLabels[key]).concat(",");
					}
				}
				
				if (validationErrors) {
					event.halt();
					event.stopImmediatePropagation();
					document.getElementById('errordiv').focus();
					A.all('.portlet-msg-success').hide();
					var optionalFieldError = A.one('#<portlet:namespace />fieldOptionalError');
					if (optionalFieldError) {
						missingFields = missingFields.substr(0,missingFields.length-1);
						document.getElementById("<portlet:namespace/>reqdFields").innerHTML = missingFields;
						optionalFieldError.show();
					}
				}else{
					var optionalFieldError = A.one('#<portlet:namespace />fieldOptionalError');
										
					if (optionalFieldError) {
						optionalFieldError.hide();
						document.getElementById("<portlet:namespace/>reqdFields").innerHTML = "";
					}
				}
			}
		);
	}
</aui:script>