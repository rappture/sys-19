#!/bin/bash

CONNECT_TO=shkutova_yuliya@10.0.3.8
DEST_PATH=$CONNECT_TO:/tmp/backups/$(date '+%Y-%m-%d_%H-%M-%S')
NUM_OF_COPIES=$(ssh $CONNECT_TO 'find /tmp/backups/* -maxdepth 0 | sort | wc -l' 2> /dev/null)
LIST_OF_COPIES=$(ssh $CONNECT_TO 'find /tmp/backups/* -maxdepth 0 | sort' 2> /dev/null)
OLDEST_COPY=$(ssh $CONNECT_TO 'find /tmp/backups/* -maxdepth 0 | sort | head -n 1' 2> /dev/null)
LATEST_COPY=$(ssh $CONNECT_TO 'find /tmp/backups/* -maxdepth 0 | sort -r | head -n 1' 2> /dev/null)
if [ $NUM_OF_COPIES == 0 ]
then
	$(ssh $CONNECT_TO "mkdir /tmp/backups 2> /dev/null") && \
	LINK_DEST=""
else
	LINK_DEST="--link-dest=$LATEST_COPY"
fi
	
echo -e "Welcome to my backup sript! Current list of backups below:\n$LIST_OF_COPIES\n"

echo -e "\nPlease choose one of the available options:\n-to make a new back up enter 1;\n-to restore the directory $HOME to its previous state enter 2."

read OPTION
if [ $OPTION == '1' ]
then 
	if [ $NUM_OF_COPIES -lt '5' ]
	then 
		echo "Making the backup..." && \
		rsync -ac $LINK_DEST $HOME/ $DEST_PATH && \
		echo "DONE!" && \
		exit 0
	else 
		echo -e "You are not allowed to store more than 5 backups.\nEnter YES (uppercase) if you would like to permanently delete the oldest backup $OLDEST_COPY and make a new one.\nAny other input will stop the script."
	read DELETE_DESISION
		if [ $DELETE_DESISION == 'YES' ]
		then 
			$(ssh $CONNECT_TO "rm -rf $OLDEST_COPY") && \
			echo -e "$OLDEST_COPY deleted.\nMaking the new backup..." && \
			rsync -ac --link-dest=$LATEST_COPY $HOME/ $DEST_PATH && \
			echo "DONE!"
			exit 0
		else 
			echo "Stopped by user"
			exit 0
		fi	
	fi	

elif [ $OPTION == '2' ]
then
	if [ $NUM_OF_COPIES == '0' ]
	then
		echo "There is no backup to restore from!" >&2
		exit 1
	else
       		echo -e "The list of current backups was given at the start of the script.\nPlease enter the full path to the copy you would like to restore (without "/" at the end)."
		read RESTORE
		myarray=($LIST_OF_COPIES)
		#echo "My array: ${myarray[@]}"
		#echo "Number of elements in the array: ${#myarray[@]}"
		for item in ${myarray[@]}
		do
			if [ "$item" == "$RESTORE" ]
			then
				echo "Restoring the directory..." && \
				rsync -ac --delete $CONNECT_TO:$RESTORE/ $HOME/ && \
				echo "RESTORED!" && exit 0
			fi
		done
		for item in ${myarray[@]}
		do
			if [ "$item" != "$RESTORE" ]
			then
				echo "No such backup exists!" >&2
			fi
		done

	fi	
else echo "Unexpected input!" >&2
exit 1
fi
