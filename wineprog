#!/bin/sh

help () {
echo "USAGE: wineprog [PROGRAM]

PROGRAMS are:
	"Steam"		Valve game distribution
		"Steam-tf2"	Team Fortress 2
		"Steam-hl2"	Half-life 2
		"Steam-portal"	Portal
		"Steam-hl2e1"	Half-life 2 Episode 1
		"Steam-hl2e2"	Half-life 2 Episode 2
	"tf2b"		Team Fortress 2 beta"
}

steam="/home/shua/.wine/drive_c/Program Files (x86)/Steam/Steam.exe"
steamo="-novid -window -w 1280 -h 1024 -console -silent -noforcemaccel -noforcemparms -nojoy"

case "$1" in
	Steam-hl2)
		wine "$steam" -applaunch 220 $steamo
		break
		;;
	Steam-hl2e1)
		wine "$steam"  -applaunch 380 $steamo
		break
		;;
	Steam-hl2e2)
		wine "$steam"  -applaunch 420 $steamo
		break
		;;
	Steam-tf2)
		wine "$steam"  -applaunch 440 $steamo
		break
		;;
	Steam-portal)
		wine "$steam"  -applaunch 400 $steamo
		break
		;;
	Steam)
		wine "$steam"
		break
		;;
	tf2b)
		wine /home/shua/.wine/drive_c/Program\ Files\ \(x86\)/Team\ Fortress\ 2/RUN_TF2.exe
		break
		;;
	*)
		help
		;;
esac
