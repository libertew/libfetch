#!/bin/bash

# Renkler
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
RESET='\033[0m'

# Sistem bilgileri
USER_NAME=$(whoami)
HOST=$(hostname)
OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d'"' -f2 || uname -s)
KERNEL=$(uname -r)
UPTIME=$(uptime -p 2>/dev/null || uptime)
CPU=$(grep "model name" /proc/cpuinfo 2>/dev/null | head -1 | cut -d':' -f2 | xargs || sysctl -n hw.model 2>/dev/null)
RAM_USED=$(free -h 2>/dev/null | awk '/^Mem:/ {print $3}')
RAM_TOTAL=$(free -h 2>/dev/null | awk '/^Mem:/ {print $2}')
SHELL_NAME=$(basename "$SHELL")
DISTRO=$(grep "^ID=" /etc/os-release 2>/dev/null | cut -d'=' -f2 | tr -d '"' || uname -s | tr '[:upper:]' '[:lower:]')


get_packages() {
    local pkgs=""
 
    if command -v dpkg-query &>/dev/null; then
        local n
        n=$(dpkg-query -f '.\n' -W 2>/dev/null | wc -l)
        pkgs="${pkgs}${n} (dpkg) "
    fi
    if command -v rpm &>/dev/null; then
        local n
        n=$(rpm -qa 2>/dev/null | wc -l)
        pkgs="${pkgs}${n} (rpm) "
    fi
    if command -v pacman &>/dev/null; then
        local n
        n=$(pacman -Qq 2>/dev/null | wc -l)
        pkgs="${pkgs}${n} (pacman) "
    fi
    if command -v flatpak &>/dev/null; then
        local n
        n=$(flatpak list 2>/dev/null | wc -l)
        (( n > 0 )) && pkgs="${pkgs}${n} (flatpak) "
    fi
    if command -v snap &>/dev/null; then
        local n
        n=$(snap list 2>/dev/null | tail -n +2 | wc -l)
        (( n > 0 )) && pkgs="${pkgs}${n} (snap) "
    fi
 
    [[ -z "$pkgs" ]] && pkgs="N/A"
    echo "${pkgs% }"
}
 
# WM / DE tespiti
get_wm() {
    # WSL kontrolü
    if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "WSL (Windows)"
        return
    fi
 
    # DE değişkenleri
    [[ -n "$XDG_CURRENT_DESKTOP" ]] && echo "$XDG_CURRENT_DESKTOP" && return
    [[ -n "$DESKTOP_SESSION"      ]] && echo "$DESKTOP_SESSION"     && return
 
    # Çalışan WM process'lerini tara
    local wm_list=(
        kwin_wayland kwin_x11 kwin
        mutter muffin marco
        openbox fluxbox blackbox icewm
        i3 sway bspwm herbstluftwm
        xfwm4 awesome dwm qtile
        compiz enlightenment
    )
    for wm in "${wm_list[@]}"; do
        pgrep -x "$wm" &>/dev/null && echo "$wm" && return
    done
 
    [[ -n "$WAYLAND_DISPLAY" ]] && echo "Wayland" && return
    [[ -n "$DISPLAY"         ]] && echo "X11"     && return
 
    echo "N/A"
}
 
PACKAGES=$(get_packages)
WM=$(get_wm)
 


# Argüman varsa distro'yu override et
if [[ -n "$1" ]]; then
    DISTRO="${1#-}"   # başındaki - işaretini sil (ör. -freebsd → freebsd)
    DISTRO="${DISTRO,,}"  # küçük harfe çevir
fi

# ANSI kodlarını sil
strip_ansi() {
    echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g'
}

