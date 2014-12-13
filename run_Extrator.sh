#!/bin/bash

runGlobalVaribalInitial()
{

    declare -a aSequenceList
    declare -a aDataFileList

    let "bNewSequenceFlag = 0"
    let "iSequenceIndex = 0"
    let "iDataFileIndex = 0"

    CurrentDir=`pwd`

    #get DataFolder full path info
    cd ${DataFolder}
    DataFolder=`pwd`
    cd ${CurrentDir}
}

runGetSequenceList()
{

for file in ${}


}

runCheck()
{
    if [ ! -d ${DataFolder} ]
    then
        echo ""
        echo "data folder does not exit,please double checkeck!"
        echo ""
        exit 1
    else

}


runMain()
{

    if [ ! $# -eq 1 ]
    then
        echo ""
        echo "usage: run_Extractor.sh \${DataFileFolder}"
        echo ""
        exit 1

    fi

    DataFolder=$1
    runCheck
    runGlobalVaribalInitial




}

BataFolder=$1




