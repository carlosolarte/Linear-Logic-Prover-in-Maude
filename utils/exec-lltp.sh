#!/bin/bash  
#Execute the Maude prover from a LLTP file
#Example: ls *.p | ./exec-lltp.sh

#Where to find the prover's Maude Files
MAUDE_FILES_DIR="../maude-prover"

#Limit for contraction/copy rule
copy_limit="4"

#Profiling file
profile_file="output.txt"

#Finding Maude
maude_exec=`which maude`
if [[  -z  $maude_exec  ]] ;  then
  echo "Maude not found"
  exit 1
fi
#Finding the prover
maude_file="$MAUDE_FILES_DIR/ILL-Prover.maude"
if [ ! -f $maude_file ]; then
    echo "File $maude_file not found."
    echo "The variable MAUDE_FILES_DIR must point to the directory containing the Maude files of the prover"
    exit 1
fi


#Maude options
maude_options="-no-banner -no-advise -no-wrap -batch"
maude_command="$maude_exec $maude_options $maude_file "


#Output file
output_file="output.tex"
if [[ !  -z  $1  ]] ;  then
  output_file=$1
fi

#Latex Header
echo "LaTeX Output: "$output_file
echo "Profiling Output: "$profile_file

echo -e "\\documentclass[twocolumn]{article}\n\\usepackage{symbols}\n\\\begin{document}\n\\scriptsize\n" > $output_file 
cat /dev/null > $profile_file

counter=0

while read seq_file  ; 
do
  counter=$((counter+1))
  echo "("$counter") Processing file ... "$seq_file ;
  seq=$(grep "fof" $seq_file | sed -e 's/fof(//g' -e 's/|-/|~/g' -e 's/nil/empMS/g' -e 's/)$//')
  seq="([emp] $seq )"
  printf "%s\n" "$seq"
  cmd=`echo "parse($seq) ." | $maude_command`
  printf "%s\n" "$cmd"
  #title=`echo "red in PL-SYNTAX  : toTex($seq) ." | $maude_command | grep String | grep -o 'result String.*' | sed -e s/\"//g -e s/result\ String\://g`
  #echo -e $title
done
  
echo -e "DONE!\nOutputfile= $output_file \nProfiling File: $profile_file";
