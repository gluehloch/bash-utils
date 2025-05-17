#!/bin/bash
# (C) Andre Winkler 2014
args=("$@")

### AWI TODO
### jspack is missing!

BUILD=false
CLEAN=false
DEBUG=false

PROJECT_ROOT=`pwd`

usage() {
    echo "Init workspace"
    echo "  -d <directory> --directory the name of the directory"
    echo "  -b --build Start building after checkout"
    echo "  -c --clean Clean and delete the workspace before checkout"
    echo "  -h --help Print this"
    echo "  -h --help Print this"
    echo ""
}

while [ "$1" != "" ]; do
    case $1 in
        --debug )       DEBUG=true
                        ;;
        -d | --directory ) shift
                        PROJECT_ROOT=$1
                        if [ -z "$PROJECT_ROOT" ]; then
                            echo "There is a missing directory parameter!"
                            usage
                            exit 1
                        fi
                        ;;
        -b | --build )  BUILD=true
                        ;;
        -c | --clean )  CLEAN=true
                        ;;
        -h | --help )   usage
                        exit
                        ;;
        * )             usage
                        exit 1
    esac
    shift
done

if [ "$DEBUG" = true ]; then
    echo "Building: $BUILD CLeaning: $CLEAN Directory: '$PROJECT_ROOT'"
fi

export PROJECT_MAVEN_POM="$PROJECT_ROOT/pom"
export PROJECT_AWTOOLS="$PROJECT_ROOT/awtools"
export PROJECT_AWTOOLS_WEB="$PROJECT_ROOT/awtools-web"
export PROJECT_SWINGER="$PROJECT_ROOT/swinger"
export PROJECT_BETOFFICE="$PROJECT_ROOT/betoffice"
export PROJECT_BETOFFICE_CORE="$PROJECT_BETOFFICE/core"
export PROJECT_BETOFFICE_WEB="$PROJECT_BETOFFICE/web"
export PROJECT_MISC="$PROJECT_ROOT/misc"

echo "Project root is $PROJECT_ROOT"

#
# 1. Create project folders
#
folders=( "$PROJECT_MAVEN_POM" \
 "$PROJECT_AWTOOLS" \
 "$PROJECT_SWINGER" \
 "$PROJECT_BETOFFICE" \
 "$PROJECT_MISC")