# Satırı belirli görünür genişliğe kadar pad'le
pad_to() {
    local line="$1"
    local width="$2"
    local visible
    visible=$(strip_ansi "$line")
    local len=${#visible}
    local pad=$(( width - len ))
    printf "%b%*s" "$line" "$pad" ""
}

# Logo dizileri
logo_ubuntu() {
    C=$RED
    LOGO=(
        "${C}        .-/+oossssoo+\\-."
        "${C}      \`:+ssssssssssssssssss+\`"
        "${C}     -+ssssssssssssssssssyyssss+-"
        "${C}   .osssssssssssssssssssdMMMNysssso."
        "${C}  /ssssssssssshdmmNNmmyNMMMMhssssss\\"
        "${C} +ssssssssshmydMMMMMMMNddddyssssssss+"
        "${C}/sssssssshNMMMyhhyyyyhmNMMMNhssssssss\\"
        "${C}.ssssssssdMMMNhsssssssssshNMMMdssssssss."
        "${C}+sssshhhyNMMNyssssssssssssyNMMMysssssss+"
        "${C}ossyNMMMNyMMhsssssssssssssshmmmhssssssso"
        "${C}ossyNMMMNyMMhsssssssssssssshmmmhssssssso"
        "${C}+sssshhhyNMMNyssssssssssssyNMMMysssssss+"
        "${C}.ssssssssdMMMNhsssssssssshNMMMdssssssss."
        "${C}/sssssssshNMMMyhhyyyyhdNMMMNhssssssss\\"
        "${C} +sssssssssdmydMMMMMMMMddddyssssssss+"
        "${C}  \\ssssssssssshdmNNNNmyNMMMMhssssss/"
        "${C}   .osssssssssssssssssssdMMMNysssso."
        "${C}     -+sssssssssssssssssyyyssss+-"
        "${C}       \`:+ssssssssssssssssss+\`"
        "${C}           .-/+oossssoo+/-."
    )
}

logo_arch() {
    C=$CYAN
    LOGO=(
        "${C}                   -\`"
        "${C}                  .o+\`"
        "${C}                 \`ooo/"
        "${C}                \`+oooo:"
        "${C}               \`+oooooo:"
        "${C}               -+oooooo+:"
        "${C}             \`/:-:++oooo+:"
        "${C}            \`/++++/+++++++:"
        "${C}           \`/++++++++++++++:"
        "${C}          \`/+++ooooooooooooo/\`"
        "${C}         ./ooosssso++osssssso+\`"
        "${C}        .oossssso-\`\`\`\`/ossssss+\`"
        "${C}       -osssssso.      :ssssssso."
        "${C}      :osssssss/        osssso+++"
        "${C}     /ossssssss/        +ssssooo/-"
        "${C}   \`/ossssso+/:-        -:/+osssso+-"
        "${C}  \`+sso+:-\`                 \`.-/+oso:"
        "${C} \`++:.                           \`-/+/"
        "${C} .\`                                 \`/"
    )
}

logo_fedora() {
    C=$BLUE
    LOGO=(
        "${C}          /:-------------:\`"
        "${C}       :-------------------::"
        "${C}     :-----------/shhOHbmp---:\`"
        "${C}   /-----------omMMMNNNMMD  ---:"
        "${C}  :-----------sMMMMNMNMP.    ---:"
        "${C} :-----------:MMMdP-------    ---\`"
        "${C},------------:MMMd--------    ---:"
        "${C}:------------:MMMd-------    .---:"
        "${C}:----    oNMMMMMMMMMNho     .----:"
        "${C}:--     .+shhhMMMmhhy++   .------/"
        "${C}:-    -------:MMMd---------:---:"
        "${C}:-   --------/MMMd--------:--:"
        "${C}:-- ----------:MMMd------:---:"
        "${C}:---     --------DMMMd---:--:"
        "${C}:------    -------:+MMMdoo:-"
        "${C}:--------   --------:+hMMMd-"
        "${C}:--------    ----------:hMD."
        "${C}:------    -------:\`"
        "${C}:----               :"
        "${C}:------------------:"
    )
}

logo_gentoo() {
    C=$MAGENTA
    LOGO=(
        "${C}         -/oyddmdhs+:"
        "${C}      -smMMMMMMMMMMMMMMy:"
        "${C}    /MMMMMMMMMMMMMMMMMMMm+"
        "${C}   oMMMMMMMMMMMMMMMMMMMMMM/"
        "${C}  +MMMMMMMmyssso/+MMMMMMMMs"
        "${C}  mMMMMMMy        /MMMMMMMs"
        "${C}  NMMMMMMy         :MMMMMMm"
        "${C}  NMMMMMMy          /MMMMMMs"
        "${C}  mMMMMMMy           oMMMMMMs"
        "${C}  +MMMMMMMy           +MMMMMMm"
        "${C}   oMMMMMMMy          /MMMMMMs"
        "${C}    yMMMMMMMds/:-:/oymMMMMMMm/"
        "${C}     -oNMMMMMMMMMMMMMMMMMNs-"
        "${C}        \`-+ydNMMMMMMNdy+-\`"
    )
}

logo_freebsd() {
    C=$RED
    LOGO=(
        "${C}   \`\`\`                        \`."
        "${C}     \` \`.....---.......--..\`\`\`   -/"
        "${C}     +o   .--\`         /y:\`      +."
        "${C}      yo\`:.            :o      \`+-"
        "${C}       y/               -/\`   -o/"
        "${C}      .-                  ::/sy+:."
        "${C}      /                     \`--  /"
        "${C}     \`:                          :\`"
        "${C}     \`:                          :\`"
        "${C}      /                          /"
        "${C}      .-                        -."
        "${C}       --                      --"
        "${C}        \`:\`                  \`:\`"
        "${C}          .--             --."
        "${C}             .---.   .---."
    )
}

logo_openbsd() {
    C=$YELLOW
    LOGO=(
        "${C}                    |    ."
        "${C}                    |.  .|\`\`\`-"
        "${C}                    |..\`  \`."
        "${C}                  ..|    .  \`."
        "${C}                .\` |   .     \`."
        "${C}           _   .   |  .   .   \`."
        "${C}         .\` \`.|   |\\.  .       \`."
        "${C}       .\`    \`|   | \`.  .        \`."
        "${C}     .\`       |   |   \`.  .        \`."
        "${C}   .\`         |   |     \`.  .        \`."
        "${C} .\`           |   |       \`.  .        \`."
        "${C}              |   |         \`.  .       \`"
        "${C}              |   |           \`.  .     ."
        "${C}              |   |             \`. .\`  ."
        "${C}              |   |               \`.\`."
        "${C}              |   |                \`."
    )
}

logo_unknown() {
    C=$WHITE
    LOGO=(
        "${C}    .--."
        "${C}   |o_o |"
        "${C}   |:_/ |"
        "${C}  //   \\\\ \\"
        "${C} (|     | )"
        "${C}/'\\\\_   _/\`\\"
        "${C}\\___)=(___/"
    )
}

# Desteklenen distro listesi (yardım mesajı için)
SUPPORTED="ubuntu, arch, fedora, gentoo, freebsd, openbsd"

# -list veya -help argümanı
if [[ "$DISTRO" == "list" || "$DISTRO" == "help" ]]; then
    echo -e "${CYAN}Kullanım:${RESET} ./libfetch.sh [distro]"
    echo -e "${CYAN}Örnek:${RESET}   ./libfetch.sh -arch"
    echo -e "${CYAN}Desteklenen:${RESET} $SUPPORTED"
    exit 0
fi

# Distro'ya göre logo seç
case "$DISTRO" in
    ubuntu)  logo_ubuntu  ;;
    arch)    logo_arch    ;;
    fedora)  logo_fedora  ;;
    gentoo)  logo_gentoo  ;;
    freebsd) logo_freebsd ;;
    openbsd) logo_openbsd ;;
    *)
        # Eğer argüman verilmişse ve tanınmıyorsa uyar
        if [[ -n "$1" ]]; then
            echo -e "${RED}Hata:${RESET} '${DISTRO}' tanınmıyor. Desteklenenler: $SUPPORTED"
            exit 1
        fi
        logo_unknown
        ;;
