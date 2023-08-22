#!/bin/bash

#Version
get-version(){
    version=$( sed -n 's/.*"version":.*"\(.*\)"\(,\)\{0,1\}/\1/p' "./package.json" )
    echo $version
}
compare-versions(){
    isEqual=true;
    v1=( $( echo "$1" | tr '.' ' ' ) )
    v2=( $( echo "$2" | tr '.' ' ' ) )

    if [ "${v1[0]}" != "${v2[0]}" ]; then 
        isEqual=false
        echo "Major version does not match" >&2
    fi

    if [ "${v1[1]}" != "${v2[1]}" ]; then 
        isEqual=false
        echo "Minor version does not match" >&2
    fi

    if [ "${v1[2]}" != "${v2[2]}" ]; then 
        # I might not need this
        isEqual=false
        echo "Patch version does not match" >&2
    fi

    echo $isEqual
}

#Version Injection
inject-appversion-metadata-tag(){
    #NOTE: right now this just replaces the text INSERT_RELEASE_VERSION with the version
    # it doesn't actually append the metadata tag...yet
     echo -e "----- Appending the Version to Index File -----"
    version=$(get-version)

    #Update the dist/index.html metadata with new version - so can display in app
    textReplaceTarget="{INSERT_RELEASE_VERSION}"
    sed -i "s/$textReplaceTarget/$version$1/" "dist/index.html"
}

#html helpers
find-metadata-tag(){
    find-metadata-tag "{INSERT HTML CONTENT}" "version")

    content=$1;
    searchTarget="<meta property='$2'"
    endBracket="/>"

    tagStart=$(strindex "$content" "$searchTarget")
    tagLength=$(($(strindex "${content:$tagStart}" "/>") + 2))

    tag=${content:$tagStart:$tagLength};
    echo $tag
}

#string manipulation
strindex() { 
  x="${1%%"$2"*}"
  [[ "$x" = "$1" ]] && echo -1 || echo "${#x}"
}