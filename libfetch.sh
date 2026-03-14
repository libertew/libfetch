#!/bin/bash


CYAN='\033[0;36m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'


USER=$(whoami)
HOST=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
KERNEL=$(uname -r)
UPTIME=$(uptime -p)
CPU=$(grep "model name" /proc/cpuinfo | head -1 | cut -d':' -f2 | xargs)
RAM_USED=$(free -h | awk '/^Mem:/ {print $3}')
RAM_TOTAL=$(free -h | awk '/^Mem:/ {print $2}')
HELL_NAME=$(basename "$SHELL")
DISTRO=$(grep "^ID=" /etc/os-release 2>/dev/null | cut -d'=' -f2 | tr -d '"' || uname -s | tr '[:upper:]' '[:lower:]')

echo -e "${CYAN}${BOLD}${USER}@${HOST}${RESET}"
echo "─────────────────────────"
echo -e "${GREEN}OS${RESET}:     $OS"
echo -e "${GREEN}Kernel${RESET}: $KERNEL"
echo -e "${GREEN}Uptime${RESET}: $UPTIME"
echo -e "${GREEN}CPU${RESET}:    $CPU"
echo -e "${GREEN}RAM${RESET}:    $RAM_USED / $RAM_TOTAL"

logo_ubuntu() {
    echo -e "${RED}"
    echo '        .-/+oossssoo+\-.'
    echo '      `:+ssssssssssssssssss+`'
    echo '     -+ssssssssssssssssssyyssss+-'
    echo '   .ossssssssssssssssss dMMMNysssso.'
    echo '  /ssssssssssshdmmNNmmyNMMMMhssssss\'
    echo ' +ssssssssshmydMMMMMMMNddddyssssssss+'
    echo '/sssssssshNMMMyhhyyyyhmNMMMNhssssssss\'
    echo '.ssssssssdMMMNhsssssssssshNMMMdssssssss.'
    echo '+sssshhhyNMMNyssssssssssssyNMMMysssssss+'
    echo 'ossyNMMMNyMMhsssssssssssssshmmmhssssssso'
    echo 'ossyNMMMNyMMhsssssssssssssshmmmhssssssso'
    echo '+sssshhhyNMMNyssssssssssssyNMMMysssssss+'
    echo '.ssssssssdMMMNhsssssssssshNMMMdssssssss.'
    echo '/sssssssshNMMMyhhyyyyhdNMMMNhssssssss\'
    echo ' +sssssssssdmydMMMMMMMMddddyssssssss+'
    echo '  \ssssssssssshdmNNNNmyNMMMMhssssss/'
    echo '   .ossssssssssssssssss dMMMNysssso.'
    echo '     -+sssssssssssssssssyyyssss+-'
    echo '       `:+ssssssssssssssssss+`'
    echo '           .-\+oossssoo+/-.'
    echo -e "${RESET}"
}

logo_arch() {
    echo -e "${CYAN}"
    echo '                   -`'
    echo '                  .o+`'
    echo '                 `ooo/'
    echo '                `+oooo:'
    echo '               `+oooooo:'
    echo '               -+oooooo+:'
    echo '             `/:-:++oooo+:'
    echo '            `/++++/+++++++:'
    echo '           `/++++++++++++++:'
    echo '          `/+++ooooooooooooo/`'
    echo '         ./ooosssso++osssssso+`'
    echo '        .oossssso-````/ossssss+`'
    echo '       -osssssso.      :ssssssso.'
    echo '      :osssssss/        osssso+++'
    echo '     /ossssssss/        +ssssooo/-'
    echo '   `/ossssso+/:-        -:/+osssso+-'
    echo '  `+sso+:-`                 `.-/+oso:'
    echo ' `++:.                           `-/+/'
    echo ' .`                                 `/'
    echo -e "${RESET}"
}

