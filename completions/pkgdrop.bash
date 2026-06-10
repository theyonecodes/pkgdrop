# Bash completions for pkgdrop

_pkgdrop() {
    local cur prev words cword
    _init_completion || return

    case $cur in
        -*)
            COMPREPLY=($(compgen -W "--help --version --list --uninstall --clean --dry-run --verbose --yes -h -v -l -u -c -n -V -y" -- "$cur"))
            return
            ;;
    esac

    case $prev in
        --uninstall|-u)
            # Complete with installed package names
            local install_dir="${PKGDROP_DIR:-$HOME/.local/opt}"
            if [[ -d "$install_dir" ]]; then
                COMPREPLY=($(compgen -W "$(ls -1 "$install_dir" 2>/dev/null)" -- "$cur"))
            fi
            return
            ;;
    esac

    # Default: complete file paths
    _filedir '@(tar.xz|tar.gz|deb|rpm|pkg.tar.zst|pkg.tar.xz|pkg.tar.gz|AppImage)'
}

complete -F _pkgdrop pkgdrop
