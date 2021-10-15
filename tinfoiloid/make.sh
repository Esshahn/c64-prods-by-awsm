#! /bin/bash
# this script needs to have executable rights: sudo chmod 755 make.sh


# args
#
# -e or --emulator (optional)
# which emulator to start after compilation
# can be either none, "vice" or "64debugger"
# default: vice
#
# -f or --filename (optional)
# the filename of the generated executable
# default: main
#
# -c or --crunch (optional)
# user exomizer packer to reduce the file size
# no args
#
# -d64 (optional)
# if set, creates additional d64 disc file with the prg in it
# no args

# config
build_folder=build
os=mac # mac, linux, win
path_vice=/Applications/vice-gtk/bin
path_64debugger=/Applications/c64-debugger/C64Debugger.app/Contents/MacOS/c64debugger
path_acme=bin/$os/acme
path_exomizer=bin/$os/exomizer



while true ; do
    case "$1" in
        -e|--emulator )
            emulator=$2
            shift 2
        ;;
        -f|--filename )
            filename=$2
            shift 2
        ;;
        -c|--crunch )
            crunch=1
            shift 1
        ;;
        -d64 )
            d64=1
            shift 1
        ;;
        -t|-tools )
            tools=1
            shift 1
        ;;
        *)
            break
        ;;
    esac 
done;

# default filename is none is provided
[ ! $filename ] && filename="main"


# create build folder if it is missing
if [ ! -d $build_folder ]
then
    mkdir $build_folder
    echo "build folder does not exist, creating it.."
fi

# execute custom tool
if [ $tools ]
then
    echo rebuilding sprites from png image... 
    echo
    python3 tools/png2spd.py 'sources/sprites-001.png' 'gfx/sprites.spd'
fi


# compile the file
echo compiling as $filename...
$path_acme -f cbm -r $build_folder/report.asm -l $build_folder/labels -o $build_folder/$filename.prg code/main.asm
echo done.


# crunch with exomizer
if [ $crunch ]
then
    STARTADDR=$(grep 'main' $build_folder/labels | cut -d$ -f2 | cut -f1)
    echo crunching with exomizer
    echo start address $STARTADDR
    $path_exomizer sfx 0x$STARTADDR -n -t 64 -o $build_folder/$filename.prg $build_folder/$filename.prg 
fi

# put prg file into a d64 image
if [ $d64 ]
then
    echo creating d64 file
    $vicepath/c1541 -format $filename,1 d64 $build_folder/$filename.d64 -write $build_folder/$filename.prg $filename
fi

# execute vice emulator
if [ !$emulator ] || [ $emulator = "vice" ]
then
    echo launching VICE
    echo $path
    $path_vice/x64sc -moncommands $PWD/$build_folder/labels $PWD/$build_folder/$filename.prg 2> /dev/null
fi

# execute 64debugger emulator
if [ $emulator = "64debugger" ]
then
    echo launching 64debugger
    $path_64debugger -prg $build_folder/$filename.prg
fi

