#!/bin/bash

# the context per task required by AGS
# you need to update the context here per task
semester="f19"
courseId="cloud-devops"
projectId="dependency-management"
taskId="build-with-dependencies"
tpz_key="AbSPwM8z5hYR0qfGJSDhYG"

# the generic context required by AGS
studentDNS=$(curl --silent ipinfo.io/ip)
ags_dns="producer.ags.theproject.zone"
#ags_dns="producer.ags.theproject.zone"
signature="1K9SaGliHwthRgeOi12hUdCUwAPmN"
language="java"
codeId="code"
feedbackId="feedback"
useContainer="true"
taskLimit=0
update="false"
pending="false"
duration=120

# This function should be used by both checks and submitter
# Exclude:
# 1. files > 5M
# 2. files under ./target/maven-status/maven-compiler-plugin/
#    which lists the path names of the java source files that contain the andrewId
# e.g. ./target/maven-status/maven-compiler-plugin/compile/default-compile/inputFiles.lst:/home/<andrew_id>/Project_Database/src/main/java/edu/cmu/cs/cloud/YelpApp.java
find_files_to_submit() {
  # exclude facets
  find . -size -5M -type f ! -path "*/target/*" ! -path "*/.git/*" ! -path "*/.DS_Store" ! -path "*/._*" ! -path "*/facets/*" ! -path "*/*.tar.gz"
  find . -size -5M -type f -path "*/target/site/*" ! -path "*/.DS_Store" ! -path "*/._*"
  find $M2_HOME/ -name 'settings.xml' | head -1 | sed 's/\/\/settings.xml/\/settings.xml/g'
}

if [[ -z "${TPZ_USERNAME}" ]]; then
  echo "Please set TPZ_USERNAME as your TPZ username first with the command:"
  echo "export TPZ_USERNAME=\"value\""
  exit 1
else
  andrewId="${TPZ_USERNAME}"
fi

if [[ -z "${TPZ_PASSWORD}" ]]; then
  echo "Please set TPZ_PASSWORD as your submission password from TheProject.zone with the command:"
  echo "export TPZ_PASSWORD=\"value\""
  exit 1
else
  password="${TPZ_PASSWORD}"
fi

while getopts ":ha:" opt; do
    case $opt in
        h)
            echo "This program is used to submit and grade your solutions." >&2
            echo "Usage: ./submitter"
            exit
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

# integrity pledge
echo "####################"
echo "# INTEGRITY PLEDGE #"
echo "####################"
echo "Have you cited all the reference sources (both people and websites) in the file named 'references'? (Type \"I AGREE\" to continue). By typing \"I AGREE\", you agree that you have not cheated in any way when completing this project. Cheating can lead to severe consequences."
read -r references
if [[ "$references" == "I AGREE" ]]
then
    echo "Uploading answers..."
    echo "Files larger than 5M will be ignored."
    # exclude /target/maven-status/maven-compiler-plugin/ log files

    # remove "$andrewId".tar.gz
    rm -f "$andrewId".tar.gz
    find_files_to_submit | tar -cvzf "$andrewId".tar.gz -T - &> /dev/null
    postUrl="https://$ags_dns/ags/submission/submit?signature=$signature&andrewId=$andrewId&password=$password&dns=$studentDNS&semester=$semester&courseId=$courseId&projectId=$projectId&taskId=$taskId&lan=$language&tpzKey=$tpz_key&feedbackId=$feedbackId&codeId=$codeId&useContainer=$useContainer&taskLimit=$taskLimit&update=$update&pending=$pending&duration=$duration&checkResult=$checkResult"
    submitFile="$andrewId.tar.gz"
    if ! curl -s -F file=@"$submitFile" "$postUrl"
        then
        echo "Submission failed, please check your password or try again later."
    else
        # the code can also reaches here with submission failure due to a existing pending submission
        echo "If your submission is uploaded successfully. Log in to theproject.zone and open the submissions table to see how you did!"
    fi
    rm -f "$andrewId".tar.gz
else
    echo "Please cite all the detailed references in the file 'references' and submit again. Type \"I AGREE\" when you submit next time."
fi
