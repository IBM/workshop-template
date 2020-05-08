#!/bin/bash

clean_tempClones(){
    rm -rf tempClones
}

clean_generatedContent(){
    rm -rf workshop/generatedContent/*
    rm workshop/generatedContentLinks.md
}

do_the_thing(){
    grep -v '^ *#' < agenda.txt | while IFS= read -r repo; do
        echo "adding $repo to agenda"
        workshopName=$(basename "$repo")
    	git clone "$repo" tempClones/"$workshopName"
        if [[ -d tempClones/"$workshopName"/workshop ]]; then
            cp -a tempClones/"$workshopName"/workshop workshop/generatedContent/"$workshopName"
        else
            rm -rf tempClones/"$workshopName"/.git*
            cp -a tempClones/"$workshopName" workshop/generatedContent/"$workshopName"
        fi
    	echo "* [generatedContent/$workshopName](generatedContent/$workshopName/README.md)" >> workshop/generatedContentLinks.md
    	for lab in workshop/generatedContent/"$workshopName"/*/*; do
            [[ -d "$lab" ]] || break
    		labName=$(basename "$lab")
    		echo "    * [generatedContent/$workshopName/$labName](generatedContent/$workshopName/$labName/README.md)" >> workshop/generatedContentLinks.md
    		echo "Lab -> $(basename "$lab")"
    	done
    	echo "This content is generated! Do not edit directly! Please run aggregate-labs.sh to repopulate with latest content from agenda.txt!" > workshop/generatedContent/README.md
    done
}

main(){
    pushd "$(dirname "$0")" || exit 1
    if [[ -d tempClones ]]; then
        clean_tempClones
     fi
    mkdir -p tempClones workshop/generatedContent
    clean_generatedContent
    do_the_thing
    clean_tempClones
    popd || exit 1
}

main
