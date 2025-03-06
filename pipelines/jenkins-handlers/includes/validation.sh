#!/bin/bash

################################################################################
# DESCRIPTION:
# Checks if a parameter value is null or empty.
# And spits out a message to the console.
#
# ARGUMENTS:
#   - $1
#     The actual parameter.
#
#   - $2
#     The parameter's display name (for error logging).
#
#   - $3
#     The function's name (for error logging).
################################################################################

function parameter_not_null_or_empty () {
  parameter_not_null "${1}" "${2}" "${3}"
     
  if [ $? == 0 ] ;then
    return 0
  else
    parameter_not_empty "${1}" "${2}" "${3}"
    return $?
  fi
}

################################################################################
# DESCRIPTION:
# Checks if a parameter value is null.
# And spits out a message to the console.
#
# ARGUMENTS:
#   - $1
#     The actual parameter.
#
#   - $2
#     The parameter's display name (for error logging).
#
#   - $3
#     The function's name (for error logging).
################################################################################
function parameter_not_null () {
     
  if [ -z "$1" ] ;then
    if [ -z "$2" ] || [ "$2" == " " ] ;then
      if [ -z "$3" ] || [ "$3" == " " ] ;then
        echo "Parameter cannot be null. Function not called correctly."       
      else
        echo "Parameter cannot be null. Function [$3] not called correctly."    
      fi
    else
      echo "Parameter cannot be null. Function [$3] not called correctly. Parameter [$2] is not set."      
    fi
    return 0
  else 
    return 1
  fi
}

################################################################################
# DESCRIPTION:
# Checks if a parameter value is empty.
# And spits out a message to the console.
#
# ARGUMENTS:
#   - $1
#     The actual parameter.
#
#   - $2
#     The parameter's display name (for error logging).
#
#   - $3
#     The function's name (for error logging).
################################################################################
function parameter_not_empty () {
     
  if [ "$1" == " " ] ;then
    if [ -z "$2" ] || [ "$2" == " " ] ;then
      if [ -z "$3" ] || [ "$3" == " " ] ;then
        echo "Parameter cannot be empty. Function not called correctly."       
      else
        echo "Parameter cannot be empty. Function [$3] not called correctly."    
      fi
    else
      echo "Parameter cannot be empty. Function [$3] not called correctly. Parameter [$2] is not set."      
    fi
    return 0
  else 
    return 1
  fi
}
