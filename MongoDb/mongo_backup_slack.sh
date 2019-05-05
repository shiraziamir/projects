DEST="/data/backup/mongodump-$TODAY"
sudo mkdir $DEST

STATUS="FAILED";
APP_SLACK_ICON_EMOJI=':thumbsdown:'
START=$(date +%s);


sudo mongodump --oplog --gzip  --out $DEST --authenticationDatabase admin --username admin --password "123" && STATUS="OK" && APP_SLACK_ICON_EMOJI=':thumbsup:'

END=$(date +%s);
DURATION=`echo $((END-START)) | awk '{print int($1/60)":"int($1%60)}'`

STORAGE=`du -sh $DEST|awk '{print $1}'`
FREE=`df -h|grep sda1|awk '{print $4}'`



slack_message="Prod DB Backup done: $STATUS, duration: $DURATION [m:s], took space: $STORAGE on $DEST, disk free space: $FREE"
channel='#notifications'
APP_SLACK_USERNAME='user@example.com'
APP_SLACK_WEBHOOK='https://hooks.slack.com/services/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'

curl --silent --data-urlencode \
    "$(printf 'payload={"text": "%s", "channel": "%s", "username": "%s", "as_user": "true", "link_names": "true", "icon_emoji": "%s" }' \
        "${slack_message}" \
        "${channel}" \
        "${APP_SLACK_USERNAME}" \
        "${APP_SLACK_ICON_EMOJI}" \
    )" \
   ${APP_SLACK_WEBHOOK}


