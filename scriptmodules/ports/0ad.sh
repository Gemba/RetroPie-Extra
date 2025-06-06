#!/usr/bin/env bash
 
# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="0ad"
rp_module_desc="0ad - Battle of Survival - is a futuristic real-time strategy game"
rp_module_licence="GNU https://libregamewiki.org/GNU_General_Public_License"
rp_module_section="exp"
rp_module_flags="!mali rpi4 rpi5"

function depends_0ad() {
    getDepends xorg matchbox
}

function install_bin_0ad() {
    aptInstall 0ad
}

function configure_0ad() {
    local script="$md_inst/$md_id.sh"
    moveConfigDir "$home/.0ad" "$md_conf_root/$md_id"

    cat > "$script" << _EOF_
#!/bin/bash
xset -dpms s off s noblank
matchbox-window-manager -use_titlebar no &
/usr/games/0ad
_EOF_

    chmod +x "$script"
    addPort "$md_id" "0ad" "0A.D - Battle of Survival" "XINIT:$script"
}