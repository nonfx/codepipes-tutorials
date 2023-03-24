#!/usr/bin/env bash

set -e
# set -x

function execute {
    set +e
    local __return=$1
    local cmd="$2"
    local cutdelim=':'
    local cutfield=2
    local extra_grep=
    [[ $# -ge 3 ]] && cutdelim="$3"
    [[ $# -ge 4 ]] && cutfield=$4
    [[ $# -eq 5 ]] && extra_grep="$5"

    if [[ -z ${extra_grep} ]]; then
        rv=$(eval "${cmd} 2>&1" | grep -v Using)
    else
        rv=$(eval "${cmd} 2>&1" | grep -v Using | grep -v ${extra_grep})
    fi
    exit=$?
    if [[ ${exit} -eq 1 ]]; then
        eval "$__return=''"
        return 0
    fi

    if [[ ${exit} -ne 0 ]]; then
        echo "Error executing: ${cmd}"
        echo "Error is: ${rv}"
    else
        output=$(eval "echo ${rv//[$'\t\r\n']}" | cut -d "${cutdelim}" -f ${cutfield})
        eval "$__return='${output}'"
    fi
    set -e
    return ${exit}
}

[[ -z ${1} ]] && echo "Org ID is missing" && exit 1
codepipes state set organization $1

# Delete the dependency
execute DEP_ID "codepipes dep list" " " 1 "ID"
if [[ -n ${DEP_ID} ]]; then
    # Delete the resolver
    execute RES_ID "codepipes dep resolver list --dep ${DEP_ID}" " " 1 "ID"
    [[ -n ${RES_ID} ]] && codepipes dep resolver delete --dep ${DEP_ID} $RES_ID
    codepipes dep delete ${DEP_ID}
fi

# Delete the component
execute COMP_ID "codepipes comp list" " " 1 "ID"
[[ -n ${COMP_ID} ]] && codepipes comp delete $COMP_ID

# Create the component
execute COMP_ID "codepipes comp create -i Postgres-Database -f rds-comp-vars.yml -m terraform-aws-modules/rds/aws -v 5.6.0"
echo "Created component: ${COMP_ID}"

# Create the dependency
execute DEP_ID 'codepipes dependency create --name PostgresDB  -o DB_HOST:"DB Host name" -o DB_PORT:"DB Port" -o DB_USER:"DB Username" -o DB_PASSWORD:"DB Password" -o DB_NAME:"DB Name"'
echo "Created dependency: ${DEP_ID}"

# Create the resolver
execute RES_ID "codepipes dep resolver create --dep ${DEP_ID} -p ${COMP_ID} -o DB_HOST:db_instance_address -o DB_PORT:db_instance_port -o DB_USER:db_instance_username -o DB_PASSWORD:db_instance_password -o DB_NAME:db_instance_name"
echo "Created resolver: ${RES_ID}"
