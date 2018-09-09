#!/bin/bash
set -x
APPBASE=$APPBENCH/apps/fio
APP=$APPBASE/fio
DATA=$APPBASE/DATA
SIZE=" --size=4G"
#PARAM="--ioengine=libaio --iodepth=16 --rw=randread --bs=4k --direct=0 --numjobs=1 --runtime=240 --group_reporting --directory=$DATA $SIZE"
#PARAM=" --directory=$DATA --runtime=30 $SIZE"
PARAM=" --directory=$DATA $SIZE"
OUTPUT=$2
mkdir $DATA

FlushDisk()
{
	sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
	sudo sh -c "sync"
	sudo sh -c "sync"
	sudo sh -c "echo 3 > /proc/sys/vm/drop_caches"
}

RANDOM_READ(){
echo "Running Random Read"
#$APPPREFIX $APP $APPBASE/examples/fio-rand-read.job --name=randread $PARAM
$APPPREFIX $APP $APPBASE/examples/fio-seq-RW.job --name=randwrite $PARAM
}

RANDOM_WRITE(){
echo "Running Random Write"
#$APPPREFIX $APP $APPBASE/examples/fio-rand-write.job --name=randwrite $PARAM
$APPPREFIX $APP $APPBASE/examples/fio-rand-RW.job --name=randwrite $PARAM
}

SEQ_WRITE(){
echo "Running Sequential Write"
$APPPREFIX $APP $APPBASE/examples/fio-seq-write.job  --name=seqwrite $PARAM
}

SEQ_READ(){
echo "Running Sequential Read"
$APPPREFIX $APP $APPBASE/examples/fio-seq-read.job --name=seqread $PARAM
}

cd $APPBASE
FlushDisk
RANDOM_WRITE
FlushDisk
RANDOM_READ
FlushDisk
#SEQ_WRITE
#FlushDisk
#SEQ_READ
rm $DATA/*
rm -rf fio-seq-RW
rm -rf fio-rand-RW
set +x