if [ "$CLEAN" = true ]; then
    for index in $(seq 0 $((${#folders[@]} - 1)))
    do
        folder="${folders[index]}"
        echo "CLEAN project from ${folder}"
        rm -r -f "${folder}"
    done
fi
 
for index in $(seq 0 $((${#folders[@]} - 1)))
do
    folder="${folders[index]}"
    echo "Build project ${folder}"
    mkdir -p "${folder}"
done

#
# Clone or export all my Maven parent POMs
# 
git clone https://github.com/gluehloch/awtools-maven-pom/ \
 "$PROJECT_MAVEN_POM/awtools-maven-pom"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-pom \
 "$PROJECT_MAVEN_POM/betoffice-pom"

#
# AWTools COMMONS on Sourceforge / Github
#
svn co https://svn.code.sf.net/p/betoffice/svn/awtools/awtools-basic/trunk \
 "$PROJECT_AWTOOLS/awtools-basic_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/awtools/awtools-beanutils/trunk \
 "$PROJECT_AWTOOLS/awtools-beanutils_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/awtools/awtools-config/trunk \
 "$PROJECT_AWTOOLS/awtools-config_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/awtools/awtools-mail/trunk \
 "$PROJECT_AWTOOLS/awtools-mail_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/awtools/awtools-lang/trunk \
 "$PROJECT_AWTOOLS/awtools-lang_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/awtools/awtools-xml/trunk \
 "$PROJECT_AWTOOLS/awtools-xml_TRUNK"

git clone git@github.com:gluehloch/dbload.git \
 "$PROJECT_MISC/dbload"
git clone git@github.com:gluehloch/andre-winkler-it.git \
 "$PROJECT_MISC/andre-winkler-it"
git clone git@github.com:gluehloch/jspack.git \
 "$PROJECT_MISC/jspack"

 
#
# AWTools Homepgae
#
git clone git@bitbucket.org:andrewinkler/awtools-homegen.git \
 "$PROJECT_AWTOOLS_WEB/awtools-homegen"
git clone git@bitbucket.org:andrewinkler/awtools-homegen-js.git \
 "$PROJECT_AWTOOLS_WEB/awtools-homegen-js"

#
# AWTools for Swing
#
svn co https://svn.code.sf.net/p/betoffice/svn/swinger/commons/trunk \
 "$PROJECT_SWINGER/swinger-commons_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/swinger/commands/trunk \
 "$PROJECT_SWINGER/swinger-commands_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/swinger/tree/trunk \
 "$PROJECT_SWINGER/swinger-tree_TRUNK"
svn co https://svn.code.sf.net/p/betoffice/svn/swinger/concurrent/trunk \
 "$PROJECT_SWINGER/swinger-concurrent_TRUNK"

#
# BETOFFICE CORE
#
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-pom \
 "$PROJECT_BETOFFICE_CORE/betoffice-pom"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-testutils \
 "$PROJECT_BETOFFICE_CORE/betoffice-testutils"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-storage \
 "$PROJECT_BETOFFICE_CORE/betoffice-storage"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-openligadb \
 "$PROJECT_BETOFFICE_CORE/betoffice-openligadb"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-exchange \
 "$PROJECT_BETOFFICE_CORE/betoffice-exchange"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-batch \
 "$PROJECT_BETOFFICE_CORE/betoffice-batch"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-swing \
 "$PROJECT_BETOFFICE_CORE/betoffice-swing"
git clone ssh://andrewinkler@git.code.sf.net/p/betoffice/betoffice-test \
 "$PROJECT_BETOFFICE_CORE/betoffice-test"

#
# BETOFFICE WEB
#
git clone git@bitbucket.org:andrewinkler/betoffice-jweb.git \
 "$PROJECT_BETOFFICE_WEB/betoffice-jweb"
git clone git@bitbucket.org:andrewinkler/betoffice-js.git \
 "$PROJECT_BETOFFICE_WEB/betoffice-js"
git clone git@bitbucket.org:andrewinkler/betoffice-home.git \
 "$PROJECT_BETOFFICE_WEB/betoffice-home"
git clone git@bitbucket.org:andrewinkler/betoffice-jadmin.git \
 "$PROJECT_BETOFFICE_WEB/betoffice-jadmin"

#
# Building...
#
LOGFILE=build.log

projects=( "$PROJECT_MAVEN_POM/awtools-maven-pom" \
 "$PROJECT_MAVEN_POM/betoffice-pom_TRUNK" \
 "$PROJECT_AWTOOLS/awtools-basic_TRUNK" \
 "$PROJECT_AWTOOLS/awtools-beanutils_TRUNK" \
 "$PROJECT_AWTOOLS/awtools-config_TRUNK" \
 "$PROJECT_AWTOOLS/awtools-mail_TRUNK" \
 "$PROJECT_AWTOOLS/awtools-lang_TRUNK" \
 "$PROJECT_AWTOOLS/awtools-xml_TRUNK" \
 "$PROJECT_SWINGER/swinger-commons_TRUNK" \
 "$PROJECT_SWINGER/swinger-commands_TRUNK" \
 "$PROJECT_SWINGER/swinger-tree_TRUNK" \
 "$PROJECT_SWINGER/swinger-concurrent_TRUNK" \
 "$PROJECT_BETOFFICE_CORE/betoffice-storage_TRUNK" \
 "$PROJECT_BETOFFICE_CORE/betoffice-openligadb_TRUNK" \
 "$PROJECT_BETOFFICE_CORE/betoffice-exchange_TRUNK" \
 "$PROJECT_BETOFFICE_CORE/betoffice-batch_TRUNK" \
 "$PROJECT_BETOFFICE_CORE/betoffice-swing_TRUNK" \
 "$PROJECT_BETOFFICE_WEB/betoffice-jweb_TRUNK" \
 "$PROJECT_AWTOOLS_WEB/awtools-homegen" \
)

if [ "$BUILD" = true ]; then
    echo "Start building..."
    echo ${#projects[@]} 
    for index in $(seq 0 $((${#projects[@]} - 1)))
    do
        project=${projects[index]}
        echo "Build project ${project}"
        cd "$project"
        mvn clean install | tee ${LOGFILE}
        cd ..
    done
fi

exit 0


