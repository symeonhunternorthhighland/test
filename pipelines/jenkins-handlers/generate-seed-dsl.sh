#!/bin/bash

###########################################################################
# Overview
#   This script generates all the folder(s), view(s) and job(s) needed in 
#   Jenkins to run tests for this project.
#
# Description
#   This script creates a .groovy file that is referenced in a job in
#   Jenkins via source control. When this job is run it has a DSL step
#   to reference the groovy file created by this script. That DSL step
#   is what creates/updates the folder(s), view(s) and job(s) that exist
#   in Jenkins.
###########################################################################



################################################################################
# DESCRIPTION:
# Establishes the directories needed for this script to run.
#
# ARGUMENTS:
# None
#
################################################################################
function establish_directories(){

  script_directory=$(dirname -- "$(readlink -f -- "$BASH_SOURCE")")
  pipeline_directory="${script_directory/\/jenkins-handlers/''}"
  root_directory="${pipeline_directory/\/pipelines/''}"
  includes_directory="${script_directory}/includes"
  template_directory="${script_directory}/jenkins-templates"
}

################################################################################
# DESCRIPTION:
# Sets up all template and placeholder references so we can find them no matter 
#   where we run this script.
#
# ARGUMENTS:
# None
#
################################################################################
function update_paths {
  # Update all template references so we can find them whether we run locally or in the cloud
  view_template="${template_directory}/${view_template_file}"
  view_reports_template="${template_directory}/${view_reports_file}"
  nested_view_template="${template_directory}/${nested_view_file}"
  folder_template="${template_directory}/${folder_template_file}"
  job_template="${template_directory}/${job_template_file}"
  trigger_jobs_template="${template_directory}/${trigger_jobs_template_file}"
  report_job_template="${template_directory}/${report_job_template_file}"

  # Update all placeholder references so we can find them whether we run locally or in the cloud
  run_downstream_placeholder="${template_directory}/${run_downstream_placeholder_file}"
  copy_artifacts_placeholder="${template_directory}/${copy_artifacts_placeholder_file}"

  # Update file locations
  dsl_file="${pipeline_directory}/${dsl_file_name}"
  feature_files_location="${root_directory}/${feature_files_path}"
  feature_data="${pipeline_directory}/${feature_data_file}"
}

################################################################################
# DESCRIPTION:
# Adds a job to run a feature to the groovy file.
#
# ARGUMENTS:
# - groovy_file
#   The path to the existing groovy file to add the job to. 
#
################################################################################
function create_job {
  local groovy_file=$1
  local template=$2
  
  # Append the job to the groovy file
  append_file  "${groovy_file}" "${template}"

  # Update the values
  local job_full_name=$(generate_test_job_full_name "${feature_path}" "${title}")
  local job_display_name=$(generate_test_job_display_name "${title}" "${bug}")
  local job_description="Runs the ${file} test for ${module_display}"
  
  replace_string_in_file "<NAME>" "${job_full_name}" "${groovy_file}"
  replace_string_in_file "<DISPLAY_NAME>" "${job_display_name}" "${groovy_file}"  
  replace_string_in_file "<DESCRIPTION>" "${job_description}" "${groovy_file}"
  replace_string_in_file "<GITHUB_URL>" "${github_url}" "${groovy_file}"
  replace_string_in_file "<GITHUB_CREDENTIALS>" "${github_credential_key}" "${groovy_file}"
  replace_string_in_file "<BROWSERSTACK_CREDENTIALS>" "${browserstack_credential_key}" "${groovy_file}"
  replace_string_in_file "<FEATURE_FILE>" "${file}" "${groovy_file}"
  replace_string_in_file "<BUILDS_TO_KEEP>" "${test_job_max_num_of_builds_to_keep}" "${groovy_file}"
  replace_string_in_file "<BUILD_DAYS_TO_KEEP>" "${test_job_days_to_keep_builds}" "${groovy_file}"
  replace_string_in_file "<INCLUDE_PATTERN>" "${report_file_pattern}" "${groovy_file}"
  replace_string_in_file "<BSTACK_CREDENTIALS>" "${bstack_credential_key}" "${groovy_file}"
  replace_string_in_file "<REPORT_JOB>" "${module_display}/${report_job_name}" "${groovy_file}"  
}

################################################################################
# DESCRIPTION:
# Appends to the downstream and trigger placeholders for the trigger job and 
#   the report job.
#
# ARGUMENTS:
# - None
#
################################################################################
function update_job_dependencies {

  local job_full_name=$(generate_test_job_full_name "${feature_path}" "${title}")
  
  # Add the downstream step to the temp variable
  append_file  "${temp_downstream_placeholder}" "${run_downstream_placeholder}"
  replace_string_in_file "<JOB_NAME>" "${job_full_name}" "${temp_downstream_placeholder}"
  
  # Add the copy artifact step to the temp variable
  append_file  "${temp_trigger_placeholder}" "${copy_artifacts_placeholder}"
  replace_string_in_file "<JOB_NAME>" "${job_full_name}" "${temp_trigger_placeholder}"
}

################################################################################
# DESCRIPTION:
# Creates the feature job (aka job to run the feature test) and updates 
#   the job dependencies.
#
# ARGUMENTS:
# - None
#
################################################################################
function setup_job {

  create_job "${dsl_file}" "${job_template}"
  update_job_dependencies      
}

