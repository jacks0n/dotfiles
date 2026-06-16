#!/usr/bin/env bash
set -euo pipefail

# Video compression script — interactive two-pass conversion to H.265 or AV1
# Pass 1: Scan all videos, show info, ask what to do with each
# Pass 2: Convert everything based on your answers
#
# Usage: ./video-compress.sh <dir> [codec]
# codec: h265 (default) or av1

DIR="${1:?Usage: $0 <dir> [h265|av1]}"
CODEC="${2:-h265}"

CRF_H265=18
PRESET_H265="slower"
CRF_AV1=28
PRESET_AV1=4

# Codecs that macOS Finder/QuickLook can preview
QUICKLOOK_CODECS="h264 hevc prores mpeg4"
# Containers that macOS Finder/QuickLook can preview
QUICKLOOK_CONTAINERS="mov mp4 m4v"

lowercase() {
  printf '%s' "$1" | tr '[:upper:]' '[:lower:]'
}

file_size_bytes() {
  stat -f%z "$1" 2>/dev/null || stat -c%s "$1" 2>/dev/null
}

require_command() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "Missing required command: $1" >&2
    exit 1
  fi
}

cleanup_temp_dir=""
cleanup() {
  if [[ -n "${cleanup_temp_dir:-}" && -d "$cleanup_temp_dir" ]]; then
    rm -rf "$cleanup_temp_dir"
  fi
}

trap cleanup EXIT INT TERM

human_size() {
  local bytes=$1
  if command -v numfmt &>/dev/null; then
    numfmt --to=iec "$bytes"
  elif [[ $bytes -gt 1073741824 ]]; then
    echo "$(( bytes / 1073741824 ))G"
  elif [[ $bytes -gt 1048576 ]]; then
    echo "$(( bytes / 1048576 ))M"
  elif [[ $bytes -gt 1024 ]]; then
    echo "$(( bytes / 1024 ))K"
  else
    echo "${bytes}B"
  fi
}

is_quicklook_compatible() {
  local codec="$1" container="$2"
  [[ " $QUICKLOOK_CODECS " == *" $codec "* ]] && [[ " $QUICKLOOK_CONTAINERS " == *" $container "* ]]
}

codec_display_name() {
  case "$1" in
    h264)   echo "H.264" ;;
    hevc)   echo "H.265/HEVC" ;;
    vp9)    echo "VP9" ;;
    av1)    echo "AV1" ;;
    prores) echo "ProRes" ;;
    mpeg4)  echo "MPEG-4" ;;
    *)      echo "$1" ;;
  esac
}

target_codec_name() {
  case "$CODEC" in
    h265) echo "H.265/HEVC" ;;
    av1)  echo "AV1" ;;
  esac
}

is_already_target_codec() {
  local current="$1"
  if [[ "$CODEC" == "h265" && ("$current" == "hevc" || "$current" == "h265") ]]; then
    return 0
  fi
  if [[ "$CODEC" == "av1" && "$current" == "av1" ]]; then
    return 0
  fi
  return 1
}

case "$CODEC" in
  h265|av1)
    ;;
  *)
    echo "Invalid codec: $CODEC" >&2
    echo "Usage: $0 <dir> [h265|av1]" >&2
    exit 1
    ;;
esac

if [[ ! -d "$DIR" ]]; then
  echo "Directory not found: $DIR" >&2
  exit 1
fi

require_command ffmpeg
require_command ffprobe
require_command mktemp

echo "========================================="
echo "Video Compressor"
echo "Target: $(target_codec_name) in MP4 container"
echo "Scanning: $DIR"
echo "========================================="
echo ""

