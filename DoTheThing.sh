for STYLE_FILE in Style/*.png; do
	out_folder="Out/$(basename $STYLE_FILE .png)";
	mkdir -p "$out_folder";
	for INPUT_FILE in Content/*.jpg; do
		echo $out_folder;
	    curl `curl -F "content=@${INPUT_FILE}" -F "style=@${STYLE_FILE}" -H 'api-key:<<KEY>>' https://api.deepai.org/api/fast-style-transfer | jq -j '.output_url'` -o "$out_folder/$(basename -- $INPUT_FILE)"
	done
done
