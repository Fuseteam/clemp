#!/bin/bash
while getopts 'h:d:v:n:pi:' flag; do
	case "${flag}" in
		h) httpport="-p${OPTARG}:80";;
		d) dbport="-p${OPTARG}:3306";;
		v) datavol="-v${OPTARG}:/var/lib/mysql";;
		n) conname="--name ${OPTARG}";;
		p) read -s -p "password:" password;pass="-ePASSWORD=$password ";;
		i) image="${OPTARG}";;
	esac
done
docker run -d $httpport $dbport $datavol $pass $conname $image
echo "docker run -d $httpport $dbport $datavol $pass $conname $image"
