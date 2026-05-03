#!/usr/bin/env bash

SN=$(echo "$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM$RANDOM" | head -c 8)

#================#
while true; do
  	read -p "OLTgeist<${CTX:-#}> " cmdy
  
case "$cmdy" in

	"gen onu")
	touch ONU-"$SN"
	echo "onu created."
;;
    "display ont 1")
      jq '.' onts/ONT1.json
;;
    "ont 1 wifi set "*)
      ssid=$(echo $cmd | cut -d' ' -f5)
      jq ".wifi_ssid = \"$ssid\"" onts/ONT1.json > tmp && mv tmp onts/ONT1.json
      echo "WiFi updated"
;;
    "ont 1 remote enable")
      jq '.remote_access = true' onts/ONT1.json > tmp && mv tmp onts/ONT1.json
      echo "Remote access enabled"
;;
	use\ *)
       dir=${cmdy#use }

            if [[ $dir =~ ^[0-9]+-[0-9]+$ ]]; then
                if [ -d "$dir" ]; then
                    cd "$dir"
                    CTX=${dir/-//}
                else
                    echo "Slot-PON not found"
                fi
            else
                echo "Invalid format (use X-Y)"
            fi	
;;
	"show onu")
		ls
;;
    *)
      continue
;;

  esac
done
