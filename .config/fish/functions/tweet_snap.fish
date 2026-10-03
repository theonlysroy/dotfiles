function tweet_snap --description 'Prepare an ultra-wide terminal screenshot for Twitter with a perfect 16:9 safe frame'
    if test (count $argv) -lt 1
        echo "Error: Please provide an input image."
        echo "Usage: tweet_snap input.png [output.png]"
        return 1
    end

    set input_file $argv[1]
    set output_file $argv[2]
    if test -z "$output_file"
        set output_file (string replace -r '\.png$' '_twitter.png' $input_file)
    end

    # 1. First, cleanly remove transparency and upscale the terminal text by 400%
    # 2. Add a generous internal border so the terminal text isn't hugging the edge
    # 3. Use -extent to force a perfect 16:9 aspect ratio centered on a white canvas frame
    magick $input_file \
      -background "#1a1b26" -alpha remove \
      -scale 400% \
      -bordercolor "#ffffff" -border 60 \
      -background "#ffffff" -gravity center -extent 16:9 \
      png24:$output_file

    echo "Saved crop-proof Twitter image to: $output_file"
end
