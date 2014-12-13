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

runCheckNewSequence()
{
	if [ ! $# -eq 1 ]
	then
		echo "runCheckNewSequence \${SequenceName}"
		return 1
	fi		
		
	local SequenceName=$1
	let "bNewSequenceFlag=1"

	local SequenceNum=${#aSequenceList[@]}
	for sequence in ${aSequenceList[@]}
	do
		if [ "${sequence}" = "${SequenceName}" ]
		then
			let "bNewSequenceFlag=0"
		fi
	done

	if [ ${bNewSequenceFlag} -eq 1 ]
	then
		aSequenceList[${SequenceNum}]=${SequenceName}
		SequenceNum=${#aSequenceList[@]}
		echo ""
		echo ""
		echo "SequenceNum   is ${SequenceNum}"
		echo "aSequenceList is ${aSequenceList[@]}"
	fi

	return 0
}


runGetSequenceList()
{
	local FileName=""
	local SequenceName=""
	local TempData=""
	for file in ${DataFolder}/*.dat
	do
		FileName=`echo $file | awk 'BEGIN {FS="/"} {print $NF}'`
		TempData=`echo $FileName | awk 'BEGIN {FS="_"} {print $NF}'`
		SequenceName=`echo $FileName | awk 'BEGIN {FS="_'${TempData}'"} {print $1}'`
		
		runCheckNewSequence  ${SequenceName}


	done


}

runCheck()
{
    if [ ! -d ${DataFolder} ]
    then
        echo ""
        echo "data folder does not exit,please double checkeck!"
        echo ""
        exit 1
    fi
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
	
	runGetSequenceList



}

BataFolder=$1
runMain ${BataFolder}



