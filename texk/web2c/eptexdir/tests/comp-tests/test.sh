#!/bin/bash

LOGFILE=`pwd`/${USER}_`hostname`.log
#screenfetch -n -N -d '-gtk;-pkgs;-wmtheme;-disk;-uptime;-wm;-res' > $LOGFILE

function test0(){
ENGINE=$1
start_time=$(date +"%s.%3N")
for i in `seq 1 10`; do
  $ENGINE -progname=platex-dev -ini -etex -jobname=$ENGINE-x -comp-level=$2 platex.ini &>/dev/null || exit 1
  echo -n "*"
done
echo
end_time=$(date +"%s.%3N")
elapsed=`echo "scale=3; $end_time - $start_time" | bc`
#
elapsed=`echo "scale=3; $elapsed / 10 " | bc`
BINARY=`which $ENGINE`
echo $2 `wc -c < $BINARY` `wc -c < $ENGINE-x.fmt` $elapsed  | tee -a $LOGFILE
}

function test1(){
echo ENGINE: $1
ENGINE=$1
elapsed="0"
for i in `seq 1 20`; do
  start_time=$(date +"%s.%3N")
  for x in `seq 1 $2`; do $ENGINE -fmt=$ENGINE-x test.tex&>/dev/null ; done
  end_time=$(date +"%s.%3N")
  elapsed=`echo "scale=2; $elapsed + $end_time - $start_time" | bc`
  echo -n "*"
done
echo
elapsed=`echo "scale=2; $elapsed * 50 / $2 " | bc`
echo '#' $ENGINE: ave $elapsed ms| tee -a $LOGFILE
}

pushd /tmp
echo
echo '#' >> $LOGFILE
echo '\documentclass{minimal}\begin{document}\end{document}' > test.tex

test0 eptex 0
test0 eptex-beta 1
test0 eptex-beta 3
test0 eptex-beta 4
test0 eptex-beta 5
test0 eptex-beta 6
test0 eptex-beta 7
test0 eptex-beta 8
test0 eptex-beta 9
test0 eptex-beta 10
test0 eptex-beta 11
test0 eptex-beta 12

test1 eptex 10
test1 eptex-beta 10
