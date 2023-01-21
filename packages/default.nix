{ self, system }:
let
  pkgs = import self.inputs.nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
  };
  inherit (pkgs) callPackage;
in {
  AUTOMATIC1111-stable-diffusion-webui =
    callPackage ./AUTOMATIC1111-stable-diffusion-webui { };
}

# TODO: convert below into packages to get deterministic output locations :)

# TODO: can be packaged via fetchGithub - would mean we need to pin to select release rev/commits
# if [[ -z "${clone_dir}" ]]
# then
#     clone_dir="stable-diffusion-webui"
# fi

# TODO: well, this will be interesting
# if [[ -z "${LAUNCH_SCRIPT}" ]]
# then
#     LAUNCH_SCRIPT="launch.py"
# fi

# TODO: package upstream as local package in flake
#     printf "Clone stable-diffusion-webui"
#     printf "\n%s\n" "${delimiter}"
#     "${GIT}" clone https://github.com/AUTOMATIC1111/stable-diffusion-webui.git "${clone_dir}"
#     cd "${clone_dir}"/ || { printf "\e[1m\e[31mERROR: Can't cd to %s/%s/, aborting...\e[0m" "${install_dir}" "${clone_dir}"; exit 1; }
# fi

# TODO: wrap this via a python2nix option
# printf "\n%s\n" "${delimiter}"
# printf "Create and activate python venv"
# printf "\n%s\n" "${delimiter}"
# cd "${install_dir}"/"${clone_dir}"/ || { printf "\e[1m\e[31mERROR: Can't cd to %s/%s/, aborting...\e[0m" "${install_dir}" "${clone_dir}"; exit 1; }
# if [[ ! -d "${venv_dir}" ]]
# then
#     "${python_cmd}" -m venv "${venv_dir}"
#     first_launch=1
# fi
# # shellcheck source=/dev/null
# if [[ -f "${venv_dir}"/bin/activate ]]
# then
#     source "${venv_dir}"/bin/activate
# else
#     printf "\n%s\n" "${delimiter}"
#     printf "\e[1m\e[31mERROR: Cannot activate python venv, aborting...\e[0m"
#     printf "\n%s\n" "${delimiter}"
#     exit 1
# fi

# if [[ ! -z "${ACCELERATE}" ]] && [ ${ACCELERATE}="True" ] && [ -x "$(command -v accelerate)" ]
# then
#     printf "\n%s\n" "${delimiter}"
#     printf "Accelerating launch.py..."
#     printf "\n%s\n" "${delimiter}"
#     exec accelerate launch --num_cpu_threads_per_process=6 "${LAUNCH_SCRIPT}" "$@"
# else
#     printf "\n%s\n" "${delimiter}"
#     printf "Launching launch.py..."
#     printf "\n%s\n" "${delimiter}"
#     gpu_info=$(lspci 2>/dev/null | grep VGA)
#     if echo "$gpu_info" | grep -q "AMD"
#     then
#         if [[ -z "${TORCH_COMMAND}" ]]
#         then	    
#             export TORCH_COMMAND="pip install torch torchvision --extra-index-url https://download.pytorch.org/whl/rocm5.2"
#         fi
#         HSA_OVERRIDE_GFX_VERSION=10.3.0 exec "${python_cmd}" "${LAUNCH_SCRIPT}" "$@"
#     else
#         exec "${python_cmd}" "${LAUNCH_SCRIPT}" "$@"
#     fi
# fi
