################################################################################
# OVERVIEW:
#   This script contains functions for creating items 
#     in Jenkins.
#
################################################################################

source "${includes_directory}/validation.sh"
source "${includes_directory}/file_manipulation.sh"
source "${includes_directory}/string_manipulation.sh"
source "${includes_directory}/name_generation.sh"

################################################################################
# DESCRIPTION:
# Completes setup work for the script to run successfully.
#
# ARGUMENTS:
#   - generated_file
#     The name of the groovy file to generated (includes path).
#
################################################################################
function setup () {
  local generated_file=$1
  local temp_trigger_file=$2
  local temp_placeholder_file=$3
  local temp_child_views_file=$4
  local temp_all_views_file=$5
  
  delete_file "${generated_file}" 
  echo -n > "${generated_file}"
  
  delete_file "${temp_child_views_file}" 
  delete_file "${temp_all_views_file}" 

  clean_temp_files "${temp_trigger_file}" "${temp_placeholder_file}" 
}

################################################################################
# DESCRIPTION:
# Cleans up temporary files once they have been used for a browser.
#
# ARGUMENTS:
#   - generated_file
#     The name of the groovy file to generated (includes path).
#
################################################################################
function clean_temp_files () {
  local temp_trigger_file=$1
  local temp_placeholder_file=$2
    
  delete_file "${temp_trigger_file}" 
  
  delete_file "${temp_placeholder_file}" 

}

################################################################################
# DESCRIPTION:
# Append the script to create a view, to the existing groovy file.
#
# ARGUMENTS:
#   - view_template
#     The path to the groovy template file to use.
#
#   - existing_file
#     The path to the existing groovy file.
#
#   - module_display
#     The name of the browser the view is intended to display.
################################################################################
function append_view () {
  local view_template="$1"
  local existing_file="$2"
  local module_display="$3"
  
  parameter_not_null_or_empty "${view_template}" "view_template" "append_view"
  parameter_not_null_or_empty "${existing_file}" "existing_file" "append_view"
  
  if [ -z "${module_display}" ] || [ "${module_display}" == " " ]
  then
    echo "Incorrect call to method. Parameter module_display cannot be null or empty."
    exit 1
  fi
  
  cat "${view_template}" >> "${existing_file}"
  sed -i "s/<MODULE>/${module_display}/" "${existing_file}"
  sed -i "s/<REGEX>/.*${module_display}*./" "${existing_file}"
}

################################################################################
# DESCRIPTION:
# Adds the dsl for creating a folder in Jenkins to an existing groovy file.
#
# ARGUMENTS:
# - existing_file
#   Full file path to the existing groovy file.
#   REQUIRED
#   Example: /some_folder/some_name.groovy
#
# - template
#   Full path to the the groovy template for the dsl to use.
#   REQUIRED
#   Example: /some_folder/template.groovy
#
# - folder_name
#   Name to assign to the folder as the unique name and display name.
#   REQUIRED
#   
# - folder_description
#   Text to use for the description of the folder.
#   OPTIONAL
################################################################################
function append_folder () {
  local existing_file="$1"
  local template="$2"
  local folder_name="$3"
  local folder_name_display="$4"
  local folder_description="$5"
  
  parameter_not_null_or_empty "${existing_file}" "existing_file" "append_folder"
  parameter_not_null_or_empty "${template}" "template" "append_folder"
  
  if [ -z "${folder_name}" ] || [ "${folder_name}" == " " ]
  then
    echo "Incorrect call to method. Parameter folder_name cannot be null or empty."
    exit 1
  fi

  append_file "${existing_file}" "${template}"
  replace_string_in_file "<NAME>" "${folder_name}" "${existing_file}"
  replace_string_in_file "<DISPLAY_NAME>" "${folder_name_display}" "${existing_file}"
  replace_string_in_file "<DESCRIPTION>" "${folder_description}" "${existing_file}"
}

################################################################################
# DESCRIPTION:
# Gets the list of features files in the project.
#
# ARGUMENTS:
# - location
#   Path to the root folder for all feature files.
#   REQUIRED
#   Example: /some_folder
#
# - name_filter
#   The filter to use for file names.
#   REQUIRED
#   Example: *.feature
################################################################################
function get_feature_files () {
  local location="$1"
  local name_filter="$2"
  
  parameter_not_null_or_empty "${location}" "location" "get_feature_files"
  parameter_not_null_or_empty "${name_filter}" "name_filter" "get_feature_files"
  
  # use nullglob in case there are no matching files
  shopt -s nullglob

  # create an array with all the names
  feature_files=($(find "${location}" -name "${name_filter}"))
}
