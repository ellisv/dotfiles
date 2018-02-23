#!/usr/bin/env bash

[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Molokai"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="molokai"

dset() {
    local key="$1"; shift
    local val="$1"; shift

    dconf write "$PROFILE_KEY/$key" "$val"
}

# because dconf still doesn't have "append"
dlist_append() {
    local key="$1"; shift
    local val="$1"; shift

    local entries="$(
        {
            dconf read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
            echo "'$val'"
        } | head -c-1 | tr "\n" ,
    )"

    dconf write "$key" "[$entries]"
}

[[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:

if [[ ! -n "`dconf list $BASE_KEY_NEW/`" ]]; then
    echo There are no profiles to copy settings from available
    exit 1
fi

PROFILE_SLUG=`uuidgen`

if [[ -n "`dconf read $BASE_KEY_NEW/default`" ]]; then
    DEFAULT_SLUG=`dconf read $BASE_KEY_NEW/default | tr -d \'`
else
    DEFAULT_SLUG=`dconf list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
fi

DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"

# copy existing settings from default profile
dconf dump "$DEFAULT_KEY/" | dconf load "$PROFILE_KEY/"

# add new copy to list of profiles
dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"

# update profile values with theme options
dset visible-name "'$PROFILE_NAME'"
dset palette "['#1B1D1E', '#F92672', '#82B414', '#FD971F', '#56C2D6', '#8C54FE', '#465457', '#CCCCC6', '#505354', '#FF5995', '#B6E354', '#FEED6C', '#8CEDFF', '#9E6FFE', '#899CA1', '#F8F8F2']"
dset background-color "'#1C1C1C'"
dset foreground-color "'#A0A0A0'"
dset bold-color "'#FFFFFF'"
dset bold-color-same-as-fg "false"
dset use-theme-colors "false"
dset use-theme-background "false"
