#!/bin/bash
folderpath='/Users/KevinRobinson/Documents/LANL/scripts/git-contribs'

echo "****
Welcome to the GitHub Contributors script!
****"
echo "Enter the repo name: "
read repo
echo "Enter the project name: "
read proj
git='https://github.com/'${proj}'/'${repo}'.git'
repopath=$folderpath'/'$repo
gitpath=$repopath'/'$repo

if [ ! -d $repopath ]
then
    echo "$repopath does not exist.  Creating directory..."
    mkdir $repopath
else
continue
fi

if [ ! -d $gitpath ]
then 
    git -C $repopath clone $git
    echo "Clone complete."
    git -C $gitpath log --all --format='%aN','%aE' | sort -u > ${repopath}/${repo}-contribs.csv
    echo "Contributors file created."
else
    git -C $gitpath log --all --format='%aN','%aE' | sort -u > ${repopath}/${repo}-contribs.csv
    echo "Contributors file created."
continue
fi

myop=$(dig +short myip.opendns.com)
external='174.56.101.52'

if [ $myip=$external ]
then
    echo "No LANL IP found...
Processing through regular DNS."
    curl https://cve.mitre.org/cgi-bin/cvekey.cgi\?keyword\=$repo > $repopath/$repo.cve.results
    echo "CVE results copied."
    sed -n '/<h2>Search Results/,/For More Information:/{//!p;}' $repopath/$repo.cve.results > $repopath/$repo.cve.short
    echo "CVE results processed."
    curl https://nvd.nist.gov/vuln/search/results\?form_type\=Basic\&results_type\=overview\&query\=$repo\&search_type\=all > $repopath/$repo.nvd.results
    echo "NVD results copied."
    sed -n '/Search All/,/"footer"/{//!p;}' $repopath/$repo.nvd.results > $repopath/$repo.nvd.short
    echo "NVD results processed."
else
    echo "Internal LANL IP found..."
    curl -O -x http://proxyout1.lanl.gov:8080 https://cve.mitre.org/cgi-bin/cvekey.cgi\?keyword\=$repo > $repo.cve.results
    curl -O -x http://proxyout1.labl.gov:8080 https://nvd.nist.gov/vuln/search/results?form_type=Basic&results_type=overview&query=$repo&search_type=all > $repo.nvd.results
    sed -n '/<h2>Search Results/,/For More Information:/{//!p;}' $repo.cve.results > $repo.cve.short
    sed -n '/<h2>Search Results/,/For More Information:/{//!p;}' $repo.nvd.results > $repo.nvd.short
fi

rm -rf $gitpath/

echo "Repository removed."

