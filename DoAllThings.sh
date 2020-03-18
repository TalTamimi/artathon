#! /usr/bin/bash

for M_FOLDER in M*/; 
do
    #! /usr/bin/bash
    images=("$M_FOLDER*.jpg")
    max=${#images[*]}

    target_folder=("${M_FOLDER}Continues")
    mkdir $target_folder

    j=1
    for i in $images; do 
	    target_file=("./${target_folder}/$(printf "%04d.jpg" $j)")
        echo $target_file
	    cp $i "./$target_folder/$(printf "%04d.jpg" $j)";
	    j=$((j+1))
    done

    for i in $(ls -1 $images | sort -r); do 
	    target_file=("./$target_folder/$(printf "%04d.jpg" $j)")
        echo $target_file
        cp $i "./$target_folder/$(printf "%04d.jpg" $j)";
	    j=$((j+1))
    done

    for INPUT_FILE in $(ls -1 ./${target_folder}/*.jpg)
    do
        echo $INPUT_FILE
	    convert -crop 904x462 $INPUT_FILE $INPUT_FILE
        mv ${INPUT_FILE::(-4)}-0.jpg $INPUT_FILE
        rm ${INPUT_FILE::(-4)}-1.jpg
    done
    
    flipped_target_folder=("${M_FOLDER}Flipped")
    mkdir $flipped_target_folder
    concat_target_folder=("${M_FOLDER}Concat")
    mkdir $concat_target_folder

    for INPUT_FILE in $(ls -1 ./${target_folder}/*.jpg)
    do
        flipped_target_file=("./$flipped_target_folder/$(basename -- ${INPUT_FILE})")
        concat_target_file=("./$concat_target_folder/$(basename -- ${INPUT_FILE})")
        echo $INPUT_FILE
        echo $flipped_target_file
        echo $concat_target_file
	    convert -flip $INPUT_FILE $flipped_target_file
	    convert -append $INPUT_FILE "$flipped_target_file" "$concat_target_file"
        mogrify -adaptive-resize 2160x3840! "$concat_target_file"
    done

    # input_pattern=("./$concat_target_folder/%04d.jpg")
    # echo $input_pattern
    # final_output=("./${M_FOLDER}FinalOutput.mp4")
    # echo $final_output
    # ffmpeg -y -i $input_pattern -c:v libx264 -vf fps=25 -pix_fmt yuv420p $final_output

    rm -rf $flipped_target_folder
    # rm -rf $concat_target_folder
    rm -rf $target_folder
done

k=1
final_distination="./FinalDistination"
mkdir $final_distination
echo $final_distination

for M_FOLDER in M*/; 
do
    concat_target_folder=("${M_FOLDER}Concat")
    echo $concat_target_folder

    for INPUT_FILE in $(ls -1 ./${concat_target_folder}/*.jpg)
    do
        cp $INPUT_FILE "./$final_distination/$(printf "%08d.jpg" $k)";
        k=$((k+1))
    done

    rm -rfv $concat_target_folder
done

input_pattern=("$final_distination/%08d.jpg")
echo $input_pattern
final_output=("./FinalOutput.mp4")
echo $final_output
ffmpeg -y -i $input_pattern -c:v libx264 -vf fps=25 -pix_fmt yuv420p $final_output
