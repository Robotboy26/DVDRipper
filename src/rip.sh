dest=$"/home/robotserver/external/jellyfin/movies/"

sudo apt install eject gddrescue -y

process_dvd() {
	local number=$1
	dvdbackup -i /dev/sr$number -I -v > read$number.txt

	content=$(grep 'DVD-Video information of the DVD with title' "read$number.txt" | sed 's/.*"\(.*\)"/\1/')
	echo "$content is now being ripped"
	if [ -z "$content" ]; then
		echo "There is no dvd"
		exit
	fi

	sudo mkdir "$dest$content"
 	sudo mkdir "$dest$content/iso"
	sudo cp read$number.txt "$dest$content/$content.info.log"
	sudo rm read$number.txt
	# dvdbackup -i /dev/sr${list[index]} -o "$content" -F -p
 	# blocks=$(isosize -d 2048 /dev/sr0)
	sudo touch "$dest$content/iso/$content.iso"
	isoLoc=$"$dest$content/iso/$content.iso"
 	sudo ddrescue /dev/sr$number "$isoLoc"
	echo "downloaded the iso file for $content into $isoLoc in location $dest"
	eject /dev/sr$number -F
	sudo makemkvcon mkv "$isoLoc" 0 "$dest$content"
}

process_dvd 0
process_dvd 1
