<g:each var="scriptDir" in="${scriptDirs}" status="i">
<div style="margin-bottom: 10px;">
  <g:radio name="scriptDir" id="scriptdir-${i}" value="${scriptDir}" checked="${scriptDir == selectedScriptDir}" />
  ${scriptDir.name}
  <g:remoteLink action="ajaxGetReadme" params='[scriptDir:scriptDir, editorId:"editor_${i}"]' update="scriptdir-${i}_readme_${type}" before="if (!zenboot.prepareAjaxLoading('scriptdir-${i}_readme_${type}', 'scriptdir-${i}_spinner_${type}')) return false" after="zenboot.finalizeAjaxLoading('scriptdir-${i}_readme_${type}', 'scriptdir-${i}_spinner_${type}');" asynchronous="true">
    <i class="icon-book"></i>
  </g:remoteLink>
  <g:remoteLink action="ajaxGetFlowChart" params="[scriptDir:scriptDir,execId:execId]" update="scriptdir-${i}_flow_${type}"
                before="\$(this).parent().find('.toggle-all-code').toggle(); if (!zenboot.prepareAjaxLoading('scriptdir-${i}_flow_${type}', 'scriptdir-${i}_spinner_${type}')) return false"
                after="zenboot.finalizeAjaxLoading('scriptdir-${i}_flow_${type}', 'scriptdir-${i}_spinner_${type}');"
                asynchronous="false">
    <i class="icon-search"></i>
  </g:remoteLink>
  <a class="zb-tooltip toggle-all-code" title="${message(code:'scriptletBatch.button.showAllCode', default:'Show All Code')}"
     style="display: none"
     onclick="$(this).parent().find('pre').toggle();" >
    <i class="icon-eye-close"></i>
  </a>
  <span id="scriptdir-${i}_spinner_${type}" class="hide">
    <img src="${resource(dir:'images',file:'spinner.gif')}" alt="Spinner" />
  </span>
  <div id="scriptdir-${i}_readme_${type}" class="hide"></div>
  <div id="scriptdir-${i}_flow_${type}" class="hide flow-chart"></div>
</div>
</g:each>
