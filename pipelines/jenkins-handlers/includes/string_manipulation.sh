################################################################################
# OVERVIEW:
#   This script contains functions used for string manipulation.
#
################################################################################

source "${includes_directory}/validation.sh"


################################################################################
# DESCRIPTION:
# Replaces a pattern in a file with another string.
#  NOTE: The replacement must be safe.
#
# ARGUMENTS:
#   - pattern
#     The string to be replaced.
#
#   - replacement
#     The new string to replace in the file.
#
#   - file_to_update
#     The file to update with the replacement.
################################################################################
function replace_string_in_file () {

  local pattern=$1
  local replacement=$2
  local file_to_update=$3

  parameter_not_null_or_empty "${replacement}" "replacement" "replace_string"  
  
  sed -i "s|${pattern}|${replacement}|" "${file_to_update}"
}

################################################################################
# DESCRIPTION:
# Replaces a pattern in a file with an empty string.
#
# ARGUMENTS:
#   - pattern
#     The string to be replaced.
#
#   - file_to_update
#     The file to update with the replacement.
################################################################################
function remove_string_in_file () {

  local pattern=$1
  local file_to_update=$2
  
  sed -i "s|${pattern}||" "${file_to_update}"
}
