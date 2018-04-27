# assigns new dynatrace environment to existing user group
#
# CONSUMES: cluster_url, api-key, environment name, user group, permission_list
#
# Groups permission json - see api doc (https://modelt-dynatrace.westeurope.cloudapp.azure.com/managed-api-doc/index.jsp#!/User_groups/getGroups)
# in order to add the environment to the user group we need to update the current permissions
# the currently available access rights are:
#
#       "LOG_VIEWER",
#      "VIEWER",
#      "MANAGE_SETTINGS",
#      "VIEW_SENSITIVE_REQUEST_DATA",
#      "AGENT_INSTALL",
#      "CONFIGURE_REQUEST_CAPTURE_DATA"
#
#@Scriptlet(author="Torsten Hellwig (torsten.hellwig@360performance.net)", description="Create a Dynatrace Managed environment/tenant")
#@Parameters([
#  @Parameter(name="DT_CLUSTER", type=ParameterType.CONSUME, description="The cluster_url where the tenant will be created"),
#  @Parameter(name="DT_API_KEY", type=ParameterType.CONSUME, description="The api key to authorize to the cluster"),
#  @Parameter(name="DT_TENANT_NAME", type=ParameterType.CONSUME, description="The name of the tenant to be created"),
#  @Parameter(name="DT_USER_GROUP", type=ParameterType.CONSUME, description="The user group which will be assigned access to the new environment"),
#  @Parameter(name="DT_PERMISSION_LIST", type=ParameterType.CONSUME, description="list of access rights for the user group, e.g {'LOG_VIEWER','MANAGE_SETTINGS'}"),
#  @Parameter(name="SUCCESS", type=ParameterType.EMIT,    description="success status")
#])

import requests
import json
import os

cluster_url = os.getenv('DT_CLUSTER') or "https://n01.lxk326.dynatrace-managed.com"
api_key = os.getenv('DT_API_KEY') or "cWD-mcuOTpmPCT6uuYTkq"
tenant_name = os.getenv('DT_TENANT_NAME') or "Torsten_consultant_test_auto_2"
user_group = os.getenv('DT_USER_GROUP') or "model-t-dev"
permission_list = os.getenv('DT_PERMISSION_LIST') or {"LOG_VIEWER","VIEWER","MANAGE_SETTINGS","VIEW_SENSITIVE_REQUEST_DATA","AGENT_INSTALL","CONFIGURE_REQUEST_CAPTURE_DATA"}

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

    try:    #add environment to user group access rights 
        for access_right in permission_list:
            #print(access_right + " " + str(len(user_group_config_dto['accessRight'][access_right])))
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