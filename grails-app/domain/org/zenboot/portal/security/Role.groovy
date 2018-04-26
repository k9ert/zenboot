package org.zenboot.portal.security

class Role {

    static final String ROLE_ADMIN = "ROLE_ADMIN"
    static final String ROLE_USER = "ROLE_USER"
    static final String ROLE_SANITYCHECK = "ROLE_SANITYCHECK"

    String authority

    String executionZoneAccessExpression

    // passing in the name of the parameter and if evaluates to true, the principal
    // is allowed to edit that parameter
    String parameterEditExpression

//    transient accessService

    static mapping = { cache true }

    static constraints = {
        authority blank: false, unique: true, validator: { if(!it.startsWith('ROLE_')) return ['The name of the role need the "ROLE_" prefix!']}
    }

    @Override
    String toString() {
        return this.authority ?: 'Role'
    }
}
