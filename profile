# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

SSH_AGENT_FILE="$HOME/.sshagent"

function check-ssh-agent
{
    [ -S "$SSH_AUTH_SOCK" ] && { ssh-add -l >& /dev/null || [ $? -ne 2 ]; }
}

function start-agent
{
    check-ssh-agent || {
        [ -f "$SSH_AGENT_FILE" ] && {
            . "$SSH_AGENT_FILE" > /dev/null
            check-ssh-agent || { rm -f $SSH_AGENT_FILE && start-agent; }
        } || {
            echo "Starting new SSH agent ..."
            ssh-agent -s | sed 's/^echo/#echo/' > "${SSH_AGENT_FILE}"
            chmod 600 "$SSH_AGENT_FILE"
            start-agent
        }
    }
}

start-agent

command -v pulseaudio &>/dev/null &&
(
    pgrep pulseaudio &>/dev/null || pulseaudio --start
)
