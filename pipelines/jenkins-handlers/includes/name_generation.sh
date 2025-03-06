################################################################################
# OVERVIEW:
#   This script contains functions related to name generation.
#
################################################################################

source "${includes_directory}/validation.sh"

################################################################################
# DESCRIPTION:
# Generates the name for a job that runs a feature test.
#
# ARGUMENTS:
#   - title
#     The name to use for the job
#
################################################################################
function generate_test_job_name () {

  local title=$1

  parameter_not_null_or_empty "${title}" "title" "generate_test_job_name"

  local name="${title} Feature"  
  
  echo "${name}"
}

################################################################################
# DESCRIPTION:
# Generates the name for a job that runs a feature test.
#
# ARGUMENTS:
#   - title
#     The name to use for the job
#
#   - bug
#     The JIRA bug id (OPTIONAL)
################################################################################
function generate_test_job_display_name () {

  local title=$1
  local bug=$2

  parameter_not_null_or_empty "${title}" "title" "generate_test_job_display_name"

  local name="${title} Feature"  
  
  if [ ! -z "${bug}" ] && [ "${bug}" != " " ]
  then
    name="${name} (${bug})"
  fi
  echo "${name}"
}

################################################################################
# DESCRIPTION:
# Generates the name for a job that runs a feature test.
#
# ARGUMENTS:
#   - path
#     The path in jenkins to the job.
#
#   - title
#     The name to use for the job
#
#   - bug
#     The JIRA bug id (OPTIONAL)
################################################################################
function generate_test_job_full_name () {

  local path=$1
  local title=$2
  local bug=$3

  local name=$(generate_test_job_name "${title}")
  
  parameter_not_null_or_empty "${path}" "path" "generate_test_job_full_name"    
    
  local full_name="${path}/${name}"    
  echo "${full_name}"
}
