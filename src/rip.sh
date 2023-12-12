# makemkvcon info ./rom1 -r > read1.txt

#makemkvcon info ./rom1 -r

list=(0)

for index in "${!list[@]}"; do
    dvdbackup -i /dev/sr${list[index]} -I -v > read${list[index]}.txt

	while IFS= read -r line; do
	    if [[ line=$(grep "$search" "$file" | sed -n 's/.*\(".*"\).*/\1/p') ]]; then
	      # Extracting the content inside the double quotes
	      content=$(echo "$line" | awk -F'"' '{print $2}')
	      echo "$content is now being ripped"
	      break
	    fi
	  done < "read${list[index]}.txt"

	mkdir "$content"
 	mkdir "$content/iso"
	cp read${list[index]}.txt "$content/$content.info.log"
	rm read${list[index]}.txt
  dvdbackup -i /dev/sr${list[index]} -o "$content" -F -p
  # Convert the ripped track to MKV using ffmpeg
  input_vob="$(ls -1 "$content" | grep "vob$")"
  output_file="$content/$content.mkv"
  ffmpeg -i "$content/$input_vob" -c:v copy -c:a copy -map 0 "$output_file"
 	blocks=$(isosize -d 2048 /dev/sr0)
  	touch "$content/iso/$content.iso"
 	sudo dd if=/dev/sr${list[index]} "of=$content/iso/$content.iso" bs=2048 count=$blocks status=progress
done

#makemkvcon mkv disc:0 all ./test
