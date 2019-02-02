# set path to XDG directories (for more information to this variable see XDG specification)
[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z $XDG_CACHE_HOME ]] && export XDG_CACHE_HOME="$HOME/.cache"
[[ -z $XDG_DATA_HOME ]] && export XDG_DATA_HOME="$HOME/.local/share"

#set path to zsh config file
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# set path to Xauthority
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# store less histfile in data directorie
export LESSHISTFILE="$XDG_DATA_HOME/less"

# set path to vimrc config file
export VIMINIT='let $MYVIMRC="$XDG_CONFIG_HOME/vim/vimrc" | source $MYVIMRC'

# disable check for new versions by Hashicorp tools like Vagrant, Packer,...
export CHECKPOINT_DISABLE="disabled"     #none empty value = disabled

# directory where vagrant stores its VM-specific states 
# (could give problems with default provisioners)
# export VAGRANT_DOTFILE_PATH="$XDG_CONFIG_HOME/vagrant"

# directory where vagrant stores its global state like storing boxes,...
export VAGRANT_HOME="$XDG_CACHE_HOME/vagrant"

export VAGRANT_Log="$XDG_DATA_HOME/vagrant"

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd_hrgb'
