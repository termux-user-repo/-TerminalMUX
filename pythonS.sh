#!/usr/bin/env bash
# ============================================================
#  🐍 pythonS  —  curl -sL <raw-url> | bash
#  A tiny terminal toy: shows your public IP + geolocation,
#  with spinner/loading effects and ASCII art.
# ============================================================

set -uo pipefail

# ---------- colors ----------
RESET="\033[0m"
BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
MAGENTA="\033[35m"
RED="\033[31m"

# ---------- ascii art banner ----------
banner() {
  clear
  echo -e "${GREEN}"
  cat << 'EOF'
        _   _                 __
       | |_| |__   ___  _ __ / _\
       | __| '_ \ / _ \| '_ \\ \
       | |_| | | | (_) | | | \_\
        \__|_| |_|\___/|_| |_|

   🐍  p y t h o n S   t e r m i n a l  🐍
EOF
  echo -e "${RESET}"
  echo -e "${MAGENTA}"
  cat << 'EOF'
      .------.
     |A .--. |      GitHub
     | (    )|      -------
     |  '--'A|      octo-cat says hi 🐙
     `------'
EOF
  echo -e "${RESET}"
}

# ---------- spinner: rotates \ twice ----------
spinner_loading() {
  local msg="$1"
  local chars=('\' '|' '/' '-')
  echo -ne "${YELLOW}${msg} ${RESET}"
  for round in 1 2; do
    for c in "${chars[@]}"; do
      echo -ne "\b${c}"
      sleep 0.15
    done
  done
  echo -e "\b${GREEN}✔${RESET}"
}

# ---------- progress bar: fills with # slowly ----------
progress_bar() {
  local msg="$1"
  local width=20
  echo -ne "${CYAN}${msg} ${RESET}["
  for ((i = 0; i < width; i++)); do
    echo -ne "#"
    sleep 0.08
  done
  echo -e "]${GREEN} done${RESET}"
}

# ---------- fetch public ip ----------
get_ip() {
  curl -s https://api.ipify.org 2>/dev/null || curl -s https://ifconfig.me 2>/dev/null
}

# ---------- fetch geolocation for an ip ----------
get_geo() {
  local ip="$1"
  curl -s "http://ip-api.com/json/${ip}?fields=status,message,country,regionName,city,zip,lat,lon,isp,org,query"
}

# ---------- pretty-print geo json without jq dependency ----------
print_geo() {
  local json="$1"
  local status
  status=$(echo "$json" | grep -o '"status":"[a-z]*"' | cut -d'"' -f4)

  if [[ "$status" != "success" ]]; then
    echo -e "${RED}Could not resolve geolocation.${RESET}"
    return
  fi

  local country region city zip lat lon isp org
  country=$(echo "$json" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
  region=$(echo "$json"  | grep -o '"regionName":"[^"]*"' | cut -d'"' -f4)
  city=$(echo "$json"    | grep -o '"city":"[^"]*"' | cut -d'"' -f4)
  zip=$(echo "$json"     | grep -o '"zip":"[^"]*"' | cut -d'"' -f4)
  lat=$(echo "$json"     | grep -o '"lat":[^,]*' | cut -d':' -f2)
  lon=$(echo "$json"     | grep -o '"lon":[^,]*' | cut -d':' -f2)
  isp=$(echo "$json"     | grep -o '"isp":"[^"]*"' | cut -d'"' -f4)
  org=$(echo "$json"     | grep -o '"org":"[^"]*"' | cut -d'"' -f4)

  echo -e "${BOLD}City:${RESET}     ${city}"
  echo -e "${BOLD}Region:${RESET}   ${region}"
  echo -e "${BOLD}Country:${RESET}  ${country}"
  echo -e "${BOLD}Zip:${RESET}      ${zip}"
  echo -e "${BOLD}Lat/Lon:${RESET}  ${lat}, ${lon}"
  echo -e "${BOLD}ISP:${RESET}      ${isp}"
  echo -e "${BOLD}Org:${RESET}      ${org}"
}

# ---------- repo data fetch simulation ----------
fetch_repo_data() {
  progress_bar "Getting GitHub repository data"
}

show_ip_flow() {
  spinner_loading "Loading 🐍pythonS"
  fetch_repo_data
  local ip
  ip=$(get_ip)
  if [[ -z "$ip" ]]; then
    echo -e "${RED}Failed to get your IP. Check your internet connection.${RESET}"
    return
  fi
  echo -e "\n${BOLD}Your public IP:${RESET} ${GREEN}${ip}${RESET}\n"
}

show_geo_flow() {
  spinner_loading "Loading 🐍pythonS"
  fetch_repo_data
  local ip
  ip=$(get_ip)
  if [[ -z "$ip" ]]; then
    echo -e "${RED}Failed to get your IP. Check your internet connection.${RESET}"
    return
  fi
  local geo
  geo=$(get_geo "$ip")
  echo -e "\n${BOLD}Geolocation for ${ip}:${RESET}"
  print_geo "$geo"
  echo
}

pause() {
  echo -e "${YELLOW}Press [Enter] to continue...${RESET}"
  read -r
}

menu() {
  while true; do
    banner
    echo -e "${BOLD}Choose an option:${RESET}"
    echo "  1) Show my public IP"
    echo "  2) Show my geolocation"
    echo "  3) Show both"
    echo "  4) Exit"
    echo -ne "${CYAN}> ${RESET}"
    read -r choice
    case "$choice" in
      1) show_ip_flow; pause ;;
      2) show_geo_flow; pause ;;
      3) show_ip_flow; show_geo_flow; pause ;;
      4) echo -e "${GREEN}Bye! 🐍${RESET}"; exit 0 ;;
      *) echo -e "${RED}Invalid choice.${RESET}"; sleep 1 ;;
    esac
  done
}

menu
