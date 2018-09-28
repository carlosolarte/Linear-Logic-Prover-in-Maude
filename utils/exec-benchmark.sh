#!/bin/bash  
#Executing a list of propositional logic sequents into ILL
#Example cat benchmark.txt | ./exec-benchmark.sh output.tex
#First argument is the name of the latex file. If empty, output.tex is used

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
#Checking Maude prover
maude_file="$MAUDE_FILES_DIR/ILL-Prover.maude"
if [ ! -f $maude_file ]; then
    echo "File $maude_file not found."
    echo "The variable MAUDE_FILES_DIR must point to the directory containing the Maude files of the prover"
    exit 1
fi

#Maude options
maude_options="-no-banner -no-advise -no-wrap -batch"
maude_command="$maude_exec $maude_options "

#Translations to be tested
translations="MULTIPLICATIVE CALL-BY-NAME CALL-BY-VALUE 01-ENC"

#Time-out
time_limit="60"
timeout_cmd="timeout --signal=SIGINT $time_limit"


#Output file
output_file="output.tex"
if [[ !  -z  $1  ]] ;  then
  output_file=$1
fi


#Latex Header
echo -e "\\documentclass[twocolumn]{article}\n\\usepackage{symbols}\n\\\begin{document}\n\\scriptsize\n" > $output_file 
cat /dev/null > $profile_file

echo "----------------------------------"
echo "LaTeX Output: "$output_file
echo "Profiling Output: "$profile_file
echo "Limit on copy rule: "$copy_limit
echo "----------------------------------"

counter=0

while read seq  ; 
do
  counter=$((counter+1))
  echo -e "%Proving "$seq"\n" >> $output_file;
  title=`echo "red in PL-SYNTAX  : toTex($seq) ." | $maude_command $MAUDE_FILES_DIR/PL-Theory.maude | grep String | grep -o 'result String.*' | sed -e s/\"//g -e s/result\ String\://g`
  echo -e "\\\TitleSeqC{$counter}{$title}\n" >> $output_file ;

  #Proving in LJ
  echo "("$counter") Processing LJ ..."$seq ;
  maude_ins="red in LJ-ENC : proveIt("$seq") . " ;
  str=`$timeout_cmd echo $maude_ins | $maude_command $MAUDE_FILES_DIR/translation-LJ`;
  if [[ $str == *"result"* ]] ;then
      str_time=`echo $str | grep -o '[0-9]*ms real' | grep -o '[0-9]*'` 
      echo "$seq ; LJ ; $str_time" >> $profile_file ;
      echo -e "\\\wrapProof{LJ}{$str_time}{" >> $output_file;
      echo -e $str | grep -o 'result String.*' |  sed -e s/\"//g -e s/result\ String\://g -e s/"Maude> Bye."//g >> $output_file
      echo "}" >> $output_file;
  else
      echo "Timeout";
      echo "$seq ; LJ ; timeout" >> $profile_file ;
      echo -e "\\\wrapProof{LJ}{\\\timeout}{timeout}\n" >> $output_file ;
  fi

  # Executing the different translations
  for bench in $translations 
  do
    echo "Processing [$bench]... "$seq ;
    #echo -e "\\\noindent $bench encoding" >> $output_file ;
    maude_ins="red in $bench : proveIt($copy_limit,"$seq") . " ;

    str=`$timeout_cmd echo $maude_ins | $maude_command $MAUDE_FILES_DIR/translations-ILL`;

    if [[ $str == *"result"* ]] ;then
      str_time=`echo $str | grep -o '[0-9]*ms real' | grep -o '[0-9]*'` 
      echo "$seq ; $bench ; $str_time" >> $profile_file ;
      #echo -e " (runtime:"$str_time")\n" >> $output_file;
      echo -e "\\\wrapProof{$bench encoding}{$str_time}{" >> $output_file;
      echo -e $str | grep -o 'result String.*' |  sed -e s/\"//g -e s/result\ String\://g -e s/"Maude> Bye."//g >> $output_file
      echo "}" >> $output_file;
    else
      echo "Timeout";
      echo "$seq ; $bench ; timeout" >> $profile_file ;
      echo -e "\\\wrapProof{$bench encoding}{\\\timeout}{timeout}\n" >> $output_file ;
    fi
  done

  echo -e "\\\vfill\\\eject" >> $output_file;
done
echo -e "\\end{document}" >> $output_file 
  
echo "DONE!"
echo "----------------------------------"
echo "LaTeX Output: "$output_file
echo "Profiling Output: "$profile_file
echo "Limit on copy rule: "$copy_limit
echo "----------------------------------"
