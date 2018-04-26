package org.zenboot.portal

import org.zenboot.portal.processing.ProcessingParameter

class ControllerUtils {

    static Set getProcessingParameters(def params, String paramName="parameters.key", String paramValue="parameters.value", String paramExposed="parameters.exposed", String paramPublished="parameters.published", String paramDescription="parameters.description", String paramComment="parameters.comments") {
        Set procParameters = []
        def keys = params[paramName]
        def values = params[paramValue]
        def descriptions = params[paramDescription]
        def comments = params[paramComment]
        def exposed = params[paramExposed]
        def published = params[paramPublished]

        if (keys && values && descriptions != null && exposed && published) {
            if (keys.class.isArray() && values.class.isArray() && descriptions.class.isArray() && exposed.class.isArray() && published.class.isArray()) {
                if (keys.length == values.length && keys.length == descriptions.length && keys.length == exposed.length  && keys.length == published.length) {
                    keys.eachWithIndex { key, index ->
                        procParameters << new ProcessingParameter(name:keys[index], value:values[index], description:descriptions[index], exposed:exposed[index], published:published[index], comment: comments)
                    }
                } else {
                    throw new IllegalArgumentException("Could not convert params to ${ProcessingParameter.class.simpleName} because arrays have different length")
                }
            } else {
                procParameters << new ProcessingParameter(name:keys, value:values, description:descriptions, exposed:Boolean.valueOf(exposed), published:Boolean.valueOf(published), comment: comments)
            }
        }
        return procParameters
    }

    static Object[] createArray(int times, def value) {
      def myArray = []
      // Classic for loop.
      for (def i = 0; i < times; i++) {
        myArray << value
      }
      return myArray
    }

    static Map getParameterMap(def params, String paramKey="parameters.key", String paramValue="parameters.value") {
        def parameters = [:]
        def keys = params[paramKey]
        def values = params[paramValue]
        if (keys && values) {
            if (keys.class.isArray()) {
                if (!values?.class.isArray() || keys.length != values.length) {
                    throw new IllegalArgumentException("Could not map parameters to key/values: keys=${keys} / values=${values}")
                }
                keys.eachWithIndex { key, index ->
                    parameters[key] = values[index]
                }
            } else {
                parameters[keys] = values
            }
        } else {
          // probably edge-case
          if (keys) {
            parameters[keys] = values
          }
        }
        return parameters
    }

    /*
     * called when a ExecutionZone is saved/updated
     * This enables deletion of parameters as well
     */
    static void synchronizeProcessingParameters(Set procParams, def execZone) {
        // Find and delete all Parameters in the execZone which are not present in the set
        def deletedExecZoneParams = execZone.processingParameters.findAll { ProcessingParameter param ->
            !procParams*.name.contains(param.name)
        }
        execZone.processingParameters?.removeAll(deletedExecZoneParams)
        // and then the the set is added to the execZoneAction
        // This will also update existing Parameters
        procParams.each { ProcessingParameter procParam ->
          execZone.addProcessingParameter(procParam)
        }
    }

    static void synchronizeProcessingParameterValues(Map keyValues, def model) {
        def deletedExecZoneParams = model.processingParameters.findAll { ProcessingParameter param ->
            !keyValues.containsKey(param.name)
        }
        model.processingParameters.removeAll(deletedExecZoneParams)
        keyValues.each { key, value ->
            ProcessingParameter procParam = model.getProcessingParameter(key)
            if (procParam) {
                procParam.value = value
                procParam.save()
            } else {
                model.addProcessingParameter(new ProcessingParameter(name:key, value:value, comment:"Parameters added automatically by an execution zone action."))
            }
        }
    }
}
