# ~/.bash_profile

#clear

#echo "Enter the things, you want to do in this session:"
#list=""
#read next
#while [[ -n "$next" ]]
#do
#	list="$list$next\n"
#	read next
#done
#convert -font Hack-Regular -pointsize 30 -draw "gravity northeast fill white text 20,50 '$(echo -e $list)'" /home/adam/.wallpapers/bgsrc.* /home/adam/.wallpapers/bg.png

[[ -f ~/.bashrc ]] && . ~/.bashrc

exec xinit
