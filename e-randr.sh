#!/bin/bash
#set -x
#exec > /tmp/e-randr.$$
#exec 2>&1
XRANDR="yes"
INTDISPLAY=$(xrandr | grep -e "^eDP-1\s" | cut -f1 -d\ )
if [ $(xrandr | grep " connected" | wc -l) -gt 2 ]; then
  echo "Error: More than 2 display detected" 1>&2
  exit 1
fi
EXTDISPLAY=$(xrandr | grep " connected" | grep -v -e "^$INTDISPLAY\s" | cut -f1 -d\ )

get_eesh_windows_id() {
  sleep 5
  PAGER_ID="id:$(eesh "wl" | grep "^0x[[:alnum:]]\+ : Pager-0$" | cut -d\  -f1)"
  ICONBOX_ID="id:$(eesh "wl" | grep "^0x[[:alnum:]]\+ : Iconbox$" | cut -d\  -f1)"
  GKRELLM_ID="id:$(eesh "wl" | grep "^0x[[:alnum:]]\+ : gkrellm$" | cut -d\  -f1)"
  THUNDERBIRD_ID="id:$(eesh "wl" | grep "^0x[[:alnum:]]\+ : .\+ - Mozilla Thunderbird$" | cut -d\  -f1 | head -n 1)"
  FIREFOX_ID="id:$(eesh "wl" | grep "^0x[[:alnum:]]\+ : .\+ - Mozilla Firefox$" | cut -d\  -f1 | head -n 1)"
  PIDGIN_BUDDYLIST_ID="id:$(eesh "wl" | grep "^0x[[:alnum:]]\+ : Buddy List$" | cut -d\  -f1 | head -n 1)"
}

area_absolute_to_relative() {
  echo $(($5 - $3)) $(($6 - $4))
}

wop() {
  local id=$1
  local op=$2
  local a=$3
  local b=$4
  if [ "${id%%:*}" == "id" -a -n "${id#id:}" -a -n "$op" ]; then
    id="${id#id:}"
    case $op in
      area)
        sleep 0.2
        eesh "wop $id area $a $b"
        ;;
      toggle_size)
        sleep 0.2
        eesh "wop $id toggle_size"
        ;;
      *)
        eesh "wop $id $op $a $b"
        ;;
    esac
  fi
}

if [ -n "$EXTDISPLAY" ]; then
	#EXTRESOLUTION=$(xrandr | grep -e "^$EXTDISPLAY\s" -A1 | tail -n1 | grep -o "[[:digit:]]\+x[[:digit:]]\+")
  EXTRESOLUTION=$(xrandr | perl -ne 'if (/^([\w-]+)\sconnected/) { $monitor=$1 } elsif (/^\s+(\d+)x(\d+)/) { $h->{$monitor}->{$1}->{$2}=1; }; END{use Data::Dumper; foreach $m (keys(%$h)) { @ax=sort {$b <=> $a} keys(%{$h->{$m}}); $x = @ax[0]; @ay = sort {$b <=> $a} keys(%{$h->{$m}->{$x}}); $y = @ay[0]; print $m." ".$x."x".$y."\n"}}' | grep -e "^$EXTDISPLAY\s" | grep -o "[[:digit:]]\+x[[:digit:]]\+")
fi

# No beep
xset -b

if [ "$EXTRESOLUTION" == "3840x2160" ]; then
  nmcli radio wifi off
  if [ "$XRANDR" != "no" ]; then
    #xrandr --output $INTDISPLAY --mode 3840x2160 --scale 1x1
    #xrandr --output $INTDISPLAY --mode 3840x2160 --scale 0.666x0.666 --pos 0x0
    #xrandr --output $INTDISPLAY --mode 3840x2160 --scale 0.666x0.666 --pos 0x721 --output $EXTDISPLAY --mode 3840x2160 --scale 1x1 --pos 2558x0
    xrandr --output $INTDISPLAY --mode 2560x1440 --scale 1x1 --pos 0x720 --output $EXTDISPLAY --mode 3840x2160 --scale 1x1 --pos 2560x0
  	sleep 2
  fi
  eesh "restart" 
  get_eesh_windows_id
  wop $GKRELLM_ID move 2386 718
  wop $ICONBOX_ID move 2388 1843
  wop $PAGER_ID size 630 174
  wop $PAGER_ID move 1864 1937
#  wop $ICONBOX_ID move 2388 1820
#  wop $PAGER_ID size 624 234
#  wop $PAGER_ID move 1870 1916
#  wop $THUNDERBIRD_ID size 3838 2132
  wop $THUNDERBIRD_ID size 3800 2132
  wop $THUNDERBIRD_ID move 2558 0
  wop $THUNDERBIRD_ID toggle_size
  wop $THUNDERBIRD_ID area 0 0
#  wop $FIREFOX_ID size 3838 2132
  wop $FIREFOX_ID size 3800 2132
  wop $FIREFOX_ID move 2558 0
  wop $FIREFOX_ID toggle_size
  wop $FIREFOX_ID area 1 0
  wop $PIDGIN_BUDDYLIST_ID size 311 962
  wop $PIDGIN_BUDDYLIST_ID move 2073 721
  wop $PIDGIN_BUDDYLIST_ID area 0 0
else
	nmcli radio wifi on
  if [ "$XRANDR" != "no" ]; then
    #xrandr --output $INTDISPLAY --mode 3840x2160 --scale 1x1
    #xrandr --output $INTDISPLAY --mode 3840x2160 --scale 0.666x0.666 --pos 0x0
    xrandr --output $INTDISPLAY --mode 2560x1440 --scale 1x1 --pos 0x0
    if [ -n "$EXTRESOLUTION" ]; then
      # configure the external display right side, but will not change the position of the application windows
      #xrandr --output $INTDISPLAY --mode 3840x2160 --scale 0.666x0.666 --pos 0x0 --output $EXTDISPLAY --mode $EXTRESOLUTION --scale 1x1 --pos 2558x0
      xrandr --output $INTDISPLAY --mode 2560x1440 --scale 1x1 --pos 0x0 --output $EXTDISPLAY --mode $EXTRESOLUTION --scale 1x1 --pos 2560x0
    fi
	  sleep 2
  fi
	eesh "restart" 
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
