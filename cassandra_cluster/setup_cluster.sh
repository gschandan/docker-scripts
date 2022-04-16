#!/bin/bash
# Modified from and credit to https://github.com/digitalis-io/ccc/blob/master/setup-config.sh

authentication_flag=''
tidy_flag=''
print_usage(){
    printf "Usage: ./setup_cluster.sh [OPTION] \n 
    \t-a : enables authentication. Use -u cassandra -p cassandra to access the cluster once created.\n 
    \t-h : print this help and exit the script \n
    \t-t : remove the temporary config files created during setup"
}
while getopts 'aht' flag; do
  case "${flag}" in
    a) authentication_flag='true' ;;
    h) print_usage; exit 1 ;;
    t) tidy_flag='true' ;;
    *) ;;
  esac
done

CASSANDRA_VERSION=`docker-compose -f docker-compose-cassandra-cluster.yaml config | grep 'image:.*cassandra:' | head -1 | awk -F":" '{ print $NF}'`

docker image pull cassandra:${CASSANDRA_VERSION}
docker run --rm -d --name tmp cassandra:${CASSANDRA_VERSION}
docker cp tmp:/etc/cassandra/ etc_cassandra_${CASSANDRA_VERSION}_vanilla/
docker stop tmp

if [[ "${authentication_flag}" ]]; then
    config_file=etc_cassandra_${CASSANDRA_VERSION}_vanilla/cassandra.yaml
    sed -i "s/authenticator: AllowAllAuthenticator/authenticator: PasswordAuthenticator/" ${config_file}
fi

etc_volumes=`docker-compose -f docker-compose-cassandra-cluster.yaml config | grep '/etc/cassandra' | awk -F ":" '{ print $1}' | awk '{ print $NF}'`

for v in ${etc_volumes}; do
  mkdir -p ${v}
  cp -r etc_cassandra_${CASSANDRA_VERSION}_vanilla/*.* ${v}/
done

if [[ "${tidy_flag}" ]]; then
  printf "Tidying up..."
  rm -r etc_cassandra_${CASSANDRA_VERSION}_vanilla/
fi