# q4wine console support

if isatty; and set -q WINEPREFIX
    set -l _q4wine_prefix_winepath \
        (sqlite3 \
            $HOME/.config/q4wine/db/generic.dat \
            (printf "SELECT versions.wine_exec FROM versions JOIN prefix ON(versions.id = prefix.version_id) WHERE prefix.path = '%s';" $WINEPREFIX))

    if set -q _q4wine_prefix_winepath[1]
        set -x WINE $_q4wine_prefix_winepath[1]
        set -x PATH (dirname $WINE) $PATH

        function _q4wine.get_pwd
            winepath $PWD ^/dev/null | grep -Po '(?<=dosdevices/)[a-z]:.+'
        end

        # wine-mode functions 

        function prompt_pwd
            _q4wine.get_pwd
        end

        function cd -a dir 
            if [ $dir = .. ] 
                builtin cd .. # hack to work around an odd behaviour in winepath
            else 
                builtin cd (winepath -u $dir ^/dev/null)
            end
        end 

        function _q4wine.prompt_seg
            set_color blue
            printf 'wine-mode'
        end
        fish_prompt_breadcrumb add _q4wine.prompt_seg

    else
        set -e _q4wine_prefix_winepath
    end
end
