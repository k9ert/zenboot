package org.zenboot.portal.processing.meta

import org.zenboot.portal.processing.meta.annotation.ParameterType


class ParameterMetadataList {

	/** a helper-method to convert the ouput of getParameters()
	 * or one of the two more specific methods to a simple map
	 */
	static Map convertToMap(Set parameters) {
		def myMap = [:]
		parameters.each {
			myMap.put(it.name,it.value)
		}
		return myMap
	}

	private Set satisfiedParameters = []
	private Set unsatisfiedParameters = []

	// The ParameterMetadataList is somehow misused to not only store the
	// compile-time resolved list of parameters in the scripts, but also
	// the result of overlaying
	// https://github.com/hybris/zenboot/blob/64b3792ad57c11c06b1323cb2ff6eef0f012a51b/grails-app/services/org/zenboot/portal/processing/ExecutionZoneService.groovy#L227-L240
	// the parameters stored in the execZone with the ones coming from the
	// scripts. Therefore, we're returning cloned versions of the parameters
	// which enables proper caching

	Set getSatisfiedParameters() {
		Set parameters = []
		this.satisfiedParameters.each {
			parameters.add(it.clone())
		}
		return parameters
	}

  // This is the only one which is relevant outside because no one cares
	// about the satisfied ones
	Set getUnsatisfiedParameters() {
		Set parameters = []
		this.unsatisfiedParameters.each {
			log.debug("looping: " + it)
			parameters.add(it.clone())
		}
		log.debug("returning unsatisfied Parameters: " + parameters)
		return parameters
	}

	Set getParameters() {
		Set parameters = []
		this.satisfiedParameters.each {
			parameters.add(it.clone())
		}
		this.unsatisfiedParameters.each {
			parameters.add(it.clone())
		}
		//parameters.addAll(this.satisfiedParameters)
		//parameters.addAll(this.unsatisfiedParameters)
		return parameters
	}

	Map getParametersAsMap() {
		def myMap = [:]
		this.satisfiedParameters.each {
			myMap << [it.name,it.value]
		}
		this.unsatisfiedParameters.each {
			pmyMap << [it.name,it.value]
		}
	}

	// this method needs to be called in respect of the execution flow
	// it will then automatically calculate params which needs values
	// in the stack in order to be executed
	void addParameters(Collection parameters) {
		//verify consumed parameters first
		def inputParameters = parameters.findAll { ParameterMetadata parameter ->
			parameter.type == ParameterType.CONSUME
		}
		inputParameters.each { ParameterMetadata parameter ->
			if (!satisfiedParameters*.name.contains(parameter.name)) {
				this.@unsatisfiedParameters << parameter
			}
		}
		//add exposed parameters
		parameters.removeAll(inputParameters)
		parameters.each { ParameterMetadata parameter ->
			this.@satisfiedParameters << parameter
		}
	}

}
