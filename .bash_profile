# Add `~/bin` to the `$PATH`
export PATH="/usr/local/bin:$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

# Git branch bash completion
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
  # Add git completion to aliases
  __git_complete g __git_main
fi

# [ -f ~/.git-flow-completion.bash ] && source ~/.git-flow-completion.bash

export JAVA_HOME=`/System/Library/Frameworks/JavaVM.framework/Versions/Current/Commands/java_home -v 1.8`
export PATH=$PATH:$JAVA_HOME/bin
export CATALINA_HOME=/usr/local/Cellar/tomcat/8.0.15/libexec
export NVM_DIR="$HOME/.nvm"
source "/usr/local/opt/nvm/nvm.sh"
export MAVEN_RESOLVER_URL="https://publish.artifactory.palantir.build/artifactory"
export OPENSSL_CONF=

export NPM_CONFIG_CAFILE="/Users/ccook/certs/ca-bundle.crt"
alias yarn=/Volumes/git/nucleus/build/bootstrap/yarn/bin/yarn
alias gfs="yarn gfs"

function https-server() {
  http-server --ssl --cert ~/certs/localhost.crt --key ~/certs/localhost.key
}

export EDITOR=vim
eval "$(gh completion -s bash)"

###-begin-gfs-completions-###
#
# yargs command completion script
#
# Installation: gfs completion >> ~/.bashrc
#    or gfs completion >> ~/.bash_profile on OSX.
#
_yargs_completions()
{
    local cur_word args type_list

    cur_word="${COMP_WORDS[COMP_CWORD]}"
    args=("${COMP_WORDS[@]}")

    # ask yargs to generate completions.
    type_list=$(gfs --get-yargs-completions "${args[@]}")

    COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

    # if no match was found, fall back to filename completion
    if [ ${#COMPREPLY[@]} -eq 0 ]; then
      COMPREPLY=()
    fi

    return 0
}
complete -o default -F _yargs_completions gfs
###-end-gfs-completions-###

