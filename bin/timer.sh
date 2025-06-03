#!/bin/sh

h="$1"
m="$2"
s="$3"

p() { printf "$@"; }
bigger() {
case "$1" in
0|1)
  case "$2" in
  0) case "$1" in 0) p "  ####  ";; 1) p "      ##";; esac;;
  1) case "$1" in 0) p " ###### ";; 1) p "     ###";; esac;;
  2) case "$1" in 0) p "##    ##";; 1) p "    ####";; esac;;
  3) case "$1" in 0) p "##    ##";; 1) p "   #####";; esac;;
  4) case "$1" in 0) p "##    ##";; 1) p "  ### ##";; esac;;
  5) case "$1" in 0) p "##    ##";; 1) p " ###  ##";; esac;;
  6) case "$1" in 0) p "##    ##";; 1) p "###   ##";; esac;;
  7) case "$1" in 0) p "##    ##";; 1) p "      ##";; esac;;
  8) case "$1" in 0) p " ###### ";; 1) p "      ##";; esac;;
  9) case "$1" in 0) p "  ####  ";; 1) p "      ##";; esac;;
  esac;;
2|3)
  case "$2" in
  0) case "$1" in 2) p " #####  ";; 3) p " #####  ";; esac;;
  1) case "$1" in 2) p "####### ";; 3) p "####### ";; esac;;
  2) case "$1" in 2) p "      ##";; 3) p "      ##";; esac;;
  3) case "$1" in 2) p "      ##";; 3) p "      ##";; esac;;
  4) case "$1" in 2) p "  ##### ";; 3) p "  ##### ";; esac;;
  5) case "$1" in 2) p " #####  ";; 3) p "  ##### ";; esac;;
  6) case "$1" in 2) p "###     ";; 3) p "      ##";; esac;;
  7) case "$1" in 2) p "##      ";; 3) p "      ##";; esac;;
  8) case "$1" in 2) p "########";; 3) p "####### ";; esac;;
  9) case "$1" in 2) p "########";; 3) p " #####  ";; esac;;
  esac;;
4|5)
  case "$2" in
  0) case "$1" in 4) p "    ##  ";; 5) p "########";; esac;;
  1) case "$1" in 4) p "   ###  ";; 5) p "########";; esac;;
  2) case "$1" in 4) p "  ####  ";; 5) p "##      ";; esac;;
  3) case "$1" in 4) p " #####  ";; 5) p "##      ";; esac;;
  4) case "$1" in 4) p "##  ##  ";; 5) p "######  ";; esac;;
  5) case "$1" in 4) p "##  ##  ";; 5) p "####### ";; esac;;
  6) case "$1" in 4) p "########";; 5) p "      ##";; esac;;
  7) case "$1" in 4) p "########";; 5) p "      ##";; esac;;
  8) case "$1" in 4) p "    ##  ";; 5) p "####### ";; esac;;
  9) case "$1" in 4) p "    ##  ";; 5) p " #####  ";; esac;;
  esac;;
6|7)
  case "$2" in
  0) case "$1" in 6) p "  ##### ";; 7) p "########";; esac;;
  1) case "$1" in 6) p " ###### ";; 7) p "########";; esac;;
  2) case "$1" in 6) p "##      ";; 7) p "      ##";; esac;;
  3) case "$1" in 6) p "##      ";; 7) p "     ###";; esac;;
  4) case "$1" in 6) p "######  ";; 7) p "  ##### ";; esac;;
  5) case "$1" in 6) p "####### ";; 7) p "  ##### ";; esac;;
  6) case "$1" in 6) p "##    ##";; 7) p "  ###   ";; esac;;
  7) case "$1" in 6) p "##    ##";; 7) p " ###    ";; esac;;
  8) case "$1" in 6) p " ###### ";; 7) p "###     ";; esac;;
  9) case "$1" in 6) p "  ####  ";; 7) p "##      ";; esac;;
  esac;;
8|9)
  case "$2" in
  0) case "$1" in 8) p "  ####  ";; 9) p "  ####  ";; esac;;
  1) case "$1" in 8) p " ###### ";; 9) p " ###### ";; esac;;
  2) case "$1" in 8) p "##    ##";; 9) p "##    ##";; esac;;
  3) case "$1" in 8) p "##    ##";; 9) p "##    ##";; esac;;
  4) case "$1" in 8) p " ###### ";; 9) p " #######";; esac;;
  5) case "$1" in 8) p " ###### ";; 9) p "  ######";; esac;;
  6) case "$1" in 8) p "##    ##";; 9) p "      ##";; esac;;
  7) case "$1" in 8) p "##    ##";; 9) p "      ##";; esac;;
  8) case "$1" in 8) p " ###### ";; 9) p "      ##";; esac;;
  9) case "$1" in 8) p "  ####  ";; 9) p "      ##";; esac;;
  esac;;
':'|' ')
  case "$2" in
  0) case "$1" in ':') p "  ";; ' ') p "  ";; esac;;
  1) case "$1" in ':') p "  ";; ' ') p "  ";; esac;;
  2) case "$1" in ':') p "##";; ' ') p "  ";; esac;;
  3) case "$1" in ':') p "##";; ' ') p "  ";; esac;;
  4) case "$1" in ':') p "  ";; ' ') p "  ";; esac;;
  5) case "$1" in ':') p "  ";; ' ') p "  ";; esac;;
  6) case "$1" in ':') p "##";; ' ') p "  ";; esac;;
  7) case "$1" in ':') p "##";; ' ') p "  ";; esac;;
  8) case "$1" in ':') p "  ";; ' ') p "  ";; esac;;
  9) case "$1" in ':') p "  ";; ' ') p "  ";; esac;;
  esac;;
esac
}

if [ -z "$h" ] || [ "0" = "$h" ]; then
  if [ -z "$m" ] || [ "0" = "$m" ]; then
    message="Time's Up (${s}seconds)"
  else
    message="Time's Up (${m}minutes ${s}seconds)"
  fi
else
  message="Time's Up (${h}hours ${m}minutes ${s}seconds)"
fi

print_big() {
  for r in $(seq 0 9); do
    echo "$1" | sed 's/./&\n/g' | while read n; do
      bigger $n $r
      bigger " " $r
    done
    echo
  done
}

printed_big=""
print_time_big() {
  if [ -n "$printed_big" ]; then
    for i in $(seq 0 9); do
      printf '\e[1A\e[2K\r'
    done
  fi

  if [ -z "$1" ] || [ "0" = "$1" ]; then
    print_big $(printf '%d:%02d' "$2" "$3")
  else
    print_big $(printf '%d:%02dd:%02d' "$1" "$2" "$3")
  fi
  printed_big=1
}

print_time() {
  if [ -z "$1" ] || [ "0" = "$1" ]; then
    printf '\e[2K\r%d:%02d' "$2" "$3"
  else
    printf '\e[2K\r%d:%02dd:%02d' "$1" "$2" "$3"
  fi
}

for h in $(seq $h -1 0); do
  for m in $(seq $m -1 0); do
    for s in $(seq $s -1 0); do
      print_time_big "$h" "$m" "$s"
      sleep 1
    done
    s=59
  done
  m=59
done

echo
notify-send --icon /usr/share/icons/Papirus/48x48/categories/alarm-timer.svg "BEEP BEEP" "$message"
