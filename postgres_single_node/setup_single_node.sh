username=''
password=''
version=''
port=''
fill_flag=''

print_usage(){
    printf "\nUsage: ./setup_single_node.sh [OPTIONS] e.g. ./setup_single_node.sh -u 1337_wookie_hunter -p secure_passwd123 \n 
    \t -u : Supply a username. Default: postgres \n 
    \t -p : Supply a password. Default: changeme \n
    \t -v : Supply a postgres version. Supported versions 10,11,12,13,14. Default 10\n.
    \t -l : Supply mapping for local host port i.e. [HOST]:5432 default postgres container port. Defaults to 5555\n
    \t -f : Populates the table with data for testing. \n
    \t -h : print this help and exit the script \n"
}
while getopts 'u:p:v:l:fh' flag; do
  case "${flag}" in
    u) username="${OPTARG}"; printf "Setting up with username: %s\n" ${username} ;;
    p) password="${OPTARG}"; printf "Setting up with supplied password.\n" ;;
    v) version="${OPTARG}"; printf "Setting up with supplied version: %s\n" ${version}  ;;
    l) port="${OPTARG}"; printf "Setting up with local port: %s\n" ${port} ;;
    f) fill_flag='true' ;;
    h) print_usage; exit 1 ;;
    *) ;;
  esac
done

#TODO- complete mapping commands