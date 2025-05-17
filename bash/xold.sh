################################################################################
#                                                                              #
#       xold:      makes backup file with new lfdnr                            #
#                                                                              #
#       xold [<options>] <filename>*                                           #
#       x<dir>old [<options>] <filename>*     (*1)                             #
#                                                                              #
#       <options>::=                                                           #
#                    -n <nr>       explicite seq. number                       #
#                    -d <dir>      destination subdirectory at $HOME           #
#                    -D <dir>      explicite destination subdirectory          #
#                    -l            return name only                            #
#                                                                              #
#       Notes:  (*1) script linked to "xold", default destination directory    #
#                    is "$HOME/<dir>old".                                      #
#                                                                              #
#       created:     05.02.93 J.Schulze                                        #
#       update:      19.03.93 js: keep last modification time                  #
#                    07.01.94 js: option -l                                    #
#                    13.01.94 js: error option -l at directories               #
#                    14.02.94 js: directory path at <filename>                 #
#                    16.02.94 js: error at option -n                           #
#                    05.01.95 js: time optimization                            #
#                    10.02.98 js: bug fixed at path                            #
#                                                                              #
#------------------------------------------------------------------------------#
#                                                                              #
#       SCCS-Information:                                                      #
#                                                                              #
#       @(#)module name:       %M%
#       @(#)SID:               %I%
#       @(#)last modification: %G% %U%
#       @(#)last get:          %H% %T%
#                                                                              #
################################################################################

PROG=$0
PROGNAME=`basename $0`
GENDIR=/home/opal/ent/bin
TMPDIR=$HOME/tmpdir

ERR=0

FLIST=
FLIST2=

NO=0
EXPLDIR=0
LIST=0
DIR=.

if [ $# -eq 0 -o ${1:-""} = "?" -o ${1:-""} = "-?" ]
then
    ERR=1
fi

if [ $ERR -eq 0 ]
then
    while [ $# -gt 0 ]
    do
	case $1 in
	-d)
	    EXPLDIR=1
	    shift
	    DIR=$HOME/$1
	    shift
	    ;;
	-D)
	    EXPLDIR=1
	    shift
	    DIR=$1
	    shift
	    ;;
	-n)
	    NO=1
	    shift
	    LFDNO=$1
	    shift
	    ;;
	-l)
	    LIST=1
	    shift
	    ;;
	-*)
	    ERR=1
	    shift
	    ;;
	*)
	    FLIST=${FLIST}${FLIST:+" "}$1
	    shift
	    ;;
	esac
    done
fi

if [ $ERR -ne 0 ]
then
    echo "Usage: $PROGNAME [<options>] <filename>" >&2
    echo "       <options>::=" >&2
    echo "           -n <nr>       explicite seq. number" >&2
    echo "           -d <dir>      destination subdirectory at $HOME" >&2
    echo "           -D <dir>      explicite destination subdirectory" >&2
    echo "           -l            list new name only" >&2
    exit 1
fi

if [ $EXPLDIR -eq 0 -a $PROGNAME != "xold" ]
then
### script linked to x<dir>old !! ###
    DIR=$HOME/`echo $PROGNAME | sed -e "s/^x//" -e "s/old$//"`"old"
fi

if [ ! -d $DIR ]
then
    mkdir $DIR
fi

PNAME=`echo ${PROGNAME}|awk '{str=$0; if (length(str)>6) str=substr(str,1,6); print str;}'`
TMPNAM=${PNAME}_$$_
TMPFILE=$TMPDIR/$TMPNAM
if [ ! -d $TMPDIR ]
then
    mkdir $TMPDIR
elif [ ${DEBUGGING} ]
then
    rm -f $TMPDIR/${PNAME}_*
else
    (cd $TMPDIR; rm -f `find . -atime +1 -name "${PNAME}_*" -print` 2>/dev/null)
fi

if [ $NO -ne 0 ]
then
    SEQNO=$LFDNO
else
    SEQNO=0
    if [ `echo $FLIST | wc -w` -gt 1 -a `cd $DIR; pwd` = `pwd` ]
    then
	for FIL in $FLIST
	do
	    if ( echo $FIL | grep "[0-9][0-9]$" )
	    then
		true
	    else
		FLIST2=$FLIST2${FLIST2:+" "}$FIL
	    fi
	done
	FLIST=$FLIST2
    fi
    ### search greatest SEQNO ###
    for FIL in $FLIST
    do
        FLEN=`echo \`basename $FIL\` | wc -c | sed -e "s/ //g"`
	if [ $EXPLDIR -eq 0 ]
	then
	    NEWDIR=`dirname $FIL`
	else
	    NEWDIR=$DIR
	fi
	for i in `\
	    cd $NEWDIR; \
	    ls -d \`basename $FIL\`[0-9][0-9] 2>/dev/null | tail -1; \
	    ls -d \`basename $FIL\`[0-9][0-9][0-9] 2>/dev/null | tail -1; \
	    ` 
	do
	    NNN=`echo $i $FLEN | awk '{str=substr($1,$2); print str}'`
	    if [ $NNN -ge $SEQNO ]
	    then
		SEQNO=`expr $NNN + 1`
	    fi
	done
    done
fi

LEN=`expr \`echo $NNN | wc -c | sed -e "s/^ *//"\` - 1`
if [ $LEN -lt 2 ]
then
    LEN=2
fi

echo "{printf \"%0${LEN}d\",\$1}" >$TMPFILE

for FIL in $FLIST
do
    if [ $EXPLDIR -eq 0 ]
    then
	NEWDIR=`dirname $FIL`
    else
	NEWDIR=$DIR
    fi
    NEWFIL=$NEWDIR/`basename $FIL``echo $SEQNO | awk -f $TMPFILE`
    if [ -f $FIL ]
    then
	if [ $LIST -eq 0 ]
	then
	    echo cp $FIL $NEWFIL >&2
	    (cd `dirname $FIL`; ls -d `basename $FIL`| cpio -pdm $TMPDIR 2>/dev/null)
	    mv $TMPDIR/`basename $FIL` $NEWFIL 
	else
	    echo $NEWFIL
	fi
    elif [ -d $FIL ]
    then
	if [ $LIST -eq 0 ]
	then
	    echo "*** ERROR: $PROGNAME does not work with directories ***" >&2
	else
	    echo $NEWFIL
	fi
    else
	ls -d $FIL		# errormessage only
    fi
done

rm -f $TMPFILE*

exit $ERR

