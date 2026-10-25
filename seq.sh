#!/usr/bin/env bash
# usage: seq.sh <script.gd> <runs> <seconds> <cpu> <outdir>
G=${GODOT:-godot4}
mkdir -p "$5"
for i in $(seq 1 "$2"); do
  s=$(date +%s%N)
  timeout "$3" taskset -c "$4" "$G" --headless --fixed-fps 100000 --path . --script "$1" > "$5/$i.log" 2>&1
  echo "$i exit=$? secs=$(( ($(date +%s%N) - s) / 1000000000 ))" >> "$5/summary.txt"
done
echo "runs: $2  crashed: $(grep -l 'handle_crash' "$5"/*.log | wc -l)" >> "$5/summary.txt"