esac

# Bilgi satırları
INFO=(
    "${CYAN}${BOLD}${USER_NAME}${RESET}@${CYAN}${BOLD}${HOST}${RESET}"
    "${WHITE}─────────────────────────────${RESET}"
    "${GREEN}OS${RESET}:     $OS"
    "${GREEN}Kernel${RESET}: $KERNEL"
    "${GREEN}Uptime${RESET}: $UPTIME"
    "${GREEN}CPU${RESET}:    $CPU"
    "${GREEN}RAM${RESET}:    $RAM_USED / $RAM_TOTAL"
    "${GREEN}Shell${RESET}:  $SHELL_NAME"
    "${GREEN}WM/DE${RESET}:    $WM"
    "${GREEN}Packages${RESET}: $PACKAGES"
)

# Yan yana yazdır
LOGO_COL=46
LOGO_LEN=${#LOGO[@]}
INFO_LEN=${#INFO[@]}
TOTAL=$(( LOGO_LEN > INFO_LEN ? LOGO_LEN : INFO_LEN ))

for (( i=0; i<TOTAL; i++ )); do
    if (( i < LOGO_LEN )); then
        pad_to "${LOGO[$i]}${RESET}" "$LOGO_COL"
    else
        printf "%${LOGO_COL}s" ""
    fi

    if (( i < INFO_LEN )); then
        echo -e "  ${INFO[$i]}${RESET}"
    else
        echo ""
    fi
done

echo ""
