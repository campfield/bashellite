# Change IFS so that only newline is word delimiter for repo_filter.conf processing
    set -x
    script_dir=$(pwd)
    repo_name="postgresql-yum"
    http_url="https://download.postgresql.org/pub/repos/yum"
    mirror_tld=$(pwd)
    mirror_repo_name="postgresql-yum"

    IFS=$'\n'
    filter_array_count=0
    filter_array=()
    for line in $(cat ${script_dir}/_metadata/${repo_name}/repo_filter.conf); do
      filter_array[${filter_array_count}]=${line};
      filter_array_count=$[${filter_array_count}+1]
      echo "Count: ${filter_array_count}"
    done
    unset IFS

    for (( i=0; i<${#filter_array[@]}; i++ )); do
      line=${filter_array[${i}]}
      echo "Line: ${line}"
      echo "Element: ${filter_array[${i}]}"

    done
    set +x;