list=(0)

for index in "${!list[@]}"; do
    dvdbackup -i /dev/sr${list[index]} -I -v > read${list[index]}.txt

  content=$(grep 'DVD-Video information of the DVD with title' "read${list[index]}.txt" | sed 's/.*"\(.*\)"/\1/')
  echo "$content is now being ripped"

	mkdir "$content"
 	mkdir "$content/iso"
	cp read${list[index]}.txt "$content/$content.info.log"
	rm read${list[index]}.txt
  dvdbackup -i /dev/sr${list[index]} -o "$content" -F -p
  # Convert the ripped track to MKV using ffmpeg
  output_file="$content/$content.mkv"
  # now get the main title in mkv format
 	blocks=$(isosize -d 2048 /dev/sr0)
  touch "$content/iso/$content.iso"
 	sudo dd if=/dev/sr${list[index]} "of=$content/iso/$content.iso" bs=2048 count=$blocks status=progress
done
