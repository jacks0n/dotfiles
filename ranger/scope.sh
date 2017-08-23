#!/usr/bin/env bash

# Meanings of exit codes:
# code | meaning    | action of ranger
# -----+------------+-------------------------------------------
# 0    | success    | success. display stdout as preview
# 1    | no preview | failure. display no preview at all
# 2    | plain text | display the plain content of the file
# 3    | fix width  | success. Don't reload when width changes
# 4    | fix height | success. Don't reload when height changes
# 5    | fix both   | success. Don't ever reload
# 6    | image      | success. display the image $cached points to as an image preview
# 7    | image      | success. display the file directly as an image

# Meaningful aliases for arguments.
path="$1"            # Full path of the selected file.
width="$2"           # Width of the preview pane (number of fitting characters).
height="$3"          # Height of the preview pane (number of fitting characters).
cached="$4"          # Path that should be used to cache image previews.
preview_images="$5"  # "True" if image previews are enabled, "False" otherwise.

maxln=200    # Stop after $maxln lines.  Can be used like ls | head -n $maxln

# Find out something about the file.
mimetype=$(file --mime-type -Lb "$path")
extension=$(/bin/echo "${path##*.}" | awk '{print tolower($0)}')

# Functions:
# runs a command and saves its output into $output.  Useful if you need
# the return value AND want to use the output in a pipe
try() { output=$(eval '"$@"'); }

# Writes the output of the previously used "try" command.
dump() { /bin/echo "$output"; }

# A common post-processing function used after most commands.
trim() { head -n "$maxln"; }

# Wraps highlight to treat exit code 141 (killed by SIGPIPE) as success.
safepipe() { "$@"; test $? = 0 -o $? = 141; }

# Image previews, if enabled in ranger.
if [ "$preview_images" = "True" ]; then
    case "$mimetype" in
        # Image previews for SVG files, disabled by default.
        ###image/svg+xml)
        ###   convert "$path" "$cached" && exit 6 || exit 1;;
        # Image previews for image files. w3mimgdisplay will be called for all
        # image files (unless overriden as above), but might fail for
        # unsupported types.
        image/*)
            exit 7;;
        # Image preview for video, disabled by default.:
        ###video/*)
        ###    ffmpegthumbnailer -i "$path" -o "$cached" -s 0 && exit 6 || exit 1;;
    esac
fi

case "$extension" in
    # Archive extensions
    a|ace|alz|arc|arj|bz|bz2|cab|cpio|deb|gz|jar|lha|lz|lzh|lzma|lzo|\
    rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z|zip)
        try als "$path" && { dump | trim; exit 0; }
        try acat "$path" && { dump | trim; exit 3; }
        try bsdtar -lf "$path" && { dump | trim; exit 0; }
        exit 1;;
    rar)
        # Avoid password prompt by providing empty password.
        try unrar -p- lt "$path" && { dump | trim; exit 0; } || exit 1;;
    7z)
        # Avoid password prompt by providing empty password.
        try 7z -p l "$path" && { dump | trim; exit 0; } || exit 1;;
    # PDF documents
    pdf)
        try pdftoppm -jpeg -singlefile "$path" "${cached//.jpg}" && exit 6
        # try pdftotext -l 10 -nopgbrk -q "$path" - && \
        #     { dump | trim | fmt -s -w $width; exit 0; } || exit 1;;
        ;;
    # BitTorrent Files
    torrent)
        try transmission-show "$path" && { dump | trim; exit 5; } || exit 1;;
    # ODT Files
    odt|ods|odp|sxw)
        try odt2txt "$path" && { dump | trim; exit 5; } || exit 1;;
    # HTML Pages
    htm|html|xhtml)
        try w3m    -dump "$path" && { dump | trim | fmt -s -w $width; exit 4; }
        try lynx   -dump "$path" && { dump | trim | fmt -s -w $width; exit 4; }
        try elinks -dump "$path" && { dump | trim | fmt -s -w $width; exit 4; }
        ;;
esac

case "$mimetype" in
    # Syntax highlight for text files:
    text/* | */xml)
        if [ "$(tput colors)" -ge 256 ]; then
            pygmentize_format=terminal256
            highlight_format=xterm256
        else
            pygmentize_format=terminal
            highlight_format=ansi
        fi
        # Pygmentize themes:
        # - native
        # - monokai
        try pygmentize -O style=native -f ${pygmentize_format} "$path" && { dump | trim; exit 5; }
        try safepipe highlight --out-format=${highlight_format} "$path" && { dump | trim; exit 5; }
        ;;
    image/*)
        img2txt --gamma=0.6 --width="$width" "$path" && exit 4 || exit 1;;
    # Display information about media files:
    video/* | audio/*)
        exiftool "$path" && exit 5
        # Use sed to remove spaces so the output fits into the narrow window.
        try mediainfo "$path" && { dump | trim | sed 's/  \+:/: /;';  exit 5; } || exit 1;;
esac

exit 1