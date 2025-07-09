#!/usr/bin/env zsh

# brew packages
printf "\e[1;31mUpdating brew...\e[0m\n"
brew update-reset
brew upgrade --greedy
printf "Done!\n"

# brew cleanup
printf "\e[1;31m\nClean unsused brew packages...\e[0m\n"
brew cleanup -s
printf "Done!\n"

# brew diagnotic
printf "\e[1;31m\nDiagnosting brew...\e[0m\n"
brew doctor
brew missing
printf "Done!\n"

# composer
printf "\e[1;31m\nUpdating PHP packages (composer)...\e[0m\n"
composer global update
printf "Done!\n"

# pnpm
printf "\e[1;31m\nUpdating global pnpm packages...\e[0m\n"
pnpm upgrade --global --latest
printf "Done!\n"

# macOs
printf "\e[1;31m\nUpdating mas...\e[0m\n"
mas upgrade
printf "Done!\n"

# Check for software updates
printf "\e[1;31m\nCheck for macOs updates...\e[0m\n"
updateList=`softwareupdate -l 2>&1` #2>&1 redirects stderr to stdout so it'll be available to grep.  No New software available is a STDERR message instead of STDOUT
nextWeek=`date -v +1d +%m-%d-%Y`
updatesNeeded=`echo "$updateList" |grep "No new software available"`
hasError=`echo $updateList |grep "load data from the Software Update server"`

`echo "$updateList" > /tmp/appleSWupdates.txt`

if [[ ! $updatesNeeded =~ "No new software available" ]]; then
    if [[ ! $hasError =~ "Can't load data from the Software Update server" ]]; then
        updateMiniList=`echo "$updateList" |grep \*`   #gives list of updates with no other crap
        echo "$updateMiniList"| while read line; do
            jssPolicy=`echo "$line" |sed 's/\* //g'`
            appNameWithWhiteSpace=`echo "$updateList" |grep -A1 "$jssPolicy"|tail -1|awk -F\( '{print $1}'`
            appName="$(echo "${appNameWithWhiteSpace}" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
            latestVersion=`echo "$updateList" |grep -A1 "$jssPolicy"|tail -1|awk -F\( '{print $2}'|awk -F\) '{print $1}'`
            installBy="$nextWeek 11:30"
            rebootNeeded=`echo "$updateList" |grep -A1 "$jssPolicy"|tail -1|grep restart`
            if [[ -z $rebootNeeded ]]; then
                rebootStatus=false
            else
                rebootStatus=true
                printf "Your system needs a reboot\n"
            fi

            printf "{source:\"Apple\",appName:\"$appName\",appVersion:\"$latestVersion\",jssPolicy:\"$jssPolicy\",dueDate:\"$installBy\",appInstallChk:true,reboot:$rebootStatus}"
        done
    fi
else
  printf "No new software available\n"
fi
printf "Done!\n"
