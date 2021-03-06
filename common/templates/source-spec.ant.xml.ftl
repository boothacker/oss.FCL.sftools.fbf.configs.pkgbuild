<?xml version="1.0"?>
<project name="SF-SOURCESPEC" default="all" xmlns:hlm="http://www.nokia.com/helium">

<#assign fileset = "" />
<#assign sync_list = "" />
<#assign bom_list  = "" />
<#assign dollar = "$"/>
<#assign count = 0 />

<#if ("${ant['sf.spec.sourcesync.archive']}")??>
  <#if "${ant['sf.spec.sourcesync.archive']}" == "true">
    <#assign fast_sync = true />
  <#else>
    <#assign fast_sync = false />
  </#if>
<#else>
  <#assign fast_sync = false />
</#if>

    <!-- remove previous version of BOM file (if exists)  -->
    <target name="reset-bom-sources-csv">
        <delete file="${ant['build.drive']}/output/logs/BOM/sources.csv" quiet="true"/>
    </target>

<#list data as pkg_detail>
    <target name="sf-prebuild-${count}">
        <#if (count > 0) >
            <#assign fileset = "${fileset}"  />
        </#if>
        <sequential>
            <!-- create sf\layer dir  -->
            <mkdir dir="${ant['build.drive']}${pkg_detail.dst}"/>
            <delete dir="${ant['build.drive']}${pkg_detail.dst}" failonerror="false" />
            <!-- Don't use hg archive with tags, as we can have wildcards in the tags... -->
            <#if fast_sync && ("${pkg_detail.type}"!="tag") > 
              <!-- Identify the version on the cache first -->
              <exec executable="hg" dir="${pkg_detail.source}" outputproperty="sf.sourcesync.${count}.checksum">
                  <arg value="identify"/>
                  <arg value="-i"/>
                  <arg value="-r"/>
                  <arg value="${pkg_detail.pattern}"/>
              </exec>
              <!-- hg archive on the version we found -->
              <exec executable="hg" dir="${pkg_detail.source}">
                  <arg value="archive"/>
                  <arg value="-r"/>
                  <arg value="${dollar}{sf.sourcesync.${count}.checksum}"/>
                  <arg value="${ant['build.drive']}${pkg_detail.dst}"/>
              </exec>
            <#else>
            <exec executable="hg" dir="${ant['build.drive']}">
                <arg value="clone"/>
                <arg value="-U"/>
                <arg value="${pkg_detail.source}"/>
                <arg value="${ant['build.drive']}${pkg_detail.dst}"/>
            </exec>
            
            <hlm:scm verbose="true" scmUrl="scm:hg:${pkg_detail.source}">
                <!--hlm:checkout basedir="${ant['build.drive']}${pkg_detail.dst}"/-->
                <#if "${pkg_detail.type}"=="tag" >
                <hlm:tags basedir="${ant['build.drive']}${pkg_detail.dst}" reference="hg.tags.id${dollar}{refid}"/>
                <hlm:update basedir="${ant['build.drive']}${pkg_detail.dst}">
                <hlm:latestTag pattern="${pkg_detail.pattern}">
                        <hlm:tagSet refid="hg.tags.id${dollar}{refid}" />
                </hlm:latestTag>
                </hlm:update>
                </#if>
                <#if "${pkg_detail.type}"== "changeset" || "${pkg_detail.type}"=="branch">
                <hlm:update basedir="${ant['build.drive']}${pkg_detail.dst}">
                     <hlm:tag name="${pkg_detail.pattern}"/>
                </hlm:update>
                </#if>
            </hlm:scm>
                <exec executable="hg" dir="${ant['build.drive']}${pkg_detail.dst}" outputproperty="sf.sourcesync.${count}.checksum">
                <arg value="identify"/>
                <arg value="-i"/>
            </exec>
          </#if>  
        </sequential>
    </target>

    <target name="sf-bom-info-${count}">

        <sequential>
            <!-- record info on source code repo/rev in BOM file  -->
            <echo message="dir ${ant['build.drive']}${pkg_detail.dst} : ${dollar}{sf.sourcesync.${count}.checksum}"/>
            <exec executable="cmd" output="${ant['build.drive']}/output/logs/BOM/sources.csv" append="true">
                <arg value="/c"/>
                <arg value="echo"/>
                <arg value="${pkg_detail.source},${pkg_detail.dst},changeset,${dollar}{sf.sourcesync.${count}.checksum},${pkg_detail.sysdef}"/>
            </exec>
        </sequential>
    </target>


    <#assign fileset = "${fileset}" + "<fileset dir=\"${ant['build.drive']}${pkg_detail.dst}\" includes=\"${pkg_detail.sysdef}\"/>" />       
    <#assign sync_list = "${sync_list}" + "<runtarget target=\"sf-prebuild-${count}\"/>\n"/>       
    <#assign bom_list = "${bom_list}" + "<runtarget target=\"sf-bom-info-${count}\"/>\n"/>    
    <#assign count = count + 1 />

</#list>

    <path id="system.definition.files">
        <fileset dir="${dollar}{sf.common.config.dir}/sysdefs" includes="*.sysdef.xml"/>
        ${fileset}
    </path>

<target name="all" depends="reset-bom-sources-csv">

  <parallel threadCount="${ant['env.NUMBER_OF_PROCESSORS']}">
    ${sync_list}
  </parallel>

  <echo message="Adding BOM header"/>
      <mkdir dir="${ant['build.drive']}/output/logs/BOM/"/>
      <exec executable="cmd" output="${ant['build.drive']}/output/logs/BOM/sources.csv" append="true">
      <arg value="/c"/>
      <arg value="echo"/>
      <arg value="source,dst,type,pattern,sysdef"/>
  </exec>
  
  ${bom_list}

</target>
</project>