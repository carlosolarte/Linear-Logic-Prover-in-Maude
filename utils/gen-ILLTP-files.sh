#!/bin/bash  
#Generating TPTP-like files
#Example cat benchmark-kleene.txt | ./gen-ILLTP-files.sh outputDIR
#if parameter outputDIR is empty, then TPTP will be used

#Profiling file
#Output Directory
output_dir=TPTP

#Where to find the prover's Maude Files
MAUDE_FILES_DIR="../maude-prover"

#Finding Maude
maude_exec=`which maude`
if [[  -z  $maude_exec  ]] ;  then
  echo "Maude not found"
  exit 1
fi
#Checking Maude prover
maude_file="$MAUDE_FILES_DIR/translations-ILL.maude"
if [ ! -f $maude_file ]; then
    echo "File $maude_file not found."
    echo "The variable MAUDE_FILES_DIR must point to the directory containing the Maude files of the prover"
    exit 1
fi

#Maude options
maude_options="-no-banner -no-advise -no-wrap -batch"
maude_command="$maude_exec $maude_options $maude_file"
translations="CALL-BY-NAME CALL-BY-VALUE 01-ENC MULTIPLICATIVE"
tra_name=("CBN" "CBV" "01" "MU")

set +o histexpand

#Output file
if [[ !  -z  $1  ]] ;  then
  output_dir=$1
fi

counter=0
set -f
while read seq  ; 
do
  counter=$((counter+1))
  i=0
  for bench in $translations 
  do
    echo "Processing...  "$seq ;
    maude_ins="red in $bench : toILL("$seq") . " ;

    str=`echo "red in $bench : toILL("$seq") . " | $maude_command `

    if [[ $str == *"result"* ]] ;then
      output_file=$output_dir"/KLE_"$counter"_"${tra_name[$i]}".p";
      echo '%--------------------------------------------------------------------------' > $output_file;
      echo '% File     : '$output_file >> $output_file;
      echo '% Domain   : Intuitionistic Syntactic ' >> $output_file ;
      echo '% Problem  : Kleene intuitionistic theorems' >> $output_file ;
      echo '% Version  : 1.0' >> $output_file;
      echo '% English  :' >> $output_file ;
      echo '% Source   : Introduction to Metamathematics' >> $output_file;
      echo '% Name     : Kleene intuitionistic theorems (Translation '${tra_name[$i]}')' >> $output_file ;
      echo '% Status   : Theorem ' >> $output_file ;
      echo '% Rating   : ' >> $output_file ;
      echo '% Comments : ' >> $output_file ;
      echo '%--------------------------------------------------------------------------' >> $output_file;
      sequent=`echo "$str" | grep -o 'result Sequent.*' | sed -e s/\"//g -e s/result\ Sequent\://g -e s/Bye.*//g -e s/empMS/nil/g -e s/\\\[emp\\\]//g -e s/\|\~/\~/g -e s/\'//g`;
      echo $sequent
      IFS='~' read -a leftright <<< "${sequent}"
      left=${leftright[0]}
      right=${leftright[1]}
      IFS=',' read -a arrleft <<< "${left}"
  
      ctax=1
      for axiom in "${arrleft[@]}"
      do
        if [[ "$axiom" !=  *"nil"* ]]; then
          echo "fof(ax$ctax, axiom, $axiom)." >> $output_file
          ctax=$((ctax+1))
        fi
      done
      echo "fof(conj, conjecture, $right)." >> $output_file
    else
      echo "Error in"$seq;
    fi
    i=$((i+1));
  done
done
  
echo -e "DONE!"
