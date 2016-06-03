squeue | awk '{print $1} ' > list
for i in `cat list`; do scancel $i; done
