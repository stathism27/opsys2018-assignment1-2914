#!/bin/bash
#IFS=$'\n' read -d '' -r -a array < /home/stathis/log.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
	if  [ "${line:0:1}"  !=  "#" ] ;then
    		content=$(curl -L -s $line)
		md=$(echo $content|md5sum)
		if [ -z "$content" ]; then
			echo "$line FAILED"
		else

			
			line_name=${line//"/"/"_"}
			#echo $line_name
	
			if [ ! -f "$line_name.txt" ];then
				echo "$line INIT"
				echo $md >> "$line_name.txt"
			else
				echo $md >> "$line_name_temp.txt"
				file="$line_name.txt"
				file_temp="$line_name_temp.txt"
				if cmp -s "$file" "$file_temp"; then
					rm "$line_name_temp.txt"
				else
					echo "$line"
					> "$line_name.txt"
					echo $md >> "$line_name.txt"
					rm "$line_name_temp.txt"
			fi
			fi
			
			#if [[  "$temp" != "$md" ]]; then
			#	echo "$line"
		#		> "$line.txt"
		#		echo $md >> "$line.txt"
	#		fi
		fi

		
		
		#echo -n $content | md5sum >> "$line.txt"
		
		echo $line >> log.txt
		#$content | md5sum >> log.txt
		#echo -n $content | md5sum >> log.txt
	fi
done < "$1"
