rp_module_id="lr-imame4all"
rp_module_desc="Arcade emu - iMAME4all (based on MAME 0.37b5) port for libretro"
rp_module_menus="2+"

function sources_lr-imame4all() {
    gitPullOrClone "$md_build" git://github.com/libretro/imame4all-libretro.git
    sed -i "s/@mkdir/@mkdir -p/g" makefile.libretro
}

function build_lr-imame4all() {
    make -f makefile.libretro clean
    make -f makefile.libretro ARM=1
    md_ret_require="$md_build/libretro.so"
}

function install_lr-imame4all() {
    md_ret_files=(
        'libretro.so'
        'Readme.txt'
    )
}

function configure_lr-imame4all() {
    # remove old install folder
    rm -rf "$rootdir/$md_type/mamelibretro"

    mkRomDir "mame4all"
    ensureSystemretroconfig "mame4all"

    # system-specific shaders, Mame
    iniConfig " = " "" "$configdir/mame4all/retroarch.cfg"
    iniSet "input_remapping_directory" "$configdir/mame4all/"

    delSystem "$md_inst" "mame-libretro"
    addSystem 0 "$md_inst" "mame4all arcade mame" "$md_inst/libretro.so"
}
