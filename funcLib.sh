#!/bin/sh
# only functions here
# call this file as: . ./Demo/file equivalent of source
fn_Line () {
   echo ""; echo ""; clear;
   DMMrot=$(echo $(pwd)); ### to make sure
   l64chrs="---------------------------------------------------------------";
   printf "%b\n\n" "${l64chrs}";
}

fn_prompt () {
  # USE AS: if ui_prompt "Press Y/yes to confirm (N/n cancel): ";
    local yn="";
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

fn_this () {
   local lstF=""; local fl=""; local rp="";
   local tDir="";

   echo "Hello World ${DMMrot}\n\n";

   tDir=$(dirname "$0");
   rp=$(readlink -f "${tDir}/funcLib.sh");

   echo "\tScript Dir: ${tDir} Script Path: ${rp}";
###Some sinister reaction is source [. ./Demo/file name]
###For some reason did not accept a full path to file

}
