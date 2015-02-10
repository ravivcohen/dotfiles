replace_icon(){
    droplet=$1
    icon=$2
    rm -rf $droplet$'/Icon\r'
    sleep 1
    sips -i $icon >/dev/null
    DeRez -only icns $icon > /tmp/icns.rsrc
    Rez -append /tmp/icns.rsrc -o $droplet$'/Icon\r'
    SetFile -a C $droplet
    SetFile -a V $droplet$'/Icon\r'
}

replace_icon "/Applications/MyChrome.app" "$HOME/.dotfiles/bin/Chorme_Metal.png"
open -n /Applications/MyChrome.app --args --user-data-dir=$HOME/tmp