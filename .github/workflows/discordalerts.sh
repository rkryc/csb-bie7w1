echo -e "\033[32;5mStarting Attack Logs \033[0m"
interface=eth0
dumpdir=/root/TCPDumps
capturefile=/root/TCPDumps
 url='https://discord.com/api/webhooks/828934744343183360/skIvL38ioqt1KAXaoih8n99CrD_rEWpcC0KzRqIiFSESb3MKoePdkAQS6uqS-N0J4Nw5' ## Change this to your Webhook URL
while /bin/true; do
  pkt_old=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  sleep 1
  pkt_new=`grep $interface: /proc/net/dev | cut -d :  -f2 | awk '{ print $2 }'`
  sleep 1
  pkt_rx=`grep -oP $interface: /proc/net/dev \s*\K\d+'`
  sleep 1
  pkt_tx=`grep -oP $interface: /proc/net/dev \s*(\d+\s+){8}\K\d+'`
  pkt=$(( $pkt_new - $pkt_old ))
  echo -ne "\r$pkt packets/s\033[0K"
  ## tcpdump -n -s0 -c 1000 -w $dumpdir/dump.`date +"%Y%m%d-%H%M%S"`.cap
  ## echo "Detecting Attack Packets"
  ## sleep 1
  if [ $pkt -gt 25000 ]; then ## Attack alert will display after incoming traffic reach 25000 PPS
    echo "Attack Detected"
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
      	"inline": false,
        "title": "Attack Detected",
        "username": "Discord Attack Alerts",
        "color": 15158332,
         "thumbnail": {
          "url": "https://imgur.com/a/tyVqYbw.png"
        },
         "footer": {
            "text": "NYC, US",
            "icon_url": "https://cdn.countryflags.com/thumbs/united-states-of-america/flag-800.png"
          },

        "description": "Detection of an attack ",
         "fields": [
      {
        "name": "**Server Provider**",
        "value": "Hosting",
        "inline": false
      },
      {
        "name": "**IP Address**",
        "value": "x.x.x.x",
        "inline": false
      },
      {
        "name": "**Location**",
        "value": "New York, New York",
        "inline": false
      }
    ]
      }]
    }' $url
    echo "Paused for."
    sleep 220  ## The "Attack no longer detected" alert will display in 220 seconds
    ## echo "Traffic Attack Packets Scrubbed"
    curl -H "Content-Type: application/json" -X POST -d '{
      "embeds": [{
      	"inline": false,
        "title": "Attack Filtered",
        "username": "Discord Attack Alerts",
        "color": 3066993,
         "thumbnail": {
          "url": "https://imgur.com/a/tyVqYbw.png"
        },
         "footer": {
            "text": "NYC, US",
            "icon_url": "https://cdn.countryflags.com/thumbs/united-states-of-america/flag-800.png"
          },    

        "description": "End of attack",
         "fields": [
      {
        "name": "**Server Provider**",
        "value": "Hosting",
        "inline": false
      },
      {
        "name": "**IP Address**",
        "value": "x.x.x.x",
        "inline": false
      },
      {
        "name": "**Location**",
        "value": "New York, New York",
        "inline": false
      }
    ]
      }]
    }' $url
  fi
done
