#!/usr/bin/env bash

# This file is part of RetroPie-Extra, a supplement to RetroPie.
# For more information, please visit:
#
# https://github.com/RetroPie/RetroPie-Setup
# https://github.com/Exarkuniv/RetroPie-Extra
#
# See the LICENSE file distributed with this source and at
# https://raw.githubusercontent.com/Exarkuniv/RetroPie-Extra/master/LICENSE
#

rp_module_id="gsplus"
rp_module_desc="Apple IIgs emulator"
rp_module_help="ROM Extensions: .dsk .po .2mg\n\nCopy your Apple II games to $romdir/$platform"
rp_module_licence="GNU GPL"
rp_module_repo="git https://github.com/plateofshrimp/gsplus.git :_get_branch_gsplus"
rp_module_section="exp"
rp_module_flags=""

function _get_branch_gsplus() {
    local branch="master"
    if [[ x86 ]]; then
        branch="retropie"
    fi
    echo "$branch"
}

function depends_gsplus() {
    local depends=(re2c libsdl2-dev libsdl2-image-dev libfreetype6-dev libpcap0.8-dev)
    getDepends "${depends[@]}"
}

function sources_gsplus() {
    gitPullOrClone
}

function build_gsplus() {
    mkdir build
    cd build
    cmake .. -DCMAKE_INSTALL_PREFIX=/opt/retropie/emulators/$rp_module_id
    make -j 3

    md_ret_require="$md_build/build/bin/GSplus"
}

function install_gsplus() {
    make -C $md_build/etc/retropie install
    md_ret_require="$md_inst/bin/GSplus"
    
}

function configure_gsplus() {
    local def=0
    local launcher_name="+Start GSplus.sh"
    local config_dir="$romdir/$platform"

    mkRomDir "$platform"

    addEmulator "$def" "$md_id" "$platform" "bash $romdir/$platform/${launcher_name// /\\ } %ROM%"
    addSystem "apple2" "Apple II" ".po .dsk .nib .2mg .2gs .sh"

    rm -f "$romdir/$platform/$launcher_name"
    [[ "$md_mode" == "remove" ]] && return

    cat > "$romdir/$platform/$launcher_name" << _EOF_
#!/usr/bin/env bash
$md_inst/gsplus.sh "\$1"
_EOF_
    
    chmod +x "$romdir/$platform/$launcher_name"
    chown -R __user:$__group "$romdir/$platform/$launcher_name"
}