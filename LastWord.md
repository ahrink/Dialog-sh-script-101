Ubuntu 22.04 Dependencies after fresh install
[if you ask me to replicate -- i woouldn't remember]
- ssh installer@IP
- the key provided is the ssh password
- setup root # no sudo in this version
   +REM: a sudo user was added during install
- apt-get dist-upgrade
- add-apt-repository universe #includes Dialog
- apt install dialog
- apt install net-tools

# backup work [file not provided Do2 infancy]
# Resides in same dir as app_start.sh
sh BkWork.sh work
sh BkWork.sh revert

# copy to archive /zDemo
#[a folder that can be compressed even w/7z]
# case: /zTest is the last install
cp -R /zTest/zBkup/* /zDemo/
rm /zDemo/ini_Demo.ahr

# REM: /zDemo holds a working Demo app

- after making changes to the Demo code,
   +a good option is to rewrite to backup directory
   +with the new-working-code as a code-version;
- except ini_Demo.ahr, all files in the backup,
   +can be used to compile a new archive or create
   +a fresh install in a different directory.
   +The original archive is a clone,
   +useful only to revert to a point in the past;
   +REM: do not backup non-working code [:0)] .

- my next project is to test same code on centos,
   +now better maintained under Rocky Linux and Alma.
   + only time can decide if freebsd is in prospective

- [not now but who knows what is DemoINI ->DMMrot]
- this Demo may include user interactive activity Qs:
  --1. [read -p] Establish a root folder for your Project;
     +a. Accordingly, DMMrot is only a default
     +b. Expect the user to change
  --2. Subfolders?
     +a. DMMwrk is a work space
     +b. DMMbkp is a backup folder
     +c. DMMtmp a Dialog chained experiment
     +d. DMMfle as a required Dialog file
     +e. DMMini custom configuration file
     +f. Etc. a look at the code
  --3. ? inspiration
     +To where your own wings can carry you

... +++example of infancy baptised BkWork.sh
#!/bin/sh
# A last revision/dressing before "in a pub"

bk_working () {
   local DMMrot=$(echo $(pwd));
cp "${DMMrot}/app_start.sh" "${DMMrot}/zBkup/app_start.sh";
cp "${DMMrot}/Demo/ChineseQ.ahr" "${DMMrot}/zBkup/ChineseQ.ahr";
cp "${DMMrot}/Demo/ini_Demo.ahr" "${DMMrot}/zBkup/ini_Demo.ahr";
cp "${DMMrot}/Demo/mm_app.sh" "${DMMrot}/zBkup/mm_app.sh";
cp "${DMMrot}/Demo/funcLib.sh" "${DMMrot}/zBkup/funcLib.sh";

ls -l "${DMMrot}/zBkup";

}

from_archive () {
   local DMMrot=$(echo $(pwd));
cp "${DMMrot}/zBkup/app_start.sh" "${DMMrot}/app_start.sh";
cp "${DMMrot}/zBkup/ChineseQ.ahr" "${DMMrot}/Demo/ChineseQ.ahr";
cp "${DMMrot}/zBkup/ini_Demo.ahr" "${DMMrot}/Demo/ini_Demo.ahr";
cp "${DMMrot}/zBkup/mm_app.sh" "${DMMrot}/Demo/mm_app.sh";
cp "${DMMrot}/zBkup/funcLib.sh" "${DMMrot}/Demo/funcLib.sh";

ls -l "${DMMrot}";
ls -l "${DMMrot}/Demo";

}

   sw="${1}";

   if [ "${sw}" = "work" ]; then
        # backup working code
        bk_working;
   fi
   if [ "${sw}" = "revert" ]; then
        # revert from backup
        from_archive;
   fi
   if [ -z "${sw}" ]; then
        echo "Switches avilable: work/revert";
   fi
# cp -R /zTest/zBkup/* /zDemo/
# rm /zDemo/ini_Demo.ahr
