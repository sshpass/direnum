#/usr/bin/env bash

function usage {
echo "  Usage: ./direnum.sh [tuwph]"
echo " -t Number of threads to use"
echo " -a The IP address of the target"
echo " -p socks5 proxy address"
echo " -w /path/to/the/wordlist/"
}

function get_args {
  [ $# -eq 0 ] && usage && exit
   while getopts "p:a:w:t:h" arg; do
   case $arg in
   t) threads="$OPTARG" ;;
   a) ip="$OPTARG" ;;
   w) wordlist="$OPTARG" ;;
   p) proxy="--socks5 $OPTARG" ;;
   h) usage && exit;;
   esac
   done
}

function parallel {
cat $wordlist | xargs -n 1 -P $threads -I {} curl -s -o /dev/null -w '%{http_code} {}\n' $proxy $ip/{} | grep -ve "404" -ve "000" -ve "403"
}
get_args $@
parallel
