#!/bin/bash
cd ~/Documents/Notes

# echo "git pull"
# git pull

echo "git status"
git status

get_char(){
 SAVEDSTTY=`stty -g`
 stty -echo
 stty cbreak
 dd if=/dev/tty bs=1 count=1 2> /dev/null
 stty -raw
 stty echo
 stty $SAVEDSTTY
}
echo "Press any key to continue!"
char=`get_char`

echo "git add ."
git add .

echo "git commit -m docs: update notes at `date '+%Y/%m/%d %H:%M'`"
git commit -m "docs: update notes at `date '+%Y/%m/%d %H:%M'`"

echo "git push"
git push
