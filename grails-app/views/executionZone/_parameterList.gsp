<%@ page import="org.zenboot.portal.security.Role"%>
<table class="table exec-parameters-table">
<g:each in="${executionZoneParameters}" var="entry" status="i">
  <tr>
    <td style="width: 45%">
      <g:textField name="parameters.key" readonly="true" value="${entry.name}" />
    </td>
    <td style="width: 45%">
      <div class="control-group ${entry.overlay ? 'info' : entry.value ? 'success' : ''}">
        <g:if test="${entry.visible || (!entry.visible && entry.value.empty)}">
          <sec:ifAllGranted roles="${Role.ROLE_ADMIN}">
            <g:textField name="parameters.value" value="${entry.value}" required="required"/>
          </sec:ifAllGranted>
          <sec:ifNotGranted roles="${Role.ROLE_ADMIN}">
            <g:textField name="parameters.value" value="${entry.value}" readonly="${readonly}"/>
          </sec:ifNotGranted>
        </g:if>
        <g:else>
          <sec:ifAllGranted roles="${Role.ROLE_ADMIN}">
          <g:field type="password" name="parameters.value" placeholder="${message(code:'executionZone.scriptletMetadata.secretValue', default:'Secret value')}" />
          <span class="muted">
            <g:message code="executionZone.scriptletMetadata.secretField" default="Set this field only if secret value should be overridden" />
          </span>
          </sec:ifAllGranted>
          <sec:ifNotGranted roles="${Role.ROLE_ADMIN}">
              <g:field type="password" readonly="${readonly} "name="parameters.value" placeholder="${message(code:'executionZone.scriptletMetadata.secretValue', default:'Secret value')}" />
          </sec:ifNotGranted>
        </g:else>
      </div>
    </td>
    <td>
      <span title="Remove parameter" class="btn btn-mini remove-parameter-button">
        <i class="icon-minus-sign"></i>
      </span>
      <span title="Show details" class="btn btn-mini details-parameter-button">
        <i class="icon-question-sign"></i>
      </span>
    </td>
  </tr>

  <tr>
    <td colspan="3" class="scriptlet-metadata">
      <g:render template="scriptletMetadata" model="[scriptlet:entry]" />
    </td>
  </tr>
</g:each>
</table>
