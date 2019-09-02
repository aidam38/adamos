file="/home/adam/drive/zapisy/denicek/$(date '+%Y')/$(date '+%Y%m%d-%H%M').md"

echo -e "--- **$(date '+%a %d. %m. %Y | %R')** ---  \n" > $file

st -i -g 80x20+$(xdpyinfo | awk '/dimensions/{split($2,a,"x"); printf("%3.0f+%3.0f", a[1]/2-80/2*9.65, a[2]/2-20/2*20.76)}') -e kak -e 'exec ji' $file
