<?xml version="1.0"?>
<project name="SF-TAG-HG-CODE" default="all" xmlns:hlm="http://www.nokia.com/helium">

<#assign target_depends = "" />
<#assign count = 0 />

<#list data as pkg_detail>
    <target name="sf-tag-hg-code-${count}">
        <sequential>
          <hlm:scm verbose="true" scmUrl="scm:hg:${pkg_detail.source}">
            <hlm:tag basedir="${ant['sf.spec.job.drive']}${pkg_detail.dst}" name="${ant['sf.tagafterbuild.tag']}" level="local"/>
          </hlm:scm>
        </sequential>
    </target>
    
    <#if (count == 0) >
    				<#assign target_depends = "${target_depends}" + "sf-tag-hg-code-${count}" />
    </#if>
    <#if (count > 0) >
            <#assign target_depends ="${target_depends}" + ","+"sf-tag-hg-code-${count}"/>
    </#if>
    
    <#assign count = count + 1 />
</#list>

<target name="all" depends="${target_depends}"/>

</project>