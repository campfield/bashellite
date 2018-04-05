# Change IFS so that only newline is word delimiter for repo_filter.conf processing
#IFS=$'\n';
#set -x
#script_dir=$(pwd)
#repo_name="postgresql-yum"
#http_url="https://download.postgresql.org/pub/repos/yum"
#mirror_tld=$(pwd)
#mirror_repo_name="postgresql-yum"

#recurse_flag=""
#recurse_flag="-r -l inf -np"
#wget_include_directory="10/fedora/fedora-25-x86_64/"
#wget_filename="\\*.rpm"
#wget_dryrun_flag=""
#staging=""
#staging="${wget_dryrun_flag} -nv -nH -e robots=off -N ${recurse_flag}"

# If we have a non-recursive file specified, don't use the --accept option

#if [[ ${recurse_flag} != "" ]]; then
#  staging+=" --accept \"${wget_filename}\""
#  #staging+=" --reject index*"
#fi
#staging+=" -P "${mirror_tld}/${mirror_repo_name}/""

# If we have a non-recursive file specified, change how we set the url

#staging_url="";
#if [[ ${recurse_flag} == "" ]]; then
#  staging_url="${http_url}/${wget_include_directory}${wget_filename}"
#else
#  staging_url="${http_url}/${wget_include_directory}"
#fi
#wget_args=( ${staging} ${staging_url} )

# wget unfortunately sends ALL output to STDERR.


#echo ${wget_args} | xargs wget 2>&1 \
#wget ${wget_args[@]} \
set -f; wget_args="-nH -np -r -A "*.rpm""; wget ${wget_args} https://download.postgresql.org/pub/repos/yum/10/fedora/fedora-25-x86_64/ | grep -oP "(?<=(URL: ))http.*(?=(\s*200 OK$))" | while read url; do echo "Downloaded $url"; done; set +f

#set +f
unset IFS
#set +x