#!/bin/bash

#############################################################################################
#  USAGE
#--------------------------------------------------------------------------------------------
#
#    TEST FEATURE EXAMPLE
#     ./pipelines/build_steps/run-test.sh  --feature_file_name ./features/test.feature
#
#    TO TEST SCRIPT LOCALLY
#    	You need an additional variables that the jobs possess
#     - JOB_BASE_NAME : built-in Jenkins variable
#     - LOCAL_RUN     : A way for us to know this is run locally, this will use your local environment file
#
#
#############################################################################################

#---------------------------------------------------------------------------------------------
#  Create named parameters for passed in parameters
#---------------------------------------------------------------------------------------------
while [ $# -gt 0 ]; do

   if [[ $1 == *"--"* ]]; then
        param="${1/--/}"
        declare $param="$2"
   fi

  shift
done
#---------------------------------------------------------------------------------------------
#  Create the environment file
#    We MUST have an .env file or this will fail.
#---------------------------------------------------------------------------------------------

if [ -z "${LOCAL_RUN}" ] || [ "${LOCAL_RUN}" == " " ]
then
  printf "\nRESTART_BROWSER=true" >> .env

  # These environment variables comes from jenkins
  printf "\nGRID_BUILD_NAME='${JOB_BASE_NAME} (Build ${BUILD_ID})'" >> .env

  index=$((EXECUTOR_NUMBER+1))
  admin_account="ADMIN_ACCOUNT_$index"
  printf "\nADMIN_ACCOUNT='${!admin_account}'" >> .env
  admin_password="ADMIN_PASSWORD_$index"
  printf "\nADMIN_PASSWORD='${!admin_password}'" >> .env
fi

#---------------------------------------------------------------------------------------------
#  Run the tests
#    Clean up the old "out" folder & create a new one
#    Run the test, with the results in the out folder
#---------------------------------------------------------------------------------------------

npm install

rm -rf out
rm -rf logs
mkdir out

npm run remote -- $feature_file_name --steps --verbose

#---------------------------------------------------------------------------------------------
#  Clean up the environment file
#    Make sure we clean up the file, so we don't get an error when the create it on the next build.
#---------------------------------------------------------------------------------------------
if [ -z "${LOCAL_RUN}" ] || [ "${LOCAL_RUN}" == " " ]
then
  find . -type f -name '.env' -delete
fi