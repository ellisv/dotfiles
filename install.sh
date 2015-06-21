#!/bin/sh

for file in $PWD/dotfiles/*; do
    if [[ ! -L "$HOME/.$(basename $file)" ]]; then
        rm -f "$HOME/.$(basename $file)~"
        mv "$HOME/.$(basename $file)" "$HOME/.$(basename $file)~"
    fi

    rm -f "$HOME/.$(basename $file)"
    ln -sf "$file" "$HOME/.$(basename $file)"
done
