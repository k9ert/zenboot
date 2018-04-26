#creates a new dynatrace environment (also called a tenant)
#
# CONSUMES: cluster_url, api-key, environment name

#@Scriptlet(author="Torsten Hellwig (torsten.hellwig@360performance.net)", description="Create a Dynatrace Managed environment/tenant")
#@Parameters([
#  @Parameter(name="DT_CLUSTER", type=ParameterType.CONSUME, description="The cluster_url where the tenant will be created"),
#  @Parameter(name="DT_API_KEY", type=ParameterType.CONSUME, description="The api key to authorize to the cluster"),
#  @Parameter(name="DT_TENANT_NAME", type=ParameterType.CONSUME, description="The name of the tenant to be created"),
#  @Parameter(name="SUCCESS", type=ParameterType.EMIT,    description="success status"),
#])

import requests
import json
import os

cluster_url = os.getenv('DT_CLUSTER') or "https://n01.lxk326.dynatrace-managed.com"
api_key = os.getenv('DT_API_KEY') or "cWD-mcuOTpmPCT6uuYTkq"
tenant_name = os.getenv('DT_TENANT_NAME') or "Torsten_consultant_test_auto_1"


rest_endpoint = "/api/v1.0/control/tenantManagement"

def check_name_exists():
    check_url = cluster_url + rest_endpoint + "/tenantConfigs"
    headers = {"Authorization" : "Api-Token " + api_key}

    try:
        response = requests.get(check_url, headers=headers)
        if response.status_code == 200:
            data = json.loads(response.content.decode('utf-8'))
        else:
            return None
        for tenant_alias in data:
            if tenant_alias["alias"].lower() == tenant_name.lower():
                return True
    except (ValueError, KeyError, TypeError):
        return None        
    return False

def create_tenant():
    #print("Creating environment, please wait...")
    create_url = cluster_url + rest_endpoint + "/createTenant"
    headers = {"Authorization" : "Api-Token " + api_key, "Content-Type" : "application/json"}
    configDto = {
        "tenantConfigDto": {
            "alias": tenant_name,
            "displayName": tenant_name,
            "replicationFactor": -1,
            "domainNames": [],
            "internalAlias": tenant_name,
            "name": tenant_name,
            "tenantUUID": tenant_name,
            "isActive": "true"
        },
        "licenseDto": {
            "licenseType": "PAYING",
            "isCreditExhausted": "false",
            "isRumEnabled": "true"
        }
    }
    response = requests.post(create_url, headers=headers, json=configDto)
    #print("Response was:" + str(response.status_code))    
    response.raise_for_status()
    return True

check_name = check_name_exists()
if check_name is not None and check_name is False:
    if create_tenant():
        print("True")
    else:
        print("False")
else:
    print("Tenant with that name: \"{0}\" already exists".format(tenant_name))