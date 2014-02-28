<%--
/**
 * Copyright (c) 2000-2013 Liferay, Inc. All rights reserved.
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

<%@ include file="/html/portlet/init.jsp" %>

<%@ page import="com.liferay.portal.kernel.search.Document" %><%@
page import="com.liferay.portal.kernel.search.FacetedSearcher" %><%@
page import="com.liferay.portal.kernel.search.FolderSearcher" %><%@
page import="com.liferay.portal.kernel.search.HitsOpenSearchImpl" %><%@
page import="com.liferay.portal.kernel.search.KeywordsSuggestionHolder" %><%@
page import="com.liferay.portal.kernel.search.OpenSearch" %><%@
page import="com.liferay.portal.kernel.search.OpenSearchUtil" %><%@
page import="com.liferay.portal.kernel.search.facet.AssetEntriesFacet" %><%@
page import="com.liferay.portal.kernel.search.facet.Facet" %><%@
page import="com.liferay.portal.kernel.search.facet.ScopeFacet" %><%@
page import="com.liferay.portal.kernel.search.facet.collector.FacetCollector" %><%@
page import="com.liferay.portal.kernel.search.facet.collector.TermCollector" %><%@
page import="com.liferay.portal.kernel.search.facet.config.FacetConfiguration" %><%@
page import="com.liferay.portal.kernel.search.facet.config.FacetConfigurationUtil" %><%@
page import="com.liferay.portal.kernel.search.facet.util.FacetFactoryUtil" %><%@
page import="com.liferay.portal.kernel.search.facet.util.RangeParserUtil" %><%@
page import="com.liferay.portal.kernel.util.DateFormatFactoryUtil" %><%@
page import="com.liferay.portal.kernel.xml.Element" %><%@
page import="com.liferay.portal.kernel.xml.SAXReaderUtil" %><%@
page import="com.liferay.portal.security.permission.comparator.ModelResourceComparator" %><%@
page import="com.liferay.portal.service.PortletLocalServiceUtil" %><%@
page import="com.liferay.portlet.asset.NoSuchCategoryException" %><%@
page import="com.liferay.taglib.aui.ScriptTag" %><%@
page import="com.liferay.util.PropertyComparator" %>

<%@ page import="java.util.Comparator" %><%@
page import="java.util.LinkedList" %>

<%
PortalPreferences portalPreferences = PortletPreferencesFactoryUtil.getPortalPreferences(request);

boolean advancedConfiguration = GetterUtil.getBoolean(portletPreferences.getValue("advancedConfiguration", null));

int collatedSpellCheckResultDisplayThreshold = GetterUtil.getInteger(portletPreferences.getValue("collatedSpellCheckResultDisplayThreshold", null), PropsValues.INDEX_SEARCH_COLLATED_SPELL_CHECK_RESULT_SCORES_THRESHOLD);

if (collatedSpellCheckResultDisplayThreshold < 0) {
	collatedSpellCheckResultDisplayThreshold = PropsValues.INDEX_SEARCH_COLLATED_SPELL_CHECK_RESULT_SCORES_THRESHOLD;
}

boolean collatedSpellCheckResultEnabled = GetterUtil.getBoolean(portletPreferences.getValue("collatedSpellCheckResultEnabled", null), PropsValues.INDEX_SEARCH_COLLATED_SPELL_CHECK_RESULT_ENABLED);
boolean dlLinkToViewURL = false;
boolean displayAssetCategoriesFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayAssetCategoriesFacet", null), true);
boolean displayAssetTagsFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayAssetTagsFacet", null), true);
boolean displayAssetTypeFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayAssetTypeFacet", null), true);
boolean displayFolderFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayFolderFacet", null), true);
boolean displayMainQuery = GetterUtil.getBoolean(portletPreferences.getValue("displayMainQuery", null));
boolean displayModifiedRangeFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayModifiedRangeFacet", null), true);
boolean displayOpenSearchResults = GetterUtil.getBoolean(portletPreferences.getValue("displayOpenSearchResults", null));

boolean displayResultsInDocumentForm = GetterUtil.getBoolean(portletPreferences.getValue("displayResultsInDocumentForm", null));

if (!permissionChecker.isCompanyAdmin()) {
	displayResultsInDocumentForm = false;
}

boolean displayScopeFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayScopeFacet", null), true);
boolean displayUserFacet = GetterUtil.getBoolean(portletPreferences.getValue("displayUserFacet", null), true);
boolean includeSystemPortlets = false;
boolean queryIndexingEnabled = GetterUtil.getBoolean(portletPreferences.getValue("queryIndexingEnabled", null), PropsValues.INDEX_SEARCH_QUERY_INDEXING_ENABLED);

int queryIndexingThreshold = GetterUtil.getInteger(portletPreferences.getValue("queryIndexingThreshold", null), PropsValues.INDEX_SEARCH_QUERY_INDEXING_THRESHOLD);

if (queryIndexingThreshold < 0) {
	queryIndexingThreshold = PropsValues.INDEX_SEARCH_QUERY_INDEXING_THRESHOLD;
}

int querySuggestionsDisplayThreshold = GetterUtil.getInteger(portletPreferences.getValue("querySuggestionsDisplayThreshold", null), PropsValues.INDEX_SEARCH_QUERY_SUGGESTION_SCORES_THRESHOLD);

if (querySuggestionsDisplayThreshold < 0) {
	querySuggestionsDisplayThreshold = PropsValues.INDEX_SEARCH_QUERY_SUGGESTION_SCORES_THRESHOLD;
}

boolean querySuggestionsEnabled = GetterUtil.getBoolean(portletPreferences.getValue("querySuggestionsEnabled", null), PropsValues.INDEX_SEARCH_QUERY_SUGGESTION_ENABLED);

int querySuggestionsMax = GetterUtil.getInteger(portletPreferences.getValue("querySuggestionsMax", null), PropsValues.INDEX_SEARCH_QUERY_SUGGESTION_MAX);

if (querySuggestionsMax <= 0) {
	querySuggestionsMax = PropsValues.INDEX_SEARCH_QUERY_SUGGESTION_MAX;
}

String searchConfiguration = portletPreferences.getValue("searchConfiguration", StringPool.BLANK);

if (!advancedConfiguration && Validator.isNull(searchConfiguration)) {
    String configOverride = "{facets: [{className: 'com.liferay.portal.kernel.search.facet.ScopeFacet',data: {frequencyThreshold: 1,maxTerms: 10,showAssetCount: true},displayStyle: 'scopes',fieldName: 'groupId',label: 'site',order: 'OrderHitsDesc',static: false,weight: 1.6},{className: 'com.liferay.portal.kernel.search.facet.AssetEntriesFacet',data: {frequencyThreshold: 1,values: ['com.liferay.portal.model.User','com.liferay.portlet.bookmarks.model.BookmarksEntry','com.liferay.portlet.bookmarks.model.BookmarksFolder','com.liferay.portlet.blogs.model.BlogsEntry','com.liferay.portlet.documentlibrary.model.DLFileEntry','com.liferay.portlet.documentlibrary.model.DLFolder','com.liferay.portlet.journal.model.JournalArticle','com.liferay.portlet.journal.model.JournalFolder','com.liferay.portlet.messageboards.model.MBMessage','com.liferay.portlet.wiki.model.WikiPage','com.arcusys.learn.scorm.manifest.model.Manifest']},displayStyle: 'asset_entries',fieldName: 'entryClassName',label: 'asset-type',order: 'OrderHitsDesc',static: false,weight: 1.5},{className: 'com.liferay.portal.kernel.search.facet.MultiValueFacet',data: {displayStyle: 'list',frequencyThreshold: 1,maxTerms: 10,showAssetCount: true},displayStyle: 'asset_tags',fieldName: 'assetTagNames',label: 'tag',order: 'OrderHitsDesc',static: false,weight: 1.4},{className: 'com.liferay.portal.kernel.search.facet.MultiValueFacet',data: {displayStyle: 'list',frequencyThreshold: 1,maxTerms: 10,showAssetCount: true},displayStyle: 'asset_categories',fieldName: 'assetCategoryIds',label: 'category',order: 'OrderHitsDesc',static: false,weight: 1.3},{className: 'com.liferay.portal.kernel.search.facet.MultiValueFacet',data: {frequencyThreshold: 1,maxTerms: 10,showAssetCount: true},displayStyle: 'folders',fieldName: 'folderId',label: 'folder',order: 'OrderHitsDesc',static: false,weight: 1.2},{className: 'com.liferay.portal.kernel.search.facet.MultiValueFacet',data: {frequencyThreshold: 1,maxTerms: 10,showAssetCount: true},displayStyle: 'users',fieldName: 'userId',label: 'user',order: 'OrderHitsDesc',static: false,weight: 1.1},{className: 'com.liferay.portal.kernel.search.facet.ModifiedFacet',data: {frequencyThreshold: 0,ranges: [{label:'past-hour',range:'[past-hour TO *]'},{label:'past-24-hours',range:'[past-24-hours TO *]'},{label:'past-week',range:'[past-week TO *]'},{label:'past-month',range:'[past-month TO *]'},{label:'past-year',range:'[past-year TO *]'}]},displayStyle: 'modified',fieldName: 'modified',label: 'modified',order: 'OrderHitsDesc',static: false,weight: 1.0}]}";
	searchConfiguration = configOverride;//ContentUtil.get(PropsValues.SEARCH_FACET_CONFIGURATION);
}

boolean viewInContext = GetterUtil.getBoolean(portletPreferences.getValue("viewInContext", null), true);
%>

<%@ include file="/html/portlet/search/init-ext.jsp" %>

<%!
private String _buildAssetCategoryPath(AssetCategory assetCategory, Locale locale) throws Exception {
	List<AssetCategory> assetCategories = assetCategory.getAncestors();

	if (assetCategories.isEmpty()) {
		return HtmlUtil.escape(assetCategory.getName());
	}

	Collections.reverse(assetCategories);

	StringBundler sb = new StringBundler(assetCategories.size() * 2 + 1);

	for (AssetCategory curAssetCategory : assetCategories) {
		sb.append(HtmlUtil.escape(curAssetCategory.getTitle(locale)));
		sb.append(" &raquo; ");
	}

	sb.append(HtmlUtil.escape(assetCategory.getName()));

	return sb.toString();
}

private String _checkViewURL(ThemeDisplay themeDisplay, String viewURL, String currentURL, boolean inheritRedirect) {
	if (Validator.isNotNull(viewURL) && viewURL.startsWith(themeDisplay.getURLPortal())) {
		viewURL = HttpUtil.setParameter(viewURL, "inheritRedirect", inheritRedirect);

		if (!inheritRedirect) {
			viewURL = HttpUtil.setParameter(viewURL, "redirect", currentURL);
		}
	}

	return viewURL;
}

private PortletURL _getViewFullContentURL(HttpServletRequest request, ThemeDisplay themeDisplay, String portletId, Document document) throws Exception {
	long groupId = GetterUtil.getLong(document.get(Field.GROUP_ID));

	if (groupId == 0) {
		Layout layout = themeDisplay.getLayout();

		groupId = layout.getGroupId();
	}

	long scopeGroupId = GetterUtil.getLong(document.get(Field.SCOPE_GROUP_ID));

	if (scopeGroupId == 0) {
		scopeGroupId = themeDisplay.getScopeGroupId();
	}

	long plid = LayoutConstants.DEFAULT_PLID;

	Layout layout = (Layout)request.getAttribute(WebKeys.LAYOUT);

	if (layout != null) {
		plid = layout.getPlid();
	}

	if (plid == 0) {
		plid = LayoutServiceUtil.getDefaultPlid(groupId, scopeGroupId, portletId);
	}

	PortletURL portletURL = PortletURLFactoryUtil.create(request, portletId, plid, PortletRequest.RENDER_PHASE);

	portletURL.setPortletMode(PortletMode.VIEW);
	portletURL.setWindowState(WindowState.MAXIMIZED);

	return portletURL;
}
%>