#!/bin/bash


tar_file=$1
name=${tar_file//".tar.gz"/}
index=0
num=1
zero=0
#tar --list --file=$tar_file
#list=$(tar --list --file=$tar_file)
list=$(tar zxvf $tar_file --one-top-level)

if [ -d "assignments" ]; then
  rm -rf assignments
fi
mkdir assignments




for i in $list;do
	
	if [[ $i == *".txt"* ]]; then
		#tar -xvf $tar_file $i -C extracted.dir
		content=$(cat $name/$i)
		
	IFS=$'\n'
	for j in $content;do
		temp=$j
		if  [ "${temp:0:1}"  !=  "#" ] ;then
			if [ "${temp:0:5}"  ==  "https" ] ;then
				index=$((index + num))
				content=$j
				#echo $content
				git clone $content "assignments/repo$index" &>/dev/null
				status=$?
				if [ "$status" -eq "$zero" ];then
					echo "$content : Cloning OK"
				else
					echo "$content : Cloning FAILED"
				fi
				
				
				
				break
			fi
		fi
	done
	
		
	fi
done



for entry in "assignments"/*;do
	name=${entry//"assignments/"/}
	echo "$name :"
	directory=$"./$entry/"
	dirsno=$(find  $directory -type d | wc -l)
	echo "Number of directories : $dirsno"

	txtno=$(find $directory -name "*.txt" | wc -l)
	echo "Number of txt files : $txtno"

	otherno=$(find $directory -type f | wc -l)
	echo $otherno
	otherno=$((otherno - txtno))
	echo "Number of other files :$otherno"

	s_to_check="$entry: dataA.txt more $entry/more: dataB.txt dataC.txt"
	string=$(ls -R $entry)
	string_temp=$(echo $string)
	if [ "$string_temp" = "$s_to_check" ]; then
  		status="OK"
	else
		status="NOT OK"
	fi
	echo "Data structure is $status"
done
