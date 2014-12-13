#!/bin/bash

runGlobalVaribalInitial()
{

    declare -a aSequenceList
    declare -a aDataFileList
    declare -a aQPList
	declare -a aPSNRList
	declare -a aBitRateList
	declare -a aFPSListi
	declare -a aEncoderTimeList

    let "bNewSequenceFlag = 0"
    let "iSequenceIndex = 0"
    let "iDataFileIndex = 0"

	aQPList=(22 27 32 37)
    aPSNRList=(NULL NULL NULL NULL NULL)
    aBitRateList=(NULL NULL NULL NULL NULL)
    aFPSList=(NULL NULL NULL NULL NULL)
    aEncoderTimeList=(NULL NULL NULL NULL NULL)

	CurrentDir=`pwd`
	OutPutFileName="${CurrentDir}/EncoderPerformance.csv"
	date
    TestDate=`date`
	echo "">${OutPutFileName}
	echo "TestDate is:, ${TestDate}">>${OutPutFileName}
	echo "">>${OutPutFileName}

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
	fi

	return 0
}


runGetSequenceList()
{
	local FileName=""
	local SequenceName=""
	local TempData=""
	local SequenceNum=${#aSequenceList[@]}
	for file in ${DataFolder}/*.dat
	do
		FileName=`echo $file | awk 'BEGIN {FS="/"} {print $NF}'`
		TempData=`echo $FileName | awk 'BEGIN {FS="_"} {print $NF}'`
		SequenceName=`echo $FileName | awk 'BEGIN {FS="_'${TempData}'"} {print $1}'`
		
		runCheckNewSequence  ${SequenceName}
	done
	
	SequenceNum=${#aSequenceList[@]}
	echo ""
	echo ""
	echo "SequenceNum   is ${SequenceNum}"
	echo "aSequenceList is ${aSequenceList[@]}"
}

runGetPerformanceInfoFromLogFile()
{
		
	return 0	
}

runOutputSequencePerformaceInfo()
{
	if [ ! $# -eq 1 ]
	then
		echo "usage: runOutputSequencePerformaceInfo  \${SequenceName}"
		return 1
	fi

	local SequenceName=$1
	local QPPerformance=""
	local NeadLine=" , ,${SequenceName},Bit_R,PSNR_Y,Enc_Time,EncFPS"

	echo ${NeadLine}>>${OutPutFileName}

	for((i=0;i<4;i++))
	do
		QPPerformance=" , ,${aQPList[$i]},${aBitRateList[$i]},${aPSNRList[$i]},${aEncoderTimeList[$i]},${aFPSList[$i]}"
		echo ${QPPerformance}>>${OutPutFileName}
	done
	
}

runGetSequencePerformanceInfo()
{
	local LogFileName=""
	local QP=""

	aQPList=(22 27 32 37)
	
	declare aPerFormanceInfo
	aPerFormanceInfo=(NULL NULL NULL NULL)
	
	for sequence in ${aSequenceList[@]}
	do
		for((i=0;i<4;i++))
		do
			QP=${aQPList[$i]}
			LogFile="${DataFolder}/${sequence}_${QP}.dat"
			if [ ! -e ${LogFile} ]
			then
				echo "Log file does not found,please double check!"
				echo "    --log file: ${LogFile}"
				echo ""
				aBitRateList[$i]="NULL"
				aPSNRList[$i]="NULL"
				aFPSList[$i]="NULL"
				aEncoderTimeList[$i]="NULL"
			else
				aPerFormanceInfo=(NULL NULL NULL NULL)
				#aPerFormanceInfo=(`runGetPerformanceInfoFromLogFile ${LogFile}`)

				aBitRateList[$i]=${aPerFormanceInfo[0]}
				aPSNRList[$i]=${aPerFormanceInfo[1]}
				aFPSList[$i]=${aPerFormanceInfo[2]}
			fi
		done
					
		runOutputSequencePerformaceInfo ${sequence}

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

	runGetSequencePerformanceInfo
	
	echo "aSequenceList is ${aSequenceList[@]}"
	echo "aQPList is ${aQPList[@]}"
}

BataFolder=$1
runMain ${BataFolder}



