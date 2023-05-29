FOLDER_NAME=$(cat /dev/urandom |tr -dc 'a-zA-Z0-9' |fold -w 8 |head -n 1)
mkdir /tmp/$FOLDER_NAME
cd /tmp/$FOLDER_NAME
echo "Create the directory" $FOLDER_NAME