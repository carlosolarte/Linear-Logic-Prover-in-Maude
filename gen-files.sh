#!/bin/bash  
#Generating TPTP-like files
#Example cat benchmark-kleene.txt | ./gen-files.sh outputDIR
#if parameter outputDIR is empty, then TPTP will be used

#Profiling file
#Output Directory
output_dir=TPTP

#Finding Maude
maude_exec=`which maude`
if [[  -z  $maude_exec  ]] ;  then
  echo "Maude not found"
  exit 1
fi

#Maude options
maude_file="translations-paper.maude"
maude_options="-no-banner -no-advise -no-wrap -batch"
maude_command="$maude_exec $maude_options "
translations="MULTIPLICATIVE CALL-BY-NAME CALL-BY-VALUE ZERO-ONE"
tra_name=("MU" "GI" "CBV" "01")

set +o histexpand

#Output file
if [[ !  -z  $1  ]] ;  then
  output_dir=$1
fi

counter=0
while read seq  ; 
do
  counter=$((counter+1))
  i=0
  for bench in $translations 
  do
    echo "Processing...  "$seq ;
    maude_ins="red in $bench : toILL("$seq") . " ;

    md_file_ex=`mktemp file.XXXXX`;
    cat $maude_file > $md_file_ex ;
    echo $maude_ins >> $md_file_ex;
    echo "q ." >> $md_file_ex;
    str=`$maude_command $md_file_ex`;

    if [[ $str == *"result"* ]] ;then
      output_file=$output_dir"/KLE_"$counter"_"${tra_name[$i]}".p";
      echo '%--------------------------------------------------------------------------' > $output_file;
      echo '% File     : '$output_file >> $output_file;
      echo '% Domain   :' >> $output_file ;
      echo '% Problem  : Kleene intuitionistic theorems' >> $output_file ;
      echo '% Version  : 1.0' >> $output_file;
      echo '% English  :' >> $output_file ;
      echo '% Source   : Introduction to Metamathematics' >> $output_file;
      echo '% Name     : Kleene intuitionistic theorems (Translation '${tra_name[$i]}')' >> $output_file ;
      echo '% Status   : ' >> $output_file ;
      echo '% Rating   : ' >> $output_file ;
      echo '% Comments : ' >> $output_file ;
      echo '%--------------------------------------------------------------------------' >> $output_file;
      sequent=`echo "$str" | grep -o 'result Sequent.*' | sed -e s/\"//g -e s/result\ Sequent\://g -e s/Bye.*//g -e s/empMS/nil/g -e s/\\\[emp\\\]//g -e s/\~/-/g -e s/\'//g`;
      echo "fof($sequent)" >> $output_file;
    else
      echo "Error in"$seq;
    fi
    i=$((i+1));
    rm -f $md_file_ex;
  done
done
  
echo -e "DONE!"