logo_fedora() {
    echo -e "${BLUE}"
    echo '          /:-------------:\`'
    echo '       :-------------------::'
    echo '     :-----------/shhOHbmp---:\`'
    echo '   /-----------omMMMNNNMMD  ---:'
    echo '  :-----------sMMMMNMNMP.    ---:'
    echo ' :-----------:MMMdP-------    ---\`'
    echo ',------------:MMMd--------    ---:'
    echo ':------------:MMMd-------    .---:'
    echo ':----    oNMMMMMMMMMNho     .----:'
    echo ':--     .+shhhMMMmhhy++   .------/'
    echo ':-    -------:MMMd---------:---:'
    echo ':-   --------/MMMd--------:--:'
    echo ':-- ----------:MMMd------:---:'
    echo ':---     --------DMMMd---:--:'
    echo ':------    -------:+MMMdoo:-'
    echo ':--------   --------:+hMMMd-'
    echo ':--------    ----------:hMD.'
    echo ':------    -------:\`'
    echo ':----               :'
    echo ':------------------:'
    echo '`-----------------`'
    echo -e "${RESET}"
}

logo_gentoo() {
    echo -e "${MAGENTA}"
    echo '         -/oyddmdhs+:'
    echo '      -smMMMMMMMMMMMMMMy:'
    echo '    /MMMMMMMMMMMMMMMMMMMm+'
    echo '   oMMMMMMMMMMMMMMMMMMMMMM/'
    echo '  +MMMMMMMmyssso/+MMMMMMMMs'
    echo '  mMMMMMMy        /MMMMMMMs'
    echo '  NMMMMMMy         :MMMMMMm'
    echo '  NMMMMMMy          /MMMMMMs'
    echo '  mMMMMMMy           oMMMMMMs'
    echo '  +MMMMMMMy           +MMMMMMm'
    echo '   oMMMMMMMy          /MMMMMMs'
    echo '    yMMMMMMMds/:-:/oymMMMMMMm/'
    echo '     -oNMMMMMMMMMMMMMMMMMNs-'
    echo '        `-+ydNMMMMMMNdy+-`'
    echo -e "${RESET}"
}

logo_freebsd() {
    echo -e "${RED}"
    echo '```                        `.'
    echo '  ` `.....---.......--.```   -/'
    echo '  +o   .--`         /y:`      +.'
    echo '   yo`:.            :o      `+-'
    echo '    y/               -/`   -o/'
    echo '   .-                  ::/sy+:.'
    echo '   /                     `--  /'
    echo '  `:                          :`'
    echo '  `:                          :`'
    echo '   /                          /'
    echo '   .-                        -.'
    echo '    --                      --'
    echo '     `:`                  `:`'
    echo '       .--             --.'
    echo '          .---.   .---.'
    echo -e "${RESET}"
}

logo_openbsd() {
    echo -e "${YELLOW}"
    echo '                    |    .'
    echo '                    |.  .|\`\`-'
    echo '                    |..\`  \`.'
    echo '                  ..|    .  \`.'
    echo '                .` |   .     \`.'
    echo '           _   .   |  .   .   \`.'
    echo '         .` \`.|   |\.  .       \`.'
    echo '       .`    \`|   | \`.  .        \`.'
    echo '     .`       |   |   \`.  .        \`.'
    echo '   .`         |   |     \`.  .        \`.'
    echo ' .`           |   |       \`.  .        \`.'
    echo '              |   |         \`.  .       \`'
    echo '              |   |           \`.  .     .'
    echo '              |   |             \`. .\`  .'
    echo '              |   |               \`.\`.'
    echo '              |   |                \`.'
    echo -e "${RESET}"
}

logo_unknown() {
    echo -e "${WHITE}"
    echo '    .--.'
    echo '   |o_o |'
    echo '   |:_/ |'
    echo '  //   \ \'
    echo ' (|     | )'
    echo '/'\''\_   _/`\'
    echo '\___)=(___/'
    echo -e "${RESET}"
}

# ─── LOGO SEÇİMİ ───────────────────────────────────────────────────────────────

case "$DISTRO" in
    ubuntu)       logo_ubuntu  ;;
    arch)         logo_arch    ;;
    fedora)       logo_fedora  ;;
    gentoo)       logo_gentoo  ;;
    freebsd)      logo_freebsd ;;
    openbsd)      logo_openbsd ;;
    *)            logo_unknown ;;
esac

print_info
