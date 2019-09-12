FILE=../urls.txt

cd src/
while read -r url; do 
  echo $url
  sleep 1
  CLEAN_URL=${url%$'\r'}
  curl "$CLEAN_URL" \
    -H 'Connection: keep-alive' \
    -H 'Upgrade-Insecure-Requests: 1' \
    -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/76.0.3809.100 Safari/537.36'  \
    -H 'Sec-Fetch-Mode: navigate' \
    -H 'Sec-Fetch-User: ?1'  \
    -H 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3'  \
    -H 'Sec-Fetch-Site: same-origin'  \
    -H 'Referer: https://www.ine.es/jaxiT3/dlgExport.htm?t=30917&L=0&nocab=1'  \
    -H 'Accept-Encoding: gzip, deflate, br' \
    -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8'  \
    -H 'Cookie: JSESSIONID=D6997854D142EF1641CA380D51AA4A18.jaxiT303; TS0168b5fc=018b1b3cc2417e2c8f2f770315b869383ad7ca6a36fa5f1b08fffb24bd491a769cc3d4779d61e150b91764427d2394de69e4ed3bf94b0d79a9021d877b99c5b789fb9f90d4; INE_WEB_COOKIE=es_ES; TS017d943d=018b1b3cc2f27d89317142731ee248f0fbab4b806b13f0c3052245c0988f6ef737d8d1a31b76360f7d2989c40a1295240c1514c04b71d8b8e4cf5883a7d23900fe190d3e26' \
    -O \
    --compressed
done < "$FILE"
