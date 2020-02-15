#!/bin/bash

echo $PWD > /tmp/pwd.txt

APP_SLACK_ICON_EMOJI=':secret:'
channel='#server_errors'
APP_SLACK_USERNAME='email@gmail.com'
APP_SLACK_WEBHOOK='https://hooks.slack.com/services/TC419MJ02/xxxxxxxxx/yyyyyyyyyyyyyyyyyyyyyyyy'

output=$( curl  -s -XGET "http://127.0.0.1:9200/apm-*-error*/_search" -H 'Content-Type: application/json' -d'{  "query" : {    "bool" : {      "must": [      {         "range": {                 "@timestamp": {                     "gte": "now-30m",  "lt": "now" } }     }     ]    }  }  }' )

links=`for i in $(echo $output | jq . | egrep  "grouping_key"|awk -F: '{print $2}'| tr -d "\", "|sort |uniq );do echo apm_links: http://192.168.1.1/app/apm#/bambo-apm/errors/$i;done`
types=`for i in $(echo $output | jq . | egrep  "type" |egrep -v "apm-server|_doc" | tr -d "\", " | sort | uniq );do echo $i;done`
handled=`for i in $(echo $output | jq . | egrep  "handled" | tr -d "\", " | sort | uniq );do echo $i;done`
messages=`for i in $(echo $output | jq . | egrep  "message" | tr -d "\"\n\t" | sort | uniq );do echo $i;done`


slack_message="$handled
 $types
 $links"
 
test=`echo $slack_message | tr -d "\n\t "`

if [  -z "$test" ]; then 
       :
else
   curl --silent --data-urlencode \
    "$(printf 'payload={"text": "%s", "channel": "%s", "username": "%s", "as_user": "true", "link_names": "true", "icon_emoji": "%s" }' \
        "${slack_message}" \
        "${channel}" \
        "${APP_SLACK_USERNAME}" \
        "${APP_SLACK_ICON_EMOJI}" \
    )" \
   ${APP_SLACK_WEBHOOK}
fi


