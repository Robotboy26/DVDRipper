# makemkvcon info ./rom1 -r > read1.txt

#makemkvcon info ./rom1 -r

list=(1)

echo $list

content=""
# todo make multithreaded
for index in "${!list[@]}"; do
	makemkvcon info ./rom${list[index]} -r > read${list[index]}.txt

	while IFS= read -r line; do
	    if [[ $line == *"CINFO:2,0,"* ]]; then
	      # Extracting the content inside the double quotes
	      content=$(echo "$line" | grep -o "\"[^\"]*\"" | sed 's/"//g')
	      echo "$content is now being ripped"
	      break
	    fi
	  done < "read${list[index]}.txt"

	mkdir "$content"
	cp read${list[index]}.txt "$content/$content.info.log"
	rm read${list[index]}.txt
	makemkvcon mkv ./rom${list[index]} 1 "./$content" > "$content/$content.rip.log"
done

#makemkvcon mkv disc:0 all ./test
