<%@page contentType="text/xml; charset=UTF-8" errorPage="errorpage.jsp" pageEncoding="UTF-8" %><?xml version="1.0" encoding="UTF-8" ?>
<%@taglib uri="regain-search.tld" prefix="search" %>
<search:contenttype contentType="text/xml; charset=UTF-8"/>
<search:check noIndexUrl="noindex.jsp" noQueryUrl="searchinput.jsp"/>  
<response>
	<query>
   		<lucene_query><search:stats_query escape="xml"/></lucene_query>
	</query>
	<count_documents><search:stats_numdocs escape="xml"/></count_documents>
	<results>
		<count_hits><search:stats_total escape="xml"/></count_hits>
		<from><search:stats_from escape="xml"/></from>
		<to><search:stats_to escape="xml"/></to>
		<queryTime><search:stats_searchtime escape="xml"/></queryTime>
		   
<search:list msgNoResults="">
		<result>
			<link_url><search:hit_link onlyUrl="true" escape="xml"/></link_url>
			<filename><search:hit_filename escape="xml"/></filename>
			<title><search:hit_field field="title" escape="xml"/></title>
			<relevance><search:hit_score escape="xml"/></relevance>
			<summary>
<search:hit_field field="summary" highlight="false" escape="xml"/>
			</summary>
			<content>
<search:hit_field field="content" highlight="false" escape="xml"/>
			</content>
			<mimetype><search:hit_field field="mimetype" escape="xml"/></mimetype>
			<filesize><search:hit_field field="size" escape="xml"/></filesize>
			<filesize_human><search:hit_size escape="xml"/></filesize_human>
			<lastModified><search:hit_field field="last-modified" escape="xml"/></lastModified>
		</result>
</search:list>
	</results>
</response>