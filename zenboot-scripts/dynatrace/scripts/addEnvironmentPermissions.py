# assigns new dynatrace environment to existing user group
#
# CONSUMES: cluster_url, api-key, environment name, user group

#@Scriptlet(author="Torsten Hellwig (torsten.hellwig@360performance.net)", description="Create a Dynatrace Managed environment/tenant")
#@Parameters([
#  @Parameter(name="DT_CLUSTER", type=ParameterType.CONSUME, description="The cluster_url where the tenant will be created"),
#  @Parameter(name="DT_API_KEY", type=ParameterType.CONSUME, description="The api key to authorize to the cluster"),
#  @Parameter(name="DT_TENANT_NAME", type=ParameterType.CONSUME, description="The name of the tenant to be created"),
#  @Parameter(name="DT_USER_GROUP", type=ParameterType.CONSUME, description="The user group which will be assigned access to the new environment"),
#  @Parameter(name="SUCCESS", type=ParameterType.EMIT,    description="success status"),
#])

import requests
import json
import os

cluster_url = os.getenv('DT_CLUSTER') or "https://n01.lxk326.dynatrace-managed.com"
api_key = os.getenv('DT_API_KEY') or "cWD-mcuOTpmPCT6uuYTkq"
tenant_name = os.getenv('DT_TENANT_NAME') or "Torsten_consultant_test_auto_1"
user_group = os.getenv('DT_USER_GROUP') or "model-t-dev"

rest_endpoint_groups = "/api/v1.0/onpremise/groups"
rest_endpoint_tenant_config = "/api/v1.0/control/tenantManagement/tenantConfig/"

user_group_config_dto = {}

headers = {"Authorization" : "Api-Token " + api_key}

def check_tenant_exists():
    check_url = cluster_url + rest_endpoint_tenant_config + tenant_name
    try:
        response = requests.get(check_url, headers=headers)
        if response.status_code == 200:
            #data = json.loads(response.content.decode('utf-8'))
            return True
        else:
            return False
    except (ValueError, KeyError, TypeError):
        return False        
    return False

def check_user_group():
    check_url = cluster_url + rest_endpoint_groups + "/" + user_group
    try:
        response = requests.get(check_url, headers=headers)
        if response.status_code == 200:
            global user_group_config_dto
            user_group_config_dto = json.loads(response.content.decode('utf-8'))
            return True
        else:
            return False
    except (ValueError, KeyError, TypeError):
        return False        
    return False

def assign_tenant_to_user_group():
    #print("Creating environment, please wait...")
    create_url = cluster_url + rest_endpoint_groups
    headers = {"Authorization" : "Api-Token " + api_key, "Content-Type" : "application/json"}

    try:    #add environment to user group for all defined permissions
        for access_right in user_group_config_dto['accessRight']:
            #print(access_right + " " + str(len(user_group_config_dto['accessRight'][access_right])))
            if len(user_group_config_dto['accessRight'][access_right]) > 0:
                user_group_config_dto['accessRight'][access_right].append(tenant_name)
    except (ValueError, KeyError, TypeError):
        return False
    response = requests.put(create_url, headers=headers, json=user_group_config_dto)
    #print("Response was:" + str(response.status_code))    
    response.raise_for_status()
    return True

check_tenant = check_tenant_exists()
if check_tenant:
    check_group = check_user_group()
    if check_group:
        assign_tenant = assign_tenant_to_user_group()
        if assign_tenant:
            print("True")
    else:
        print("False")
else:
    print("false")