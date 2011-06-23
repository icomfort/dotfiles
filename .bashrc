[ -f /etc/bashrc ] && source /etc/bashrc

PATH=/usr/local/bin:/usr/kerberos/bin:/bin:/usr/bin:/usr/local/sbin:/sbin
PATH=$PATH:/usr/sbin:/usr/pubsw/bin:/usr/pubsw/sbin
export PATH

export HISTCONTROL=ignoredups
export LESSHISTFILE=-
export LESS=-CRSi

alias ..="cd .."
alias ll="ls -la"
alias man="LANG=C man"

function orig ()     { for f in "$@"; do cp -pr "$f"{,.orig};   done }
function difforig () { for f in "$@"; do diff -ur "$f"{.orig,}; done }

known_hosts=$(egrep -hv '^(#|$)' /etc/ssh/ssh_known_hosts | cut -d, -f1)
complete -W "$known_hosts" -o default ssh
complete -W "$known_hosts" -S : -o default scp
unset known_hosts

if [ -r /etc/bash_completion.d/git ]; then
  source /etc/bash_completion.d/git
  PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '
  _git_unfetch() { __gitcomp "$(__git_remotes)"; }
  _git_review() { _git_log; }
  _git_fixup() { _git_commit; }
  _git_squash() { _git_commit; }
  _git_autosquash() { _git_rebase; }
fi

if [ -r /etc/bash_completion.d/mock.bash ]; then
  source /etc/bash_completion.d/mock.bash
  _mock_local() {
    local extglob=$(shopt -p extglob)
    shopt -s extglob
    _mock "$@"
    $extglob
  }
  complete -F _mock_local -o filenames mock
fi

[ -f ~/.bashrc.local ] && source ~/.bashrc.local
