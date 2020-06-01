#!/bin/bash

clean_tempClones(){
    rm -rf tempClones
}

clean_generatedContent(){
    rm -rf workshop/generatedContent/*
    rm workshop/generatedContentLinks.md
}

do_the_thing(){
    
    for repoPath in `yq r agenda.yaml --printMode p "repos.*"`; do

        repo=`yq r agenda.yaml --printMode v "$repoPath.url"`
        BRANCH=`yq r agenda.yaml --printMode v "$repoPath.branch"`
        if [[ -z $BRANCH ]]; then
            BRANCH="master"
        fi

        echo ""
        echo "Cloning $repo..."
        workshopName=$(basename "$repo")
    	git clone --quiet "$repo" tempClones/"$workshopName"

        cd tempClones/"$workshopName"
        echo "Checking out branch $BRANCH..."
        git checkout --quiet $BRANCH
        cd ../..

        GITBOOK_YAML="tempClones/"$workshopName"/.gitbook.yaml"
        if [[ -z $GITBOOK_YAML ]]; then
            echo "Not a gitbook... skipping!"
            continue
        fi

        GITBOOK_ROOT=`yq r tempClones/"$workshopName"/.gitbook.yaml root`
        if [[ -z "GITBOOK_ROOT" ]]; then
            echo "Error reading gitbook... skipping!"
            continue
        fi
        echo "Found Gitbook root at $GITBOOK_ROOT"


        CLONED_REPO_ROOT=tempClones/"$workshopName"
        WORKSHOP_PATH="$CLONED_REPO_ROOT"/"$GITBOOK_ROOT"

        echo "Cleaning up any .git files from cloned repo"
        rm -rf "$CLONED_REPO_ROOT"/.git*


        GENERATED_CONTENT_PATH=workshop/generatedContent/"$workshopName"
        echo "Copying over content to $GENERATED_CONTENT_PATH"
        if [[ -d $WORKSHOP_PATH ]]; then
            cp -a $WORKSHOP_PATH $GENERATED_CONTENT_PATH
        else
            cp -a $CLONED_REPO_ROOT $GENERATED_CONTENT_PATH
        fi

        GENERATED_CONTENT_LINKS_MD="workshop/generatedContentLinks.md"
        echo "Generating links in $GENERATED_CONTENT_LINKS_MD"

        printf "###############################\n" >> $GENERATED_CONTENT_LINKS_MD
        printf "##  SUMMARY.md for $workshopName\n" >> $GENERATED_CONTENT_LINKS_MD
        printf "################################\n\n" >> $GENERATED_CONTENT_LINKS_MD
        printf "# Home Page for Gitbook \n" >> $GENERATED_CONTENT_LINKS_MD
        printf "* [$workshopName](generatedContent/$workshopName/README.md)\n\n" >> $GENERATED_CONTENT_LINKS_MD

	    SUMMARY_MD="$GENERATED_CONTENT_PATH"/SUMMARY.md
        if [[ -f $SUMMARY_MD ]]; then
            sed "s/\[\(.*\)\](\(.*\))/\[\1\](generatedContent\/$workshopName\/\2)/" $SUMMARY_MD >> $GENERATED_CONTENT_LINKS_MD
        fi

        printf "\n\n" >> $GENERATED_CONTENT_LINKS_MD


    done

    echo "This content is generated! Do not edit directly! Please run aggregate-labs.sh to repopulate with latest content from agenda.txt!" > workshop/generatedContent/README.md

}

main(){
    pushd "$(dirname "$0")" > /dev/null || exit 1
    command -v yq >/dev/null 2>&1 || { echo >&2 "This script requires yq but it's not installed.  Aborting."; exit 1; }
    if [[ -d tempClones ]]; then
        clean_tempClones
     fi
    mkdir -p tempClones workshop/generatedContent
    clean_generatedContent
    printf "THIS FILE CONTAINS ALL THE SUMMARY.MDs OF THE GENERATED CONTENT PREFIXED WITH RIGHT PATH (\"generatedContent\") SO THAT YOU CAN COPY AND PASTE THIS INTO THE PARENT SUMMARY.MD" >> workshop/generatedContentLinks.md
    do_the_thing
    clean_tempClones
    popd > /dev/null || exit 1
}

main
