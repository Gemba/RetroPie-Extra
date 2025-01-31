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

rp_module_id="perfect_dark"
rp_module_desc="Perfect Dark PC Port by fgsfdsfgs"
rp_module_help="Save your valid .z64 copy of Perfect Dark to $home/.local/share/perfectdark/data"
rp_module_repo="git https://github.com/fgsfdsfgs/perfect_dark.git port"
rp_module_section="exp"
rp_module_flags="all"

function depends_perfect_dark() {
    local depends=(gcc g++ cmake make git python3 libsdl2-dev libgl1-mesa-dev zlib1g-dev)
    
    getDepends "${depends[@]}"
}

function sources_perfect_dark() {
    gitPullOrClone
}

function copy_rom_dark() {
    local romdir="$home/RetroPie/roms/n64"
    local destdir="$home/.local/share/perfectdark/data"

    mkdir -p "$destdir"

    # Define the hashes to check against
    local hash1="e03b088b6ac9e0080440efed07c1e40f"

    # Iterate through the files in the ROM directory
    for file in "$romdir"/*; do
        if [[ -f "$file" ]]; then
            local sha1=$(sha1sum "$file" | awk '{print $1}')
            # Check if the calculated SHA1 matches either of the specified hashes
            if [[ "$sha1" == "$hash1" || "$sha1" == "$hash2" ]]; then
                cp "$file" "$destdir"
                echo "Copied $file to $destdir"
                return 0
            fi
        fi
    done

    echo "No matching ROM file found in $romdir"
    return 1
}

function build_perfect_dark() {
    copy_rom_dark
    if [[ $? -ne 0 ]]; then
        echo "Build cannot proceed without a valid ROM file."
        return 1
    fi

    cmake -G"Unix Makefiles" -Bbuild .
    cmake --build build -j4
}

function install_perfect_dark() {
    md_ret_files=(
       'build/pd.arm64'
    )
}

function configure_perfect_dark() {	
    addPort "$md_id" "perfect_dark" "Perfect Dark PC Port" "$md_inst/pd.arm64"

}
