#!/bin/bash
#Script by Ibrahim Ben Hariz | https://github.com/IbrahimBenHariz

red="\e[0;91m"
blue="\e[0;94m"
expand_bg="\e[K"
blue_bg="\e[0;104m${expand_bg}"
red_bg="\e[0;101m${expand_bg}"
green_bg="\e[0;102m${expand_bg}"
green="\e[0;92m"
yellow="\e[0;93m"
white="\e[0;97m"
bold="\e[1m"
uline="\e[4m"
reset="\e[0m"


logo="${red}
█   █ █████ ████  █████ ████  █████
█   █ █     █  █  █     █   █ █     █  █
█ █ █ ███   █████ ███   █   █ ███    ██
█ █ █ █     █   █ █     █   █ █      ██
█████ █████ █████ █████ ████  █████ █  █


               ████████
             ████████████
           ██████    ██████
          ██████      ██████  ${reset}
                  ██
                  ██
          ██████      ██████
           ██████    ██████
             ████████████
               ████████

"


version="\nWEBEDEx Version 1.0\n\nhttps://github.com/IbrahimBenHariz/WEBEDEx/"


display_error() {
    printf "${red}Error : $1.${reset}\n"
    display_usage
    exit 1
}


display_usage() {
    printf "
${green}WEBEDEx Usage${reset}

${green}$0${reset} <MODE> ${yellow}-u${reset} <TARGET URL or DOMAIN NAME> ${yellow}-w${reset} <WORDLIST>

Modes :
        ${blue}dir${reset}     directory & file enumeration
	${blue}dns${reset}     DNS subdomain enumeration 

For more information : ${green}$0${reset} ${yellow}-h${reset}
"
}


display_help() {
    printf "$logo
${green}WEBEDEx Help Menu${reset}

Modes :
        ${blue}dir${reset}     directory & file enumeration
        ${blue}dns${reset}     DNS subdomain enumeration 

Flags :
        ${blue}dir${reset} mode : ${green}$0${reset} ${blue}dir${reset} ${yellow}-u${reset} <TARGET URL> ${yellow}-w${reset} <WORDLIST> ...		     
        ${blue}dns${reset} mode : ${green}$0${reset} ${blue}dns${reset} ${yellow}-u${reset} <DOMAIN NAME> ${yellow}-w${reset} <WORDLIST> ...  
                     
	${yellow}-u${reset}	Specify the target URL or DOMAIN NAME
	${yellow}-w${reset}	Specify the wordlist file or a directory path
	${yellow}-s${reset}	Search for a specific wordlist that matches an input
		Note : the -w flag must be specified with a directory path
	${yellow}-H${reset}	Change the HTTP header of the request for the enumeration
	${yellow}-v${reset}	Verbose mode
	${yellow}-h${reset} 	Help menu about the tool
	${yellow}-V${reset}	Show the version

Examples :
        ${green}$0${reset} ${blue}dir${reset} ${yellow}-w${reset} /usr/share/wordlist/apache.txt ${yellow}-u${reset} https://example.com

	${green}$0${reset} ${blue}dns${reset} ${yellow}-w${reset} /usr/share/wordlist/dns.txt ${yellow}-u${reset} example.com

	${green}$0${reset} ${blue}dns${reset} ${yellow}-w${reset} /usr/share/wordlist/ ${yellow}-u${reset} example.com ${yellow}-s${reset} apache

	${green}$0${reset} ${blue}dir${reset} ${yellow}-w${reset} /usr/share/wordlist/spring.txt ${yellow}-u${reset} https://example.com ${yellow}-H${reset} \"User-Agent: MyCustomUserAgent, Content-Type: application/json\"

	${green}$0${reset} ${blue}dir${reset} ${yellow}-w${reset} /usr/share/wordlist/dns/ ${yellow}-u${reset} https://example.com ${yellow}-v${reset}
"
}


