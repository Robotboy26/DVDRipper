dest="/home/robotserver/external/jellyfin/movies/"

if [ "$(id -u)" -eq 0 ]; then
  echo "Script is running with sudo"
else
  echo "Please run the script with sudo"
  exit
fi

read -p "enter the drive number " num

apt install eject gddrescue -y

process_dvd() {
	local number=$1
	deviceName="/dev/sr$number"
	
	# Measure the time taken by the 'eject -t' command
	start=$(date +%s.%N)
	eject -t $deviceName &>/dev/null &
	wait
	end=$(date +%s.%N)
	elapsed=$(awk "BEGIN {print $end - $start}")
	elapsed=$(printf "%.0f" $elapsed)

	# Determine if the drive is open or closed based on time elapsed
	if [ $elapsed -gt 0 ]; then
		# If the drive was open and needed to be closed
		eject $deviceName -r &
		wait
		echo "Drive was open"
		return
	else
		# If the drive was already closed
		echo "Drive was already closed"
	fi

	dvdbackup -i /dev/sr$number -I -v > read$number.txt
	content=$(grep 'DVD-Video information of the DVD with title' "read$number.txt" | sed 's/.*"\(.*\)"/\1/')
	echo "$content is now being ripped"
	if [ -z "$content" ]; then
		echo "There is no dvd"
		return
	fi

	mkdir "$dest$content"
 	mkdir "$dest$content/iso"
	cp read$number.txt "$dest$content/$content.info.log"
	rm read$number.txt
	# dvdbackup -i /dev/sr${list[index]} -o "$content" -F -p
 	# blocks=$(isosize -d 2048 /dev/sr0)
	touch "$dest$content/iso/$content.iso"
	isoLoc="$dest$content/iso/$content.iso"
 	ddrescue --direct -r2 -R -T240 -v /dev/sr$number "$isoLoc"
	echo "downloaded the iso file for $content into $isoLoc in location $dest"
	eject /dev/sr$number -r
	makemkvcon mkv "$isoLoc" 0 "$dest$content"
}

while true; do
	process_dvd $num
	sleep 4m
done
