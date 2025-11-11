# Source all .zsh files in this directory except init.zsh itself
for config_file in "${${(%):-%x}:A:h}"/*.zsh; do
  [[ "${config_file:t}" != "init.zsh" ]] && source "$config_file"
done
