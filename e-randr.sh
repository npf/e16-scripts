#!/bin/bash
#set -x
#exec > /tmp/e-randr.$$
#exec 2>&1

INTDISPLAY=$(xrandr | grep eDP-1 | cut -f1 -d\ )
if [ $(xrandr | grep " connected" | wc -l) -gt 2 ]; then
  echo "Error: More than 2 display detected" 1>&2
  exit 1
fi
EXTDISPLAY=$(xrandr | grep " connected" | grep -v "$INTDISPLAY" | cut -f1 -d\ )

get_eesh_windows_id() {
  PAGER_ID=$(eesh "wl" | grep "^0x[[:alnum:]]\+ : Pager-0$" | cut -d\  -f1)
  ICONBOX_ID=$(eesh "wl" | grep "^0x[[:alnum:]]\+ : Iconbox$" | cut -d\  -f1)
  GKRELLM_ID=$(eesh "wl" | grep "^0x[[:alnum:]]\+ : gkrellm$" | cut -d\  -f1)
  THUNDERBIRD_ID=$(eesh "wl" | grep "^0x[[:alnum:]]\+ : .\+ - Mozilla Thunderbird$" | cut -d\  -f1 | head -n 1)
  FIREFOX_ID=$(eesh "wl" | grep "^0x[[:alnum:]]\+ : .\+ - Mozilla Firefox$" | cut -d\  -f1 | head -n 1)
}

area_absolute_to_relative() {
  echo $(($5 - $3)) $(($6 - $4))
}

wop() {
  case $2 in
    area)
      sleep 0.1
      eesh "wop $1 area $3 $4"
      ;;
    size|move)
      eesh "wop $1 $2 $3 $4"
      ;;
  esac

}

if [ -n "$EXTDISPLAY" ]; then
	EXTRESOLUTION=$(xrandr | grep $EXTDISPLAY -A1 | tail -n1 | grep -o "[[:digit:]]\+x[[:digit:]]\+")
fi

# No beep
xset -b

if [ "$EXTRESOLUTION" == "3840x2160" ]; then
  nmcli radio wifi off
  xrandr --output $INTDISPLAY --mode 3840x2160 --scale 0.666x0.666
  xrandr --output $INTDISPLAY --pos 0x721
  xrandr --output $EXTDISPLAY --mode 3840x2160 --scale 1x1
  xrandr --output $EXTDISPLAY --pos 2558x0
  eesh "restart" 
  sleep 2
  get_eesh_windows_id
  wop $GKRELLM_ID move 2386 718
  wop $ICONBOX_ID move 2388 1877
  wop $PAGER_ID size 630 174
  wop $PAGER_ID move 1864 1976
#  wop $ICONBOX_ID move 2388 1820
#  wop $PAGER_ID size 624 234
#  wop $PAGER_ID move 1870 1916
  wop $THUNDERBIRD_ID size 3838 2132
  wop $THUNDERBIRD_ID move 2558 0
  wop $THUNDERBIRD_ID area 0 0
  wop $FIREFOX_ID size 3838 2132
  wop $FIREFOX_ID move 2558 0
  wop $FIREFOX_ID area 1 0
else
	nmcli radio wifi on
  xrandr --output $INTDISPLAY --mode 3840x2160 --scale 1x1
  xrandr --output $INTDISPLAY --mode 3840x2160 --scale 0.666x0.666
  xrandr --output $INTDISPLAY --pos 0x0
  if [ -n "$EXTRESOLUTION" ]; then
    xrandr --output $EXTDISPLAY --mode $EXTRESOLUTION --scale 1x1
    xrandr --output $EXTDISPLAY --pos 2558x0
  fi
	eesh "restart" 
	sleep 2
  get_eesh_windows_id
  wop $GKRELLM_ID move 2386 0
  wop $ICONBOX_ID move 2388 1177
  wop $PAGER_ID size 273 156
  wop $PAGER_ID move 2221 1273
  wop $THUNDERBIRD_ID size 2516 1411
  wop $THUNDERBIRD_ID move 0 0
  wop $THUNDERBIRD_ID area 0 0
  wop $FIREFOX_ID size 2516 1411
  wop $FIREFOX_ID move 0 0
  wop $FIREFOX_ID area 1 0
fi

exit 0
