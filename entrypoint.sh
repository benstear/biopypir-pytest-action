#!/bin/bash
set -e

#### this file has abstracted away the type of report and the package for each user. 
#### I am also going to add the option of specifying which function to use 
#### whether that be linting, unit testing, build testing or something else.
#### I think this will be general enough so that we won't have to change this 
#### file at all on a user to user basis.

echo "#################################################"
echo "Starting ${GITHUB_WORKFLOW}:${GITHUB_ACTION}"

echo "with PACKAGE_NAME: $INPUT_PACKAGE_NAME"
echo "     Function:     Linting"
echo "     Verbosity:    $INPUT_VERBOSITY"

# if verbosity!= full_report || score_only, verbosity == default, echo verbosity input incorrect, using default.

if [ "$INPUT_VERBOSITY" = "full_report" ] 
  then
  pylint "$INPUT_PACKAGE_NAME"  --exit-zero --reports=y | > pylint-report.txt  
elif [ "$INPUT_VERBOSITY" = "score_only" ] 
  then
  pylint "$INPUT_PACKAGE_NAME"  --exit-zero --reports=y | \
  awk '$0 ~ /Your code/ || $0 ~ /Global/ {print}' | cut -d'/' -f1 | rev | cut -d' ' -f1 | rev > pylint-report.txt 
fi

echo ::set-output name=pylint-report::$pylint-report.txt

echo "#################################################"
echo "Completed ${GITHUB_WORKFLOW}:${GITHUB_ACTION}"



#chmod +x ./docs/biopypir_docs/test_1.sh && ./docs/biopypir_docs/test_1.sh
