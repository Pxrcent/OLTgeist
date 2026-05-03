#!/usr/bin/env bash

#================#
GEISTDIR="$HOME/.config/OLTgeist/"
#================#
gen_onu_json() {
    local sn="$1"
    local file="ONU-$sn.json"
	
    cat > "$file" <<EOF
{
  "serial_number": "$sn",
  "Slot/PON/ID": "x/y/z",
  "status": "online",
  "rx_power_dbm": "-$(shuf -i 13-33 -n1).$(shuf -i 0-99 -n1)dB",
  "tx_power_dbm": "$((RANDOM % 5 + 1))",
  "temperature_c": "$(shuf -i 30-90 -n1)ºC",
  "LAN_address": "192.168.1.1",
  "WAN_address": "to do...",
  "last_updated_info": "$(date +%F_%T)"
}
EOF
}
#================#

while true; do
  	read -e -p "OLTgeist<${CTX:-#}> " cmdy
  
case "$cmdy" in

	"gen onu")
if [[ "$CTX" != "" ]]; then # checking if its inside a Slot-PON folder before creating a ONU

		SN=$(echo "$RANDOM$RANDOM" | md5sum | tr [:lower:] [:upper:] | head -c 8) # generates a random SN for each ONU
		gen_onu_json "$SN"
		echo "onu "$SN" created on Slot-PON "$CTX"."
		echo "$CTX"
	else
		echo "no Slot-PON selected."
		echo "select one using 'use X-Y'"
		echo "[FAIL]"
		continue
fi
;;
    "display onu info") # wip
      jq '.' ONU-*
;;
    "ont wifi set"*) # wip
  #    jq ".wifi_ssid = \"$ssid\"" onts/ONT1.json > tmp && mv tmp onts/ONT1.json
;;
    "ont 1 remote enable") # wip
  #    jq '.remote_access = true' onts/ONT1.json > tmp && mv tmp onts/ONT1.json
;;
	use\ *)
	 cmdyp=$(echo "$cmdy" | cut -c5-)		# cuts the word "use"
	SLPN="$GEISTDIR$cmdyp"				# glues the dir to the path
	if [[ -d "$SLPN" ]]; then			# check if it is created
	
		cd "$SLPN" 
		echo "entering $PWD"
		CTX="$cmdyp"			# changes the prompt
		echo "[SUCC]"
	else
		echo "Slot-PON $SLPN does not exist"
		echo "[FAIL]"
		echo "returning to default..."
		cd "$GEISTDIR"
		CTX=""			# resets the prompt
		continue
	fi		 
;;
	"exit")
		echo "terminating..."
		exit 0 ;;
    *)
      continue
;;

  esac
done
