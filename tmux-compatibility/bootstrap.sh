#!/bin/bash

if [[ `tmux -V | awk '{print ($2 >= 2.1)}'` -eq 1 ]]; then
    tmux source ~/dotfiles/tmux-compatibility/tmux_ge_21.conf
else
    tmux source ~/dotfiles/tmux-compatibility/tmux_lt_21.conf
fi

if [[ `tmux -V | awk '{print ($2 >= 1.9)}'` -eq 1 ]]; then
    tmux source ~/dotfiles/tmux-compatibility/tmux_ge_19.conf
fi
