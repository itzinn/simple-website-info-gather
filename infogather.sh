#!/bin/bash

if [ "$1" == "" ]
then

	echo "Modo de uso: $0 [DOMINIO]"
	echo "Exemplo: $0 www.google.com.br"

else

	ping -c 1 $1 > /dev/null

	echo -e "\n\033[1;31m==========================================\033[0m"

	echo -e "\n\033[0;33mWHOIS\033[0m"

	whois $1

	echo -e "\n\033[1;31m==========================================\033[0m"

	echo -e "\n\033[0;33mINFORMAÇÕES DE CABEÇALHO\033[0m\n"

	curl -I $1

	echo -e "\n\033[1;31m==========================================\033[0m"

	echo -e "\n\033[0;33mROBOTS.TXT\033[0m\n"

	wget "$1/robots.txt" -o /dev/null

	if [ "$(ls | grep robots.txt)" == "" ]
	then
		echo "Robots.txt não encontrado."
	else
		cat robots.txt
		rm robots.txt
	fi

	echo -e "\n\033[1;31m==========================================\033[0m"

	echo -e "\n\033[0;33mDOMÍNIOS NA PÁGINA\033[0m\n"

	wget $1 -o /dev/null

	if [ "$(ls | grep index.html)" == "" ]
	then
		echo "Não foi possível baixar o index.html da página."
	else

		grep -Eoi '<a [^>]+>' index.html | grep -Eo 'href="[^\"]+"' | grep -Eo '(http|https)://[^/"]+' | cut -d '/' -f 3 | sort -u > dominios.txt

		for dominio in $(cat dominios.txt)
		do
			echo -e "$dominio\t=> $(host $dominio | grep 'has' |  grep -v 'IPv6' | cut -d ' ' -f 4)"
		done

		rm index.html*
	fi

	echo ""

fi
