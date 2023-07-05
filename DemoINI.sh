#!/bin/sh
#

ini_FileNdx () {
   local NdxFile=$1; local varNdx=""; local tCnt=1;
   local NdxLne=""; local fClone="${NdxFile}.tmp";
   local varNdx=$(cat "${NdxFile}");

   if [ ! -f "${fClone}" ]; then
        touch "${fClone}";
   else
        rm "${fClone}";
        sleep 1;
        touch "${fClone}";
   fi

   for NdxLne in $(echo "${varNdx}"); do
        echo "${tCnt}|${NdxLne}" >> "${fClone}";
   tCnt=$(($tCnt + 1));
   done

   rm "${NdxFile}";
   mv "${fClone}" "${NdxFile}";
   sleep 1;
}

ini_DirCre () {
   local MMdir=$1; local MMcnt=1;
   echo "Directory Structure";
   for v in $(echo "${MMdir}" | tr ',' '\n') ; do

        if [ ! -d "${v}" ]; then
                mkdir -p "${v}";
                echo "\t${MMcnt}. Created: ${v}";
        else
                echo "\t${MMcnt}. Directory Exists: ${v}";
        fi

   MMcnt=$(($MMcnt + 1));
   done
}
ini_Str2File () {
   #
   local grpName=$1; local grpKey=$2; local grpDsc=$3;
   local grpFile=$4;
   local iDate=$(date +"%Y%m%d%H%M%S");

   # create ini file
   if [ ! -f "${grpFile}" ]; then
        echo "\nConfig File NOT found: ${grpFile}";
        touch "${grpFile}";
        echo "\t\tCreated File: ${grpFile}";
   fi

   # replace 1st occurance
   local grpKey=$(echo "${grpKey}" | sed "s/://");

   # Group is an array of keys  (pOne/Part One)
   # cumulate keys in a group
   local pOne=""; local k=""; local eqKey="";
   local pTwo=""; local eqVal=""; local dk="";

   for k in $(echo "${grpKey}" | tr ':' '\n'); do
        eqKey=$(echo "${k}" | cut -d'=' -f1);
        eqVal=$(echo "${k}" | cut -d'=' -f2);
        pOne="${pOne},${eqKey}";
        pTwo="${pTwo}:${eqKey}=${eqVal}";
   done

   pOne=$(echo "${pOne}" | sed "s/,//");
   pOne="${grpName}=${pOne}|";
   pTwo=$(echo "${pTwo}" | sed "s/://");

   # the last part is to combine pOne+pTwo+Description+Date
   local k=""; local outrCt=1;
   local grpDsc=$(echo "${grpDsc}" | sed "s/ /.+./g");

   for dk in $(echo "${grpDsc}" | tr ',' '\n'); do
        local inrCnt=1;
        for k in $(echo "${pTwo}" | tr ':' '\n'); do
           if [ "${inrCnt}" -eq "${outrCt}" ]; then
                echo "${pOne}${k}|${dk}|${iDate}" >> "${grpFile}";
                sleep 1;
                echo "\tAdd: ${pOne}${k}|${dk}|${iDate}";
           fi

        inrCnt=$(($inrCnt + 1));
        done

   outrCt=$(($outrCt + 1));
   done
}

