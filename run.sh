#!/usr/bin/env bash
G=${GODOT:-godot4}
N=${1:-20}; shift
ok=0 segv=0 abrt=0 hang=0 other=0
for i in $(seq "$N"); do
	{ timeout 20 "$G" --headless --script race.gd -- "$@" >/dev/null 2>&1; } 2>/dev/null
	case $? in
	0) ok=$((ok+1)) ;; 139) segv=$((segv+1)) ;; 134) abrt=$((abrt+1)) ;; 124) hang=$((hang+1)) ;; *) other=$((other+1)) ;;
	esac
done
echo "args=[$*] runs=$N ok=$ok sigsegv=$segv sigabrt=$abrt hang=$hang other=$other"
