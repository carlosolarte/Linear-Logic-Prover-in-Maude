#!/bin/bash  
#Executing a list of ILL formulas
#Example cat benchmarks-alternatives.txt | ./exec-benchmark-alt.sh output.tex
#First argument is the name of the latex file. If empty, output.tex is used

#Profiling file
profile_file="output.txt"
#Finding Maude
maude_exec=`which maude`
if [[  -z  $maude_exec  ]] ;  then
  echo "Maude not found"
  exit 1
fi

#Maude options
maude_options="-no-banner -no-advise -no-wrap -batch"
maude_command="$maude_exec $maude_options "

#Time-out
time_limit="60"
timeout_cmd="timeout --signal=SIGINT $time_limit"

#Limit for contraction/copy rule
copy_limit="4"

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

while read seq  ; 
do
  counter=$((counter+1))
  echo -e "%Proving "$seq"\n" >> $output_file;
  title=`echo "red toTex($seq) ." | $maude_command ILL-Prover.maude | grep String | grep -o 'result String.*' | sed -e s/\"//g -e s/result\ String\://g`
  echo -e "\\\TitleSeqC{$counter}{$title}\n" >> $output_file ;

  echo "Processing $seq .... "
  maude_ins="red solve($copy_limit, ("$seq")) . " 

  str=`$timeout_cmd echo "$maude_ins" | $maude_command ILL-Prover`
  if [[ $str == *"result"* ]] ;then
    str_time=`echo $str | grep -o '[0-9]*ms real' | grep -o '[0-9]*'` 
    echo "$seq ; $str_time" >> $profile_file ;
    echo -e "\\\wrapProof{encoding}{$str_time}{" >> $output_file;
    echo -e $str | grep -o 'result String.*' |  sed -e s/\"//g -e s/result\ String\://g -e s/"Maude> Bye."//g >> $output_file
    echo "}" >> $output_file;
  else
    echo "Timeout";
    echo "$seq ; $bench ; timeout" >> $profile_file ;
    echo -e "\\\wrapProof{$bench encoding}{\\\timeout}{timeout}\n" >> $output_file ;
  fi
done
echo -e "\\end{document}" >> $output_file 
  
echo -e "DONE!\nOutputfile= $output_file \nProfiling File: $profile_file";
echo $md_exec;