about_this () {
   #
   local ckVer=""; local VerBash=""; local VerCoreUtl=""; local VerDialog="";
   local VerBash=$(echo $(bash --version | cut -d',' -f2));
   local VerBash=$(echo "${VerBash}" | cut -d' ' -f2 | cut -d'.' -f1,2);
   local VerBash=$(echo "(${VerBash}/1)" | bc);

   local VerCoreUtl=$(echo $(dd --version | cut -d' ' -f3));
   local VerCoreUtl=$(echo "${VerCoreUtl}" | cut -d' ' -f1);
   local VerCoreUtl=$(echo "(${VerCoreUtl}/1)" | bc);

   local VerDialog=$(echo $(dialog --version | cut -d' ' -f2));
   local VerDialog=$(echo "${VerDialog}" | cut -d'-' -f1);
   local VerDialog=$(echo "(${VerDialog}/1)" | bc);

   ui_Line;

   if [ "${VerBash}" -lt 5 ]; then
        ckVer="${ckVer}\t\tRequires Bash version 5 or greater\n";
   fi

   if [ "${VerCoreUtl}" -lt 8 ]; then
        ckVer="${ckVer}\t\tRequires GNU CoreUtilities version 8 or greater\n";
   fi

   if [ "${VerDialog}" -lt 1 ]; then
        ckVer="${ckVer}\t\tRequires Dialog version 1 or greater\n";
   fi

   if [ ! -z "${ckVer}" ]; then
        printf "%b"  "${ckVer}";
        exit 1;
   fi

   # app structure and initialization
   local DMMrot=$(echo $(pwd));
   local DMMwrk="${DMMrot}/Demo";
   local DMMtmp="${DMMrot}/zDtmp";
   local DMMfle="${DMMtmp}/mm_Temp.ahr";
   local DMMapp="${DMMwrk}/mm_app.sh";
   local DMMini="${DMMwrk}/ini_Demo.ahr";
   local DMMtxt="${DMMwrk}/ChineseQ.ahr";
   local DMMstart="${DMMrot}/app_start.sh";
   local DMMbkp="${DMMrot}/zBkup";
   
   # create structure/workspace
   local dirNames="${DMMwrk},${DMMtmp},${DMMbkp}";
   ini_DirCre "${dirNames}";

   # create Dialog temporary file (DMMfle)
   echo "Dialog temporary file";
   if [ ! -f "${DMMfle}" ]; then
        touch "${DMMfle}";
        echo "\tCreated File: ${DMMfle}";
   else
        echo "\tFile Exists: ${DMMfle}";
   fi

   # mapping names  k=v prospective (cumulate manipulate)
   if [ ! -f "${DMMini}" ]; then

     ## group ver
     local GiniDsc="Bash Version,CoreUtil Version,Dialog Version";
     local GiniVar="VerBash,VerCoreUtl,VerDialog";
     local k=""; local res="";

     # pack the key=val for further needs
     for k in $(echo "${GiniVar}" | tr ',' '\n'); do
        res=$(eval echo \${$k});
        rkey="${rkey}:${k}=${res}";
     done

     # call the config writer
     ini_Str2File "ver" "${rkey}" "${GiniDsc}" "${DMMini}";

     ## group loc
     local k=""; local rkey=""; local res="";
     local GlocDsc="Directory Path,Configuration File";
     local GlocVar="DMMrot,DMMini";

     # loc-pack the key=val
     for k in $(echo "${GlocVar}" | tr ',' '\n'); do
        res=$(eval echo \${$k});
        rkey="${rkey}:${k}=${res}";
     done

     ini_Str2File "loc" "${rkey}" "${GlocDsc}" "${DMMini}";

     ## group mma
     local k=""; local rkey=""; local res="";
     local GmmaDsc="Dialog Work Space,Dialog TMP-Folder,Dialog TMP-File,Dialog Application";
     local GmmaVar="DMMwrk,DMMtmp,DMMfle,DMMapp";

     # mma-pack the key=val
     for k in $(echo "${GmmaVar}" | tr ',' '\n'); do
        res=$(eval echo \${$k});
        rkey="${rkey}:${k}=${res}";
     done

     ini_Str2File "mma" "${rkey}" "${GmmaDsc}" "${DMMini}";

     ## reindex config file
     ini_FileNdx "${DMMini}";
     
     ## move files where they belong
     mv "${DMMrot}/mm_app.sh" "${DMMapp}";  # mm_app.sh
     mv "${DMMrot}/ChineseQ.ahr" "${DMMtxt}"; # ChineseQ.ahr
     
     # copy components to backup
     cp "${DMMapp}" "${DMMbkp}/mm_app.sh";
     cp "${DMMtxt}" "${DMMbkp}/ChineseQ.ahr";
     cp "${DMMstart}" "${DMMbkp}/app_start.sh";
     cp "${DMMrot}/DemoINI.sh" "${DMMbkp}/DemoINI.sh";
     cp "${DMMini}" "${DMMbkp}/ini_Demo.ahr"
     rm "${DMMrot}/DemoINI.sh";
     chmod +x "${DMMapp}";
     chmod +x "${DMMstart}";

     echo "Backup Complete to: ${DMMbkp}";
     ls -l "${DMMbkp}";
     
   fi

   ui_twoLine;
   echo "Display Config File: ${DMMini}";
   cat "${DMMini}";

   # the only file left in the inner directory is app_start.sh
   ls -l;
   
   echo "\n\n\tPlease run: sh ${DMMstart}";
}

ui_prompt () {
  # USE AS: if ui_prompt "Press Y/yes to confirm (N/n cancel): ";
    while true; do
        read -p "$1 " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

ui_Line () {
   clear;
   DMMrot=$(echo $(pwd)); ### to make sure
   l64chrs="---------------------------------------------------------------";
   printf "%b" "${l64chrs}\n\n";
}

ui_twoLine () {
   echo ""; echo "";
}

about_this;

