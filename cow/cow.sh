docker run --name cow --net host \
    -e listen=http://0.0.0.0:7777 \
    -e userPasswd=mid:mid \
    -e proxy=ss://aes-256-cfb:Luxxxembourg@5.1.4.1:1984 \
    --rm -it fzinfz/cow  -request
