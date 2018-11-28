# ~/.bash_profile

clear

cd ~/scripts
./syncdown
cd ~

echo "Enter the things, you want to do in this session:"
list=""
read next
while [[ -n "$next" ]]
do
	list="$list$next\n"
	read next
done
convert -font Hack-Regular -pointsize 30 -draw "gravity northeast fill white text 20,50 '$(echo -e $list)'" /home/adam/.wallpapers/bg1src.jpg /home/adam/.wallpapers/bg1.jpg 

[[ -f ~/.bashrc ]] && . ~/.bashrc
if [[ ! $DISPLAY && $XDG_VTNR -eq 1 ]]; then
       exec startx
fi       