################################################################################
# DESCRIPTION:
# Appends a job that will trigger all feature tests for the specified browser.
#
# ARGUMENTS:
# - None
#
################################################################################
function add_trigger_job {
  local groovy_file=$1
  
  append_file  "${groovy_file}" "${trigger_jobs_template}"

  replace_string_in_file "<NAME>" "${module_display}/${trigger_job_name}" "${groovy_file}"
  job_description_all="Runs all the feature tests for ${module_display}"
  replace_string_in_file "<DESCRIPTION>" "${job_description_all}" "${groovy_file}"
  replace_string_in_file "<BUILDS_TO_KEEP>" "${trigger_job_max_num_of_builds_to_keep}" "${groovy_file}"
  replace_string_in_file "<BUILD_DAYS_TO_KEEP>" "${trigger_job_days_to_keep_builds}" "${groovy_file}"
  
  sed -i "/<DOWNSTREAM>/r ${temp_downstream_placeholder}" "${groovy_file}"
  sed -i "s|<DOWNSTREAM>||" "${groovy_file}"
}

################################################################################
# DESCRIPTION:
# Appends a job that will copy the artifacts of all feature tests for the 
#   specified browser so it can create a report for all tests for the specified browser.
#
# ARGUMENTS:
# - None
#
################################################################################
function add_report_job {
  local groovy_file=$1
  
  append_file  "${groovy_file}" "${report_job_template}"
  
  replace_string_in_file "<NAME>" "${module_display}/${report_job_name}" "${groovy_file}"

  job_description_report="Grabs latest test results from all the feature tests for ${module_display}. NOTE: This job is triggered by the other jobs. DO NOT USE setting [build after other projects are built]."
  replace_string_in_file "<DESCRIPTION>" "${job_description_report}" "${groovy_file}"
  replace_string_in_file "<BUILDS_TO_KEEP>" "${report_job_max_num_of_builds_to_keep}" "${groovy_file}"
  replace_string_in_file "<BUILD_DAYS_TO_KEEP>" "${report_job_days_to_keep_builds}" "${groovy_file}"
  
  sed -i "/<COPY_ARTIFACTS>/r ${temp_trigger_placeholder}" "${groovy_file}"
  sed -i "s|<COPY_ARTIFACTS>||" "${groovy_file}"
  
  replace_string_in_file "<INCLUDE_PATTERN>" "${report_file_pattern}" "${groovy_file}"
}

################################################################################
# DESCRIPTION:
# Creates the browser jobs and runs clean up.
#
# ARGUMENTS:
# - None
#
################################################################################
function create_browser_jobs {
  #Create the job to run all the jobs
  add_trigger_job "${dsl_file}" 
  
  #Create the job to gather results for a given browser
  add_report_job "${dsl_file}"
  
  # Clean up after ourselves
  clean_temp_files "${temp_trigger_placeholder}" "${temp_downstream_placeholder}" 
}

################################################################################
# DESCRIPTION:
# Loops through the feature test files and runs the requested functions.
#
# ARGUMENTS:
# - loop_feature_tests
#   Function to run for each feature test.
#
################################################################################
function loop_feature_tests {
  local function_to_run=$1
  
  input="${feature_data}"
  {
    read -r line

    # Read in the feature data
    while read -r line || [ -n "$line" ]; do

      if [ -n "${line}" ] && [ "$line" != " " ]
      then
        IFS='|' read -r -a array <<< "${line}" ##Split the line by pipes
        
        if [ "${array[0]}" != "#" ]
        then
          for ((j=1; j<=2; j++)); do
            value=$(echo "${array[$j]}"  | xargs) 
            case $j in
              1)             
                file="${value}"
                ;;
              2)              
                title=${value//\'/\\\\\'}
                ;;

            esac
          done   
          
          "${function_to_run}"       
        fi
      fi      
    done
  } < "$input"
}

###############################################################################
# DESCRIPTION:
# Appends a job to the list of jobs in a view.
#
# ARGUMENTS:
# - None
#
################################################################################
function add_job_to_view2 {
  
  local job_full_name=$(generate_test_job_full_name "${feature_path}" "${title}")

  replace_string_in_file "<JOBS>" "name(\'${job_full_name}\')\n        <JOBS>" "${temp_all_view_placeholder}"
}

# *************************************************************************
# *************************************************************************
# GO!
# *************************************************************************

# Load data and config(s)
establish_directories
. "${pipeline_directory}/data.cfg"
. "${includes_directory}/job_functions.sh"
. "${includes_directory}/file_manipulation.sh"
. "${includes_directory}/string_manipulation.sh"
. "${includes_directory}/name_generation.sh"

# Update reference paths
update_paths

# Do setup
setup "${dsl_file}" "${temp_trigger_placeholder}" "${temp_downstream_placeholder}" "${temp_child_views_placeholder}" "${temp_all_view_placeholder}"

# Get feature files
get_feature_files "${feature_files_location}" "${feature_file_filter}"

# Add folders
for ((i = 0; i < ${#moduleDisplayArray[@]}; i++)); do
  module_display="${moduleDisplayArray[$i]}"
  
  # First add the folder for the module
  folder_description="${browser_folder_description/'<MODULE>'/$module_display}"
  append_folder "${dsl_file}" "${folder_template}"  "${module_display}" "${module_display}" "${folder_description}"

  # Now add the folder for the feature tests
  feature_folder_description="${feature_test_folder_description/'<MODULE>'/$module_display}"
  feature_path="${module_display}\/Feature Tests"
  append_folder "${dsl_file}" "${folder_template}" "${feature_path}" "Feature Tests" "${feature_folder_description}"

  # Loop through the feature files and add them
  loop_feature_tests setup_job
  create_browser_jobs
  
done
