#!/bin/sh

if [ -z "$SONAR_PROJECT_KEY" ]; then
  echo "Undefined \"SONAR_PROJECT_KEY\"" && exit 1
elif [ -z "$TS_SONAR_URL" ]; then
  echo "Undefined \"URL\"" && exit 1
elif [ -z "$TS_SONAR_USER" ]; then
  echo "Undefined \"USER\"" && exit 1
else
  COMMAND="sonar-scanner -Dsonar.host.url=\"$TS_SONAR_URL\" -Dsonar.login=\"$TS_SONAR_USER\" -Dsonar.password=\"$TS_SONAR_PASSWORD\" -Dsonar.projectKey=\"$SONAR_PROJECT_KEY\""  
  if [ ! -z $CI_PROJECT_ID ]; then
    COMMAND="$COMMAND -Dsonar.gitlab.project_id=\"$CI_PROJECT_ID\""
  fi
  if [ ! -z $CI_BUILD_REF ]; then
    COMMAND="$COMMAND -Dsonar.gitlab.commit_sha=\"$CI_BUILD_REF\""
  fi
  if [ ! -z $CI_BUILD_REF_NAME ]; then
    COMMAND="$COMMAND -Dsonar.gitlab.ref_name=\"$CI_BUILD_REF_NAME\""
  fi  
  if [ ! -z $SONAR_ANALYSIS_MODE ]; then
    COMMAND="$COMMAND -Dsonar.analysis.mode=\"$SONAR_ANALYSIS_MODE\""
    if [ $SONAR_ANALYSIS_MODE="preview" ]; then
      COMMAND="$COMMAND -Dsonar.issuesReport.console.enable=true"
    fi
  fi
  eval $COMMAND
fi