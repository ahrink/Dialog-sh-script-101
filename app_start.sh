#!/bin/sh
#
# app_start.sh
#
start_app () {
   # this is easy if working
   ui_Line;

   # start evaluation
   local ckFile=$(echo $(pwd)"/Demo/ini_Demo.ahr");
   ini_eval "${ckFile}";

# If code did not exit yet “we” may uncomment to see why
#   echo "APP 1: ${ckEval}";
#   echo "\tWhat is DMMrot?: ${DMMrot}";
#   echo "\tWhat is DMMini?: ${DMMini}";

   if [ "${ckEval}" = "pass" ]; then
      local StartAPP="${DMMrot}/Demo/mm_app.sh";
      
      # source is a problem of portable code
      #source "${StartAPP}"
      # what is "${StartAPP}"
      ###cat "${StartAPP}"
      # !!! do not source just run
      # to make a point here "we" need the minimum Dialog setup

      sh "${StartAPP}";
   fi

}

ini_eval () {
   # Expecting a file to evaluate
   # the grep 'ini=' is hard coded to prevent accidental use
   #
   local mText=""; local mSrc="";
   local k=""; local v=""; local gStr="";
   local mEQ=""; local fName=$1; ckEval="";

   if [ -f "${fName}" ]; then

      # create index and extract -f2
      mText=$(cat "${fName}");
      gStr=$(echo "${mText}" | grep 'ini=' | cut -d'|' -f2);
      gStr=$(echo "${gStr}" | cut -d'=' -f2);

      # establish a foreach group
      for k in $(echo "${gStr}" | tr ',' '\n'); do

         # a matched k
         for mSrc in $(echo "${mText}" | cut -d'|' -f3); do
            mEQ=$(echo "${mSrc}" | cut -d'=' -f1);
            if [ "${mEQ}" = "${k}" ]; then
               # echo "Matched: ${mSrc}";
               # note the key value in ini
               v=$(echo "${mSrc}" | cut -d'=' -f2);
               eval $(echo "$k=$v");

               if [ "${v}" = "$(echo $(pwd))" ]; then
                        ckEval="pass";
               fi
            fi
         done
      done

   else
        echo "Failed evaluation! [file app_start.sh] function [ini_eval]";
        exit 1;
   fi
# note: ckEval is global var not local
}

ui_Line () {
   clear;
   l64chrs="---------------------------------------------------------------";
   printf "%b" "${l64chrs}\n\n";
}

ini_Dialog () {
   # the grep 'mma=' is hard coded to prevent accidental use
   #
   local mText=""; local mSrc="";
   local k=""; local v=""; local gStr="";
   local mEQ=""; local fName=$1; ckEval="";

   if [ -f "${fName}" ]; then
      # the point is mma=
      mText=$(cat "${fName}");
      gStr=$(echo "${mText}" | grep 'mma=' | cut -d'|' -f2);
      gStr=$(echo "${gStr}" | cut -d'=' -f2);

      # establish a foreach group
      for k in $(echo "${gStr}" | tr ',' '\n'); do

         # a matched k in a config file
         for mSrc in $(echo "${mText}" | cut -d'|' -f3); do
            mEQ=$(echo "${mSrc}" | cut -d'=' -f1);
            if [ "${mEQ}" = "${k}" ]; then
               v=$(echo "${mSrc}" | cut -d'=' -f2);
               eval $(echo "$k=$v");
            fi

         done

      done

   fi

}

start_app;
