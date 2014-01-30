# # rbenv init.
# PATH=$(path_remove ~/.dotfiles/libs/rbenv/bin):~/.dotfiles/libs/rbenv/bin
# PATH=$(path_remove ~/.dotfiles/libs/ruby-build/bin):~/.dotfiles/libs/ruby-build/bin
# 
# if [[ "$(type -P rbenv)" && ! "$(type -t _rbenv)" ]]; then
#   eval "$(rbenv init -)"
# fi
# 
# # Install Ruby.
# if [[ "$(type -P rbenv)" ]]; then
#   versions=(1.9.3-p194 1.9.2-p290)
# 
#   list="$(to_install "${versions[*]}" "$(rbenv whence ruby)")"
#   if [[ "$list" ]]; then
#     e_header "Installing Ruby versions: $list"
#     for version in $list; do rbenv install "$version"; done
#     [[ "$(echo "$list" | grep -w "${versions[0]}")" ]] && rbenv global "${versions[0]}"
#     rbenv rehash
#   fi
# fi
# 
# # Install Gems.
# if [[ "$(type -P gem)" ]]; then
#   gems=(bundler awesome_print interactive_editor)
# 
#   list="$(to_install "${gems[*]}" "$(gem list | awk '{print $1}')")"
#   if [[ "$list" ]]; then
#     e_header "Installing Ruby gems: $list"
#     gem install $list
#   fi
# fi
# 
