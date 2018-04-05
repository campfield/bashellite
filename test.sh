# Change IFS so that only newline is word delimiter for repo_filter.conf processing
    IFS=$'\n';
    set -x
    script_dir=$(pwd);
    repo_name="postgresql-yum";
    http_url="https://download.postgresql.org/pub/repos/yum";
    mirror_tld=$(pwd);
    mirror_repo_name="postgresql-yum";

    for line in $(cat ${script_dir}/_metadata/${repo_name}/repo_filter.conf); do
      # recurse_flag will be set for each line if "r " is at the beginning of the line
      recurse_flag="";
      if [[ "${line:0:2}" == "r " ]]; then
        line="${line:2}";
        recurse_flag="-r -l inf -np";
      fi
      # If repo_filter entry ends in "/" assume it's a directory-include
      if [[ "${line: -1}" == "/" ]]; then
        wget_include_directory="${line}";
      else
        # Else, assume it's a file-include and parse out just the filename
        wget_filename="${line##*/}";
        if [[ "${#wget_filename}" != "${#line}" ]]; then
          # If it's both a directory and file-include, parse them out and grab both seperate
          wget_include_directory="${line%/*}/";
        else
          wget_include_directory="";
        fi
      fi
      dryrun="";
      if [[ ${dryrun} ]]; then
        wget_dryrun_flag="--spider";
      else
        wget_dryrun_flag="";
      fi
      #Info "Attempting to download file(s):"
      #Info "  From => ${http_url}/${line}"
      #Info "    To => ${mirror_tld}/${mirror_repo_name}/${line}"
      staging="";
      staging="${wget_dryrun_flag}";
      staging="${staging} -nv -nH -e robots=off -N";
      staging="${staging} ${recurse_flag}";
      # If we have a non-recursive file specified, don't use the --accept option
      if [[ ${recurse_flag} != "" ]]; then
        staging="${staging} --accept \"${wget_filename}\"";
        staging="${staging} --reject \"index*\""
      fi
      staging="${staging} -P "${mirror_tld}/${mirror_repo_name}/"";
      # If we have a non-recursive file specified, change how we set the url
      if [[ ${recurse_flag} == "" ]]; then
        staging="${staging} "${http_url}/${wget_include_directory}${wget_filename}" "
      else
        staging="${staging} "${http_url}/${wget_include_directory}" "
      fi
      wget_args=( "${staging}" )
      # wget unfortunately sends ALL output to STDERR.
      #Info "Running: wget ${wget_args[@]}"

      #echo ${wget_args} | xargs wget 2>&1 \
      set -f
      wget "${wget_args[@]}" \
      | grep -oP "(?<=(URL: ))http.*(?=(\s*200 OK$))" \
      | while read url; do Info "Downloaded $url"; done
      if [[ "${PIPESTATUS[1]}" == "0" ]]; then
        #Info "wget successfully downloaded file(s):"
        #Info "  From => ${http_url}/${line}"
        #Info "    To => ${mirror_tld}/${mirror_repo_name}/${line}"
        echo "In the if";
      else
        #Warn "wget did NOT successfully download file(s):"
        #Warn "  From => ${http_url}/${line}"
        #Warn "    To => ${mirror_tld}/${mirror_repo_name}/${line}"
        echo "In the else";
      fi
      set +f
    done
    unset IFS;
    set +x;