# makemkvcon info ./rom1 -r > read1.txt

#makemkvcon info ./rom1 -r

list=(1)

for index in "${!list[@]}"; do
    makemkvcon info /dev/sr${list[index]} -r > read${list[index]}.txt

	while IFS= read -r line; do
	    if [[ $line == *"CINFO:2,0,"* ]]; then
	      # Extracting the content inside the double quotes
	      content=$(echo "$line" | grep -o "\"[^\"]*\"" | sed 's/"//g')
	      echo "$content is now being ripped"
	      break
	    fi
	  done < "read${list[index]}.txt"

	mkdir "$content"
 	mkdir "$content/iso"
	cp read${list[index]}.txt "$content/$content.info.log"
	rm read${list[index]}.txt
	makemkvcon mkv /dev/sr${list[index]} 0 "./$content" > "$content/$content.rip.log"
 	blocks=$(isosize -d 2048 /dev/sr0)
  	touch "$content/iso/$content.iso"
 	sudo dd if=/dev/sr${list[index]} "of=$content/iso/$content.iso" bs=2048 count=$blocks status=progress
done

#makemkvcon mkv disc:0 all ./test
