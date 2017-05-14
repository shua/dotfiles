## script to rotate touch screens
## will include support for rotating specific monitors

###############################################
#                         #
#    Touch_rotate for Asus T101mt         #
#             written by Mark Lee             #
#                         #
###############################################

function main () {  ## main insertion function
args=("$@");  ## store the arguments in an array
check-arg;  ## read and check the arguments
resolve-rotate;  ## resolve the rotation
rotate-screen;  ## rotate the screen
}

function help-man () {  ## print the help manual
echo "
 where options are:
  [usage]: touch_rotate [options]
  
  -r or -rotate             | rotate the screen; ex. -r right
                            |   <left,right,normal,upside-down>
  -c or -counter-clockwise  | rotate the screen counter clockwise
  -m or -monitor            | set the monitor to rotate; ex. -m native
                            |  <primary,external>
  -i or -id                 | set the id of the touch screen device
  --help                    | print this help screen

  Examples:
     touch_rotate -m native -r right

  Press "Ctrl-C" to exit any time
"
}

function check-arg () {  ## read and check console arguments
for ((i = 0; i <= ${#args}; i++)); do  ## loop for all arguments passed
  case ${args[$i]} in  ## parse each argument
    -c|-C|-counter-clockwise)
       counter="yes";  ## toggle to rotate counter clockwise
       ;;       
    -r|-R|-rotate|-Rotate)
       rot="${args[$[i + 1]]}";  ## set the new rotation
       ;;
    -m|-M|-monitor|-Monitor)
      mon="${args[$[i + 1]]}";  ## set the monitor to control
      ;;
    -i|-I|-id)
      id="${args[$[i + 1]]}";  ## set the id of the device
      ;;
    -help|--help|/?)  ## help menu
      help-man;  ## print the help menu
      exit;  ## exit the script
      ;;
    -*)  ## for all other options
      echo "Unrecognized option: ${args[$i]}"
      help-man;  ## print the help menu
      ;;
  esac;
done;
if [ -z "$mon" ]; then  ## check if monitor was specified
   mon="primary";  ## set the monitor to be the primary monitor
fi;
if [ "$mon" == "primary" ]; then
   mon="$(xrandr | awk '$2~/^connected/ {print $1}')";  ## set the monitor to be the connected monitor
fi;
if [ "$counter" == "yes" ]; then  ## if user wants to rotate counter clockwise
   rot=$(xrandr -q --verbose | awk "/$mon/ {print \$5}");  ## capture the current rotation
   resolve-rotate;  ## convert the current rotation to an integer
   rot=$[$[int_rot + 1] % 4];  ## increment the rotation by one and divide by four
fi;
if [ -z "$rot" ]; then  ## check if a rotation was specified
   echo "Which orientation do you want your display to be?";
   select rot in normal left upside-down right; do  ## print menu of possible rotations
      break;  ## break the loop
   done;
fi;
if [ -z "$id" ]; then  ## if the id of the device is not specified
   id=$(xinput -list | awk '/MultiTouch/ {print $6}' | awk -F'=' '{print $2}');  ## get the id of the touch screen
fi;
}

function resolve-rotate () {  ## resolve the touch screen matrix
case $rot in
  normal|0)
    int_rot=0;
    rot_mat="1 0 0 0 1 0"
    ;;
  left|1)
    int_rot=1;
    rot_mat="0 -1 1 1 0 0"
    ;;
  inverted|upside-down|2)
    int_rot=2;
    rot_mat="-1 0 1 0 -1 1"
    ;;
  right|3)
    int_rot=3;
    rot_mat="0 1 0 -1 0 1"
    ;;
esac;
}


## touch cursor jumps around when in any other orientation than normal
function rotate-screen () {  ## rotate the touch screen
xrandr -o $int_rot;  ## rotate the display screen
xinput set-float-prop $id "Coordinate Transformation Matrix" $rot_mat 0 0 1;  ## rotate the touch screen
}

main $@;  ## call the main function and pass console arguments
