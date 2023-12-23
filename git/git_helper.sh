#!/bin/bash

# Alle Meldungen auf Englisch, sonst macht das Greppen keinen Sinn!
alias git='LANG=en_GB git'

function git_deleted {
    [[ $(git status 2> /dev/null | grep deleted:) != "" ]] && echo "-"
}

function git_added {
    [[ $(git status 2> /dev/null | grep "Untracked files:") ]] && echo "+"
}

function git_modified {
    [[ $(git status 2> /dev/null | grep "modified:") != "" ]] && echo "*"
}

function git_dirty {
    echo "$(git_added)$(git_modified)$(git_deleted)"
}

function git_branch {
    git branch --no-color 2> /dev/null | sed -n '/\* /s///p'
    ###git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' 
    ###-e "s/* \(.*\)/[\l$(git_dirty)]/"
    ###
}

export PS1='\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] [$(git_branch)] [$(git_dirty)] \n$ '


alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gst='git status'
alias gdw='git diff --word-diff'
alias glt='git log --no-walk --tags --pretty="%h %d %s" --decorate=full'

function git_info() {

    if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
        # print informations
        echo "git repo overview"
        echo "-----------------"
        echo

        # print all remotes and thier details
        for remote in $(git remote show); do
            echo $remote:
            git remote show $remote
            echo
        done

        # print status of working repo
        echo "status:"
        if [ -n "$(git status -s 2> /dev/null)" ]; then
            git status -s
        else
            echo "working directory is clean"
        fi

        # print at least 5 last log entries
        echo 
        echo "log:"
        git log -5 --oneline
        echo 

    else
        echo "you're currently not in a git repository"
    fi
}

function git_stats {
    if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
        echo "Number of commits per author:"
        git --no-pager shortlog -sn --all
        AUTHORS=$( git shortlog -sn --all | cut -f2 | cut -f1 -d' ')
        LOGOPTS=""
        if [ "$1" == '-w' ]; then
            LOGOPTS="$LOGOPTS -w"
            shift
        fi
        if [ "$1" == '-M' ]; then
            LOGOPTS="$LOGOPTS -M"
            shift
        fi
        if [ "$1" == '-C' ]; then
            LOGOPTS="$LOGOPTS -C --find-copies-harder"
            shift
        fi
        for a in $AUTHORS
        do
            echo '-------------------'
            echo "Statistics for: $a"
            echo -n "Number of files changed: "
            git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f3 | sort -iu | wc -l
            echo -n "Number of lines added: "
            git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f1 | awk '{s+=$1} END {print s}'
            echo -n "Number of lines deleted: "
            git log $LOGOPTS --all --numstat --format="%n" --author=$a | cut -f2 | awk '{s+=$1} END {print s}'
            echo -n "Number of merges: "
            git log $LOGOPTS --all --merges --author=$a | grep -c '^commit'
        done
    else
        echo "you're currently not in a git repository"
    fi
}

function git_remove_missing_files() {
    git ls-files -d -z | xargs -0 git update-index --remove
}


