#!/bin/bash

#
# Этот скрипт создает скелет для будущего микросервиса
#

SKEL_SRC="$(dirname "$0")"
REPO=""

function appDialog {
    DOCKER_BUNDLE=$(whiptail \
        --title "Создание структуры микросервиса" \
        --radiolist "Какие бандлы установить?" 20 70 15 \
        "laravel-app" "Laravel App (Nginx, PHP, Mysql)" OFF \
        "openresty-app" "Openresty App (Nginx, Lua)" OFF \
        3>&1 1>&2 2>&3)

    if [[ $? != 0 ]] || [[ "$DOCKER_BUNDLE" == "" ]]; then
        exit 1
    fi
}

function cloneRepo {
    git clone "$REPO" .
    if [[ $? != 0 ]]; then
        exit 1
    fi
    rm -rf ./.git
    git init
}

function installApp {
    case "$DOCKER_BUNDLE" in
        openresty-app)
            REPO="$SKEL_SRC/.repo/openresty-app/.git"
            cloneRepo
        ;;
        laravel-app)
            REPO="$SKEL_SRC/.repo/laravel-app/.git"
            cloneRepo
        ;;
        *)
            echo No such bundle: "$DOCKER_BUNDLE"
    esac
}

#
# RUN
#

appDialog
installApp

