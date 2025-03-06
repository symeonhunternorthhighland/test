################################################################################
# OVERVIEW:
#   This script contains functions used to create items in Jenkins.
#
################################################################################

source "${includes_directory}/validation.sh"

################################################################################
# DESCRIPTION:
# Append a file to the end of another file.
#
# ARGUMENTS:
#   - existing_file
#     The file to append to.
#
#   - file_to_append
#     The file to append.
#
################################################################################
function append_file () {

  local existing_file=$1
  local file_to_append=$2

  parameter_not_null_or_empty "${existing_file}" "existing_file" "append_file"  
  parameter_not_null_or_empty "${file_to_append}" "file_to_append" "append_file"
  
  cat "${file_to_append}" >> "${existing_file}"
}

################################################################################
# DESCRIPTION:
# Deletes a file safely.
#
# ARGUMENTS:
#   - file_name
#     The name of the file to delete (relative path).
#
################################################################################
function delete_file () {
  local file_name=$1
  
  if test -f "${file_name}"; then
    rm "${file_name}"
  fi
}
