
getaudio() {
    for file in $@
    do
        extension=$(echo $file | sed 's/.*\.//')
        name=${file%.$extension}
        ffmpeg -i $file "$name.flac"
    done
}

