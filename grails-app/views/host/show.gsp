<%@ page import="org.zenboot.portal.Host"%>
<%@ page import="org.zenboot.portal.security.Role"%>
<% def accessService = grailsApplication.mainContext.getBean("accessService"); %>
<!doctype html>
<html>
<head>
<meta name="layout" content="main">
<g:set var="entityName" value="${message(code: 'host.label', default: 'Host')}" />
<title>
	<g:message code="default.show.label" args="[entityName]" />
</title>
</head>
<body>
	<div id="show-host" class="content scaffold-show" role="main">
		<h2 class="page-header">
			<g:message code="default.show.label" args="[entityName]" />
		</h2>

		<g:if test="${flash.message}">
			<div class="alert alert-info" role="status">
				${flash.message}
			</div>
		</g:if>

		<g:link action="list">
			<i class="icon-list"></i>
			<g:message code="default.button.list.label" default="Back to overview" />
		</g:link>


		<dl class="dl-horizontal">
			<dt>
				<g:message code="host.type.label" default="Type" />
			</dt>
			<dd>
				${hostInstance?.class.getSimpleName()}
			</dd>

			<g:if test="${hostInstance?.instanceId}">
				<dt>
					<g:message code="host.instanceId.label" default="Instance Id" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="instanceId" />
				</dd>
			</g:if>

			<g:if test="${hostInstance?.hostname}">
				<dt>
					<g:message code="host.hostname.label" default="Hostname" />
				</dt>
				<dd>
					${hostInstance?.hostname?.encodeAsHTML()}
				</dd>
			</g:if>

			<g:if test="${hostInstance?.cname}">
				<dt>
					<g:message code="host.cname.label" default="Cname" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="cname" />
				</dd>
			</g:if>

			<g:if test="${hostInstance?.datacenter}">
				<dt>
					<g:message code="host.datacenter.label" default="Datacenter" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="datacenter" />
				</dd>
			</g:if>

			<g:if test="${hostInstance?.iaasUser}">
				<dt>
					<g:message code="host.iaasUser.label" default="IaaS User" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="iaasUser" />
				</dd>
			</g:if>

		<g:if test="${hostInstance?.serviceUrls}">
			<dt>
				<g:message code="executionZone.serviceUrls.label" default="ServiceUrls" />
			</dt>
			<dd class="collapsable-list">
				<a class="collapsed" style="cursor: pointer">
					<g:message code="hostInstance.serviceUrls.size()" default="{0} serviceUrl defined" args="[hostInstance.serviceUrls.size()]" />
					<i class="icon-resize-full"></i>
				</a>
				<ul class="unstyled hide">
					<g:each in="${hostInstance.serviceUrls}" var="s" status="status">
						<li>
							<a href="${s.url}">${s.url}</a>
						</li>
					</g:each>
				</ul>
			</dd>
		</g:if>

		<g:if test="${hostInstance?.execZone}">
			<dt>
				<g:message code="host.execZone.label" default="ExecutionZone" />
			</dt>
			<dd>
				<g:link controller="executionZone" action="show" id="${hostInstance?.execZone?.id}">
					${hostInstance?.execZone?.encodeAsHTML()}
				</g:link>
			</dd>
		</g:if>

		<g:if test="${hostInstance?.scriptletBatches}">
			<dt>
				<g:message code="host.scriptletBatches.label" default="ScriptletBatches" />
			</dt>
			<dd class="collapsable-list">
				<a class="collapsed" style="cursor: pointer">
					<g:message code="hostInstance.scriptletBatches.size()" default="{0} scriptletBatches defined" args="[hostInstance.scriptletBatches.size()]" />
					<i class="icon-resize-full"></i>
				</a>
				<ul class="unstyled hide">
					<g:each in="${hostInstance.scriptletBatches}" var="scriptletBatch" status="status">
						<li>
							<g:link controller="scriptletBatch" action="show" id="${scriptletBatch?.id}">
								${scriptletBatch.encodeAsHTML()}
							</g:link>
						</li>
					</g:each>
				</ul>
			</dd>
		</g:if>

			<g:if test="${hostInstance?.state}">
				<dt>
					<g:message code="host.state.label" default="State" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="state" />
				</dd>
			</g:if>

			<g:if test="${hostInstance?.creationDate}">
				<dt>
					<g:message code="host.creationDate.label" default="Creation Date" />
				</dt>
				<dd>
					<g:formatDate date="${hostInstance?.creationDate}" />
					(<prettytime:display date="${hostInstance?.creationDate}" />)
				</dd>
			</g:if>

			<g:if test="${hostInstance?.dnsEntries}">
				<dt>
					<g:message code="host.dnsEntries.label" default="Dns Entries" />
				</dt>
				<dd>
					<g:each in="${hostInstance.dnsEntries}" var="d">
						<span class="property-value" aria-labelledby="dnsEntries-label">
							<g:link controller="dnsEntry" action="show" id="${d?.id}">
								${d?.encodeAsHTML()}
							</g:link>
						</span>
					</g:each>
				</dd>
			</g:if>

			<g:if test="${hostInstance?.ipAddress}">
				<dt>
					<g:message code="host.ipAddress.label" default="Ip Address" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="ipAddress" />
				</dd>
			</g:if>

			<g:if test="${hostInstance?.macAddress}">
				<dt>
					<g:message code="host.macAddress.label" default="Mac Address" />
				</dt>
				<dd>
					<g:fieldValue bean="${hostInstance}" field="macAddress" />
				</dd>
			</g:if>

			<g:if test="${hostInstance?.expiryDate}">
				<dt>
					<g:message code="host.expiryDate.label" default="Expiry Date" />
				</dt>
				<dd>
					<g:formatDate date="${hostInstance?.expiryDate}" />
					(<prettytime:display date="${hostInstance?.expiryDate}" />)
				</dd>
			</g:if>

			<g:if test="${hostInstance?.owner}">
				<dt>
					<g:message code="host.owner.label" default="Owner" />
				</dt>
				<dd>
					<g:link controller="customer" action="show" id="${hostInstance?.owner?.id}">
							${hostInstance?.owner?.encodeAsHTML()}
						</g:link>
				</dd>
			</g:if>

			<g:if test="${auditLogEvents.size()>0}">
				<dt>
					<g:message code="host.scriptletBatches.label" default="auditLogEvents" />
				</dt>
				<dd class="collapsable-list">
					<a class="collapsed" style="cursor: pointer">
						<g:message code="auditLogEvents.size()" default="{0} auditLogEvents" args="[auditLogEvents.size()]" />
						<i class="icon-resize-full"></i>
					</a>
					<ul class="unstyled hide">
						<g:render contextPath="/auditLogEvent" template="list" model="['auditLogEventInstanceList': auditLogEvents,'auditLogEventInstanceTotal':auditLogEvents.size()]" />
					</ul>
				</dd>
			</g:if>
		</dl>
		<g:if test="${accessService.userHasAccess(hostInstance.execZone)}">
			<g:form name="markHostForm" action="markHost">
				<g:hiddenField name="id" value="${hostInstance?.id}"/>
				<g:actionSubmit id="markUnknownButton" action="markHostUnknown"
								title="prevent the host from being deleted if you accidentally marked it as broken"
								value="mark unknown" class="btn btn-primary">
				</g:actionSubmit>
				<g:actionSubmit id="markAsBrokenButton" action="markHostBroken"
								title="trigger deletion of the host after some time"
								value="mark broken" class="btn btn-danger">
				</g:actionSubmit>
			</g:form>
		</g:if>
		<g:form name="hostForm">
			<fieldset class="buttons">
				<g:hiddenField name="id" value="${hostInstance?.id}" />
				<sec:ifAllGranted roles="${Role.ROLE_ADMIN}">
					<g:link class="btn btn-primary" action="edit" id="${hostInstance?.id}">
						<g:message code="default.button.edit.label" default="Edit" />
					</g:link>
				</sec:ifAllGranted>
			</fieldset>
		</g:form>

		<g:if test="${params.delete}">
			<asset:script>
		    $(document).ready(function() {
			    $('#deleteButton').click()
		    });
            </asset:script>
		</g:if>

	</div>
</body>
</html>
