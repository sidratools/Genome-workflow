#!/bin/sh
export CPU_Control="/sys/devices/system/cpu/cpu0/cpufreq" ;
tot_CPU=`cat /proc/cpuinfo|grep processor|wc -l` ;
GOVERNOR=0;
FREQUENCY=0;

## Check for CPU speed control 
     if [ -d $CPU_Control ]
     then
      echo "CPU frequency is controllable."
     else
      echo "Error: Required BIOS settings to enable EIST."
      exit 1; 	
     fi
## Check for current CPU frequency and scaling governor. 
   cd $CPU_Control ;
   current=`cat cpuinfo_cur_freq` ;
   cur_govn=`cat scaling_governor`
   min=`cat cpuinfo_min_freq` ;
   max=`cat cpuinfo_max_freq` ;
#    echo "The current CPU frequency is ..........." $current
#    echo "The current scaling governor is ...." $cur_govn
#    echo "The Minimum CPU Frequency will be ......" $min
#    echo "The Maximum CPU Frequency will be ......" $max

## Check for Performance governor
  if [ performance == $cur_govn ]
  then
   echo "CPU scaling governor running in PERFORMANCE mode" ;
   GOVERNOR=1
  else
   echo "CPU scaling governor need to be modified" ;
 fi

## Check for Max. frequency
if [ $current == $max ]
  then
   echo "CPU frequency is running with Max frequency" ;
   FREQUENCY=1;
  else
   echo "CPU frequency need to be set max." ;
 fi
## Check for all CPUs are set with unique values 
   i=0 ;
   echo $tot_CPU; 
while [$i -ne $tot_CPU];
do
      my_freq=`cat /sys/devices/system/cpu/cpu"$i"/cpufreq/cpuinfo_cur_freq` ;
      my_govn=`cat /sys/devices/system/cpu/cpu"$i"/cpufreq/scaling_governor` ;
      i=`expr $i + 1` ;
done 
