package org.zenboot.portal.processing

import org.zenboot.portal.Template
import org.zenboot.portal.Host
import org.zenboot.portal.HostState

import ru.jconsulting.likeable.Likeable

class ExecutionZone implements Likeable {

    Date creationDate
    ExecutionZoneType type
    String description
    String puppetEnvironment
    String qualityStage
    SortedSet processingParameters = [] as SortedSet
    Set actions = []
    Set hosts = []
    boolean enabled = true
    boolean enableExposedProcessingParameters = true
    Long hostLimit
    Long defaultLifetime // in minutes
    boolean enableAutodeletion

    SortedSet templates

    static hasMany = [actions:ExecutionZoneAction, processingParameters:ProcessingParameter, templates:Template, hosts:Host]

    static constraints = {
        type nullable:false
        description blank: false, nullable: false

        processingParameters validator: { val, obj ->
            val.each { ProcessingParameter pParam ->
                // if (pParam.id) { // only check updated parameters???
                    if(! pParam.validate()) {
                        pParam.errors.allErrors.each { error ->
                            obj.errors.rejectValue('processingParameters', error.getCode(), error.getArguments(), error.getDefaultMessage())
                        }
                    }
                // }
            }
            return true
        }
    }

    static mapping = {
        actions sort: 'id', order: 'desc'
        puppetEnvironment index:'idx_exczn_pupenv'
        actions cascade: 'all-delete-orphan'
        processingParameters cascade: 'all-delete-orphan'
    }

    def beforeInsert = {
        this.creationDate = new Date()
    }

    boolean isEnabled() {
        return this.type?.enabled && this.enabled
    }

    ProcessingParameter getProcessingParameter(String key) {
        return this.processingParameters.find {
            it.name == key
        }
    }

    void addProcessingParameter(String key, String value) {
      ProcessingParameter pp = new ProcessingParameter(
        ["name":key,
         "value":value,
         "dateCreated": new Date(),
         "published": false,
         "exposed": false])
      pp.save()
      addProcessingParameter(pp)
    }
    void addProcessingParameter(ProcessingParameter param) {
        ProcessingParameter existingParam = this.getProcessingParameter(param.name)
        if (existingParam) {
            existingParam.value = param.value
            existingParam.published = param.published
            existingParam.description = param.description
            existingParam.exposed = param.exposed
            existingParam.comment = param.comment
            existingParam.save()
        } else {
            this.processingParameters << param
        }
    }

    /* convenience-method for script-usage
       return "" in case ob not existing
    */
    String param(String name) {
      def param = this.processingParameters.find(){
        it.name == name
      }
      return param == null ? "" : param.value
    }

    HashMap params() {
      def params = [:]
      this.processingParameters.each(){
        params[it.name] = it.value
      }
      return params
    }

    List getAuditLogEvents() {
        return ProcessingParameterLog.findAllByProcessingParameterInList(this.processingParameters, [sort: "dateCreated", order: "desc"])
    }

    List getCompletedHosts() {
      return this.hosts.findResults() { it.state == HostState.COMPLETED ? it : null  }
    }

    List getCompletedAndUnmanagedHosts() {
      return this.hosts.findResults() { it.state == HostState.COMPLETED ||  it.state == HostState.UNMANAGED ? it : null  }
    }

    List getNonDeletedHosts() {
      return this.hosts.findResults() { it.state == HostState.DELETED ? null : it  }
    }

    List getActiveServiceUrls() {
      this.getCompletedAndUnmanagedHosts().findResults() { it.serviceUrls }.flatten().toSorted()
    }


}