prog() {
    local w=80 p=$1;  shift
    printf -v dots "%*s" "$(( $p*$w/$line_count ))" ""; dots=${dots// /.}; 
    printf "\r\e[K|%-*s| %3d %% %s" "$w" "$dots" "$p" "$*"; 
}


dns_mode() {
    if [[ -n "$4" || "$5" == "true" ]]; then
        printf -- "${red}-v and -H flags do not apply with DNS mode.${reset}\n"
    fi

    if [ "$6" == "true" ] && [ -z "$3" ]; then
        for wordlists in "$2"/*; do
	    if [ -f "$wordlists" ]; then
		dns_enum "$1" "$wordlists"
	    fi
	done
    elif [ "$6" == "true" ] && [ -n "$3" ]; then
        for wordlists in "$2"/*; do
            if [ -f "$wordlists" ]; then
		if [[ "$wordlists" == *"$3"* ]]; then
                    dns_enum "$1" "$wordlists"
		fi
            fi
        done
    else
	dns_enum "$1" "$2"
    fi
}


dns_enum() {
    line_count=$(wc -l < "$2")
    count=0

    printf "\n${yellow}Wordlist : $2${reset}\n\n"

    while read -r subdomain; do
        local_sub="$subdomain.$1"
        response=$(nslookup "$local_sub" 2>/dev/null)

        if [[ "$response" != *"can't find"* ]]; then
            printf "\n${green}Found : $local_sub${reset}\n"
        fi

        ((count++))
        prog "$count" "$line_count"
    done < "$2"
}


dir_mode() {
    curl_options=""

    if [[ "$5" == "true" && -n "$4" ]]; then
        curl_options="-s -o /dev/null -v -H '$4' -w %{http_code}"
    elif [[ "$5" == "true" && -z "$4" ]]; then
        curl_options="-s -o /dev/null -v -w %{http_code}"
    elif [[ "$5" == "false" && -n "$4" ]]; then
        curl_options="-s -o /dev/null -H '$4' -w %{http_code}"
    else
        curl_options="-s -o /dev/null -w %{http_code}"
    fi

    if [ "$6" == "true" ] && [ -z "$3" ]; then
        for wordlists in "$2"/*; do
            if [ -f "$wordlists" ]; then
                dir_enum "$1" "$wordlists"
            fi
        done
    elif [ "$6" == "true" ] && [ -n "$3" ]; then
        for wordlists in "$2"/*; do
            if [ -f "$wordlists" ]; then
                if [[ "$wordlists" == *"$3"* ]]; then
                    dir_enum "$1" "$wordlists"
                fi
            fi
        done
    else
        dir_enum "$1" "$2" "curl_options"
    fi
}


dir_enum() {
    printf "\n${yellow}Wordlist : $2${reset}\n\n"

    while read -r dirfile; do
        local_url="$1/$dirfile"

        response=$(eval "curl $curl_options \"$local_url\"")

        case "$response" in
            200)
                printf "${green}Found : $local_url${reset}\n"
                ;;
            301|302)
                printf "${blue}Redirect : $local_url${reset}\n"
                ;;
            400)
                printf "${red}Bad Request : $local_url${reset}\n"
                ;;
            401)
                printf "${red}Unauthorized : $local_url${reset}\n"
                ;;
            403)
                printf "${red}Forbidden : $local_url${reset}\n"
                ;;
            404)
                printf "${red}Not Found : $local_url${reset}\n"
                ;;
            500)
                printf "${red}Internal Server Error : $local_url${reset}\n"
                ;;
            502)
                printf "${red}Bad Gateway : $local_url${reset}\n"
                ;;
            503)
                printf "${red}Service Unavailable : $local_url${reset}\n"
                ;;
            *)
                printf "Unknown Error : $local_url\n"
                ;;
        esac
    done < "$2"

}


mode=""
url=""
wordlist=""
search=""
header=""
verbose_mode="false"
folder_mode="false"


while [ "$#" -gt 0 ]; do
    case "$1" in
	-h)
            display_help
            exit 0
            ;;
        -V)
            printf "$logo${green}$version${reset}\n"
            exit 0
            ;;
        dns)
            mode="dns"
            ;;
        dir)
            mode="dir"
            ;;
        -u)
            shift
            url="$1"
            ;;
        -w)
            shift
            wordlist="$1"
            ;;
        -s)
            shift
            search="$1"
	    search_mode="true"
            ;;
        -H)
            shift
            header="$1"
            ;;
        -v)
            verbose_mode="true"
            ;;
        *)
            display_error "Unknown argument $1"
            ;;
    esac
    shift
done


if [ -z "$mode" ] || [ -z "$url" ] || [ -z "$wordlist" ]; then
    display_error "<MODE>, -u <TARGET URL or DOMAIN NAME>, and -w <WORDLIST> must be specified at least"
fi


if [ -d "$wordlist" ]; then
    folder_mode="true"
fi


if [ "$search_mode" = true ] && [ "$folder_mode" = false ]; then
    display_error "-s flag needs a -w flag with a directory path"
fi


if [ "$mode" = "dns" ]; then
    dns_mode "$url" "$wordlist" "$search" "$header" "$verbose_mode" "$folder_mode"
elif [ "$mode" = "dir" ]; then
    dir_mode "$url" "$wordlist" "$search" "$header" "$verbose_mode" "$folder_mode"
fi