# Collect all video files
files=()
shopt -s nullglob nocaseglob
for f in "$DIR"/*.{mp4,mkv,avi,mov,wmv,flv,webm,m4v}; do
  [[ -f "$f" ]] && files+=("$f")
done

if [[ ${#files[@]} -eq 0 ]]; then
  echo "No video files found in $DIR"
  exit 0
fi

echo "Found ${#files[@]} video file(s). Scanning..."
echo ""

# Arrays to track decisions
declare -a convert_files=()
declare -a convert_codecs=()
skipped=0

for input_file in "${files[@]}"; do
  filename="$(basename "$input_file")"
  extension="${filename##*.}"
  container="$(lowercase "$extension")"

  video_codec=$(ffprobe -v error -select_streams v:0 \
    -show_entries stream=codec_name -of default=nw=1:nokey=1 "$input_file" 2>/dev/null || echo "unknown")
  audio_codec=$(ffprobe -v error -select_streams a:0 \
    -show_entries stream=codec_name -of default=nw=1:nokey=1 "$input_file" 2>/dev/null || echo "none")
  resolution=$(ffprobe -v error -select_streams v:0 \
    -show_entries stream=width,height -of csv=s=x:p=0 "$input_file" 2>/dev/null || echo "unknown")
  duration=$(ffprobe -v error -show_entries format=duration \
    -of default=nw=1:nokey=1 "$input_file" 2>/dev/null || echo "0")
  duration_fmt=$(printf "%02d:%02d" $(( ${duration%.*} / 60 )) $(( ${duration%.*} % 60 )) 2>/dev/null || echo "??:??")
  file_size=$(file_size_bytes "$input_file")

  quicklook="No"
  is_quicklook_compatible "$video_codec" "$container" && quicklook="Yes"

  # Already in target codec and in a QuickLook-friendly container?
  if is_already_target_codec "$video_codec"; then
    if [[ "$container" == "mp4" || "$container" == "m4v" || "$container" == "mov" ]]; then
      echo "✓ $filename"
      echo "  Already $(target_codec_name) in .$container — nothing to do"
      echo ""
      ((skipped++))
      continue
    else
      # Right codec but wrong container — just needs remuxing
      echo "~ $filename"
      echo "  Codec: $(codec_display_name "$video_codec") (already target)"
      echo "  Container: .$container → needs remux to .mp4 for QuickLook"
      echo "  Size: $(human_size "$file_size")  Duration: $duration_fmt  Resolution: $resolution"
      echo -n "  Remux to .mp4? [Y/n] "
      read -r answer </dev/tty
      answer="${answer:-y}"
      if [[ "$(lowercase "$answer")" == "y" ]]; then
        convert_files+=("$input_file")
        convert_codecs+=("remux")
      else
        ((skipped++))
      fi
      echo ""
      continue
    fi
  fi

  # Needs conversion
  echo "● $filename"
  echo "  Video codec:  $(codec_display_name "$video_codec")"
  echo "  Audio codec:  $audio_codec"
  echo "  Container:    .$container"
  echo "  Resolution:   $resolution"
  echo "  Duration:     $duration_fmt"
  echo "  Size:         $(human_size "$file_size")"
  echo "  Finder preview: $quicklook"
  echo "  ─────────────────────────────"
  echo "  Proposed: $(codec_display_name "$video_codec") → $(target_codec_name) in .mp4"
  echo -n "  Convert? [Y/n] "
  read -r answer </dev/tty
  answer="${answer:-y}"
  if [[ "$(lowercase "$answer")" == "y" ]]; then
    convert_files+=("$input_file")
    convert_codecs+=("encode")
  else
    ((skipped++))
  fi
  echo ""
done

# Summary before starting
total_to_convert=${#convert_files[@]}
if [[ $total_to_convert -eq 0 ]]; then
  echo "Nothing to convert. All done!"
  exit 0
fi

echo "========================================="
echo "Ready to process $total_to_convert file(s)"
echo "Skipped: $skipped"
echo "========================================="
echo -n "Start converting? [Y/n] "
read -r answer </dev/tty
answer="${answer:-y}"
if [[ "$(lowercase "$answer")" != "y" ]]; then
  echo "Aborted."
  exit 0
fi

echo ""

converted=0
failed=0
total_input_bytes=0
total_output_bytes=0

for i in "${!convert_files[@]}"; do
  input_file="${convert_files[$i]}"
  operation="${convert_codecs[$i]}"
  filename="$(basename "$input_file")"
  final_file="${input_file%.*}.mp4"
  file_size=$(file_size_bytes "$input_file")
  parent_dir="$(dirname "$input_file")"
  cleanup_temp_dir="$(mktemp -d "$parent_dir/.video-compress.XXXXXX")"
  tmp_file="$cleanup_temp_dir/$filename.mp4"

  echo "[$((i + 1))/$total_to_convert] $filename"

  if [[ "$operation" == "remux" ]]; then
    echo "  Remuxing to .mp4 (no re-encode)..."
    remux_args=(
      -hide_banner -loglevel warning -stats
      -i "$input_file"
      -c copy
      -movflags +faststart
    )
    if [[ "$CODEC" == "h265" ]]; then
      remux_args+=(-tag:v hvc1)
    fi

    if ffmpeg "${remux_args[@]}" "$tmp_file"; then
      mv -f "$tmp_file" "$final_file"
      rm -rf "$cleanup_temp_dir"
      cleanup_temp_dir=""
      echo "  Done (remuxed)"
      ((converted++))
    else
      echo "  FAILED — original kept"
      rm -rf "$cleanup_temp_dir"
      cleanup_temp_dir=""
      ((failed++))
    fi
    echo ""
    continue
  fi

  echo "  Encoding to $(target_codec_name)..."

  encode_ok=false
  if [[ "$CODEC" == "h265" ]]; then
    ffmpeg -hide_banner -loglevel warning -stats \
      -i "$input_file" \
      -c:v libx265 -crf "$CRF_H265" -preset "$PRESET_H265" \
      -c:a copy \
      -tag:v hvc1 \
      -movflags +faststart \
      "$tmp_file" && encode_ok=true
  else
    ffmpeg -hide_banner -loglevel warning -stats \
      -i "$input_file" \
      -c:v libsvtav1 -crf "$CRF_AV1" -preset "$PRESET_AV1" \
      -c:a copy \
      -movflags +faststart \
      "$tmp_file" && encode_ok=true
  fi

  if [[ "$encode_ok" == true && -f "$tmp_file" ]]; then
    output_size=$(file_size_bytes "$tmp_file")

    if [[ $output_size -lt 1000 ]]; then
      echo "  FAILED — output suspiciously small, original kept"
      rm -rf "$cleanup_temp_dir"
      cleanup_temp_dir=""
      ((failed++))
      echo ""
      continue
    fi

    if [[ $output_size -ge $file_size ]]; then
      echo "  Output is same size or larger — keeping original"
      rm -rf "$cleanup_temp_dir"
      cleanup_temp_dir=""
      ((skipped++))
      echo ""
      continue
    fi

    mv -f "$tmp_file" "$final_file"
    rm -rf "$cleanup_temp_dir"
    cleanup_temp_dir=""

    savings=$(( 100 - (output_size * 100 / file_size) ))
    echo "  $(human_size "$file_size") → $(human_size "$output_size") (${savings}% smaller)"
    ((converted++))
    total_input_bytes=$((total_input_bytes + file_size))
    total_output_bytes=$((total_output_bytes + output_size))
  else
    echo "  FAILED — original kept"
    rm -rf "$cleanup_temp_dir"
    cleanup_temp_dir=""
    ((failed++))
  fi
  echo ""
done

echo "========================================="
echo "Done!"
echo "  Converted: $converted"
echo "  Skipped:   $skipped"
echo "  Failed:    $failed"
if [[ $total_input_bytes -gt 0 ]]; then
  total_savings=$(( 100 - (total_output_bytes * 100 / total_input_bytes) ))
  echo "  Total before: $(human_size "$total_input_bytes")"
  echo "  Total after:  $(human_size "$total_output_bytes")"
  echo "  Saved: ${total_savings}%"
fi
echo "========================================="
