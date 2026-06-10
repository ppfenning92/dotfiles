# macOS-specific overrides.
# GNU tools shadow BSD utils transparently via PATH in path.sh:
#   /opt/homebrew/opt/<pkg>/libexec/gnubin prepended for each installed GNU pkg.
#   brew install coreutils findutils gnu-sed gawk grep gnu-tar
# Rust CLI replacements (eza, bat, rg, fd, etc.) in rust.alias.sh take priority.
# Priority: rust CLIs > GNU tools > BSD system tools.
#
# TODO: verify PATH ordering on first macOS run - sceptical whether gnubin
#       dirs actually land before system tools after all other PATH mutations.
