#!/bin/sh
################################################################################
#                                                                              #
#       upload_rmdb_gesnrgen.sh:       sql loader script               	       #
#                                                                              #
#                                                                              #
#------------------------------------------------------------------------------#
#                                                                              #
#       created:     22.01.09 J. Schulze, CSC                                  #
#       update:      29.01.09 js: adapt general changes from upload_zceriskcost#
#                    03.02.09 js: auto mode for ORACLE SID                     #
#                    17.02.09 js: STP list                                     #
#                    04.12.09 js: archive in case of error also                #
#                    01.09.10 ah: User Passwort Zentral                        #
#                    		  Zentrale Logfunktionen       		               #
#                    DD.MM.YY js: remarks                                      #
#                                                                              #
#------------------------------------------------------------------------------#
#                                                                              #
#       SCCS-Information:                                                      #
#                                                                              #
#       @(#)module name:       %M%					                           #
#       @(#)SID:               %I%					                           #
#       @(#)last modification: %G% %U%					                       #
#       @(#)last get:          %H% %T%					                       #
#                                                                              #
#       CVS/Subversion-Information:                                            #
#                                                                              #
#       $Id$								                                   #
#                                                                              #
################################################################################

. ~/ini/imp_upl.env

### variables ###

AWK=`type gawk nawk awk 2>&1 | grep -v "not found" | head -1 | sed -e "s/.* //"` 

### global settings (need to be adapted)                                ###
### ATTENTION: settings my be overwritten by section "for test only"!!! ###

WORKDIR=`pwd`					# working directory
TMPDIR=${HOME:-/usr/RMS}/tmpdir			# directory for temporary files
DATADIR=${hpfad}				# input data directory
LOGDIR=${lpfad}					# logging directory
CTLDIR=${TMPDIR}				# sqlldr control directory
ARCHIVEDIR=${DATADIR}archiv			# archive directory

SQLLDR_DATAFILE=${DATADIR}/20101111_brf_GESNRGEN.csv		# data file

SQLEXE_STPNAME=HOST.fill_host_rmdb_dreba_gesnrgen 		# comma separated list of sql STP's to be
##unset SQLEXE_STPNAME                            # triggered after upload
						# no trigger when undefined

export DATAHEADERLINE=GESNRGEN;ProductID				# strip header line from data
						# no stripping when undefined

### oracle section ###

TABNAME=CB.HOST_RMDB_DREBA_GESNRGEN				# target DB table

export NLS_NUMERIC_CHARACTERS=',.'

### NOTE 1: setting ORACLE_SID to "AUTO" will force auto-detection by scanning the script name.
###         Script name must be of format "<scriptname>_<oraclesid>.sh" with
###         <scriptname> ::= name of script
###         <oraclesid>  ::= [A-Z][A-Z][0-9][0-9]
###         examples: upload_rezi_RE29.sh, upload_REZI_RT09.sh
###         Do a copy (or better a UNIX-link via the ln-command) of the
###         original script source to the various versions.

### general section ###

PNAME=`basename $0 | sed -e "s/\.sh$//"`	# program base name
DATESUFFIX=`date '+%Y%m%d'`			# date suffix at file names
DATE=`date '+%Y-%m-%d %H:%M:%S'`		# date for inline comments

### for test only ###
##export ORACLE_SID=RE09			# Datenbank
##DATADIR=/usr/RMS/transfer/fitramon		# input data directory
##SQLLDR_DATAFILE=${DATADIR}/rezi.txt		# data file
##TABNAME=CB.TMP_REZI_EXT			# target DB table
##SQLEXE_STPNAME=TMP_JS_TEST_REZI		# sql STP to be triggered after upload
##unset SQLEXE_STPNAME
### for test only ###

################################################################################

### settings built by values from previous section ###

if [ "$ORACLE_SID" = "AUTO" ]
then
    ### auto detect ORACLE_SID by script name ###
    ### script name must be of format:        ###
    ### xxxxx_RE29.sh with x::= any character ###
    unset ORACLE_SID
    if (echo "$PNAME" | grep "_[A-Z][A-Z]*[0-9][0-9]*$" >/dev/null)
    then
	ORACLE_SID=`echo $PNAME | sed -e "s/.*_//"`
	export ORACLE_SID
    fi
fi

DBUSRPWD=${ORA_USR}@${ORACLE_SID}		# DB user/pwd@sid

SQLLDR_CTLFILE=${CTLDIR}/${PNAME}.ctl		# sqlldr control file
SQLLDR_LOGFILE=${LOGDIR}/${PNAME}.log		# sqlldr logging file
SQLLDR_BADFILE=${LOGDIR}/${PNAME}.bad		# sqlldr bad file
SQLLDR_DSCFILE=${LOGDIR}/${PNAME}.dsc		# sqlldr discard file

LOGFILE=${LOGDIR}/${PNAME}_${DATESUFFIX}_$$.log	# local logging file
TMPFILE=${TMPDIR}/tmp_${PNAME}_$$    		# local temporary file prefix

### local variables ###

ERR=0						# error code, used at shell exit

### optional parameter input via command line options ###

DEBUG=0						# debug mode, may be set to 1

################################################################################

### scan for command line parameter ###

if [ "$1" = "?" -o "$1" = "-?" -o "$1" = "-help"  -o "$1" = "--help" ]
then
    ERR=100
fi

if [ $ERR -eq 0 ]
then
    while [ $# -gt 0 ]
    do
	case $1 in
	-D)
	    DEBUG=1
	    shift
	    ;;
	esac
    done
fi

if [ $ERR -eq 0 ]
then
    ### do some validation of parameter ###
    false
    ### do some validation of parameter ###
fi

################################################################################

### usage message ###

if [ $ERR -ne 0 ]
then
    cat `type $0 | cut -d' ' -f3` \
	| ${AWK} '
BEGIN		{ printf("\nUsage:"); }
/^#########/,/created:/	{
		if ($0 ~ "created:")
		    exit;
		line = $0;
		gsub("^##*","",line);
		gsub(" *#*$","",line);
		if ((lcnt==0)&&(line==""))
		    { lcnt++; next; }
		print line;
		next;
		}
	      '
    exit $ERR
fi

################################################################################

### some inits ###

if [ $ERR -eq 0 ]
then
    for DIR in $TMPDIR $LOGDIR $CTLDIR $ARCHIVEDIR
    do
	[ ! -d $DIR ] && mkdir -p $DIR
    done
    cp /dev/null $LOGFILE
fi

if [ ${DEBUG:-0} -ne 0 ]
then
    echo ">>>ORACLE_HOME=\"$ORACLE_HOME\"" >&2
    echo ">>>$ORACLE_SID=\"$ORACLE_SID\"" >&2
fi

### do some checkings ###

if [ $ERR -eq 0 ]
then
    if [ "$ORACLE_HOME" = "" ]
    then
	echo "*** ERROR: ORACLE_HOME is not set - aborting ***" | tee -a $LOGFILE >&2
	ERR=10
    elif [ ! -r ${SQLLDR_DATAFILE} ]
    then
	echo "*** ERROR: ${SQLLDR_DATAFILE} is not found - aborting ***" | tee -a $LOGFILE >&2
	ERR=11
    fi
fi

################################################################################

### main program ###

if [ ${DEBUG:-0} -ne 0 ]
then
    echo ">>>SQLLDR_DATAFILE=\"$SQLLDR_DATAFILE\", SQLLDR_CTLFILE=\"$SQLLDR_CTLFILE\"" >&2
fi

if [ $ERR -eq 0 ]
then

    for FIL in $SQLLDR_CTLFILE $SQLLDR_BADFILE $SQLLDR_DSCFILE 
    do
	[ -r $FIL ] && rm $FIL
    done

    if [ "$DATAHEADERLINE" != "" ]
    then
	cat ${SQLLDR_DATAFILE} \
	    | egrep -v "^($DATAHEADERLINE)" \
	    >$TMPFILE.in
    else
	cp ${SQLLDR_DATAFILE} $TMPFILE.in
    fi

    cat >$SQLLDR_CTLFILE <<XXX
-- control file generated by script $PNAME at $DATE (do not change) --
LOAD DATA
INFILE '$TMPFILE.in'
BADFILE '${SQLLDR_BADFILE}'
DISCARDFILE '${SQLLDR_DSCFILE}'
TRUNCATE
PRESERVE BLANKS
INTO TABLE ${TABNAME}
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(
	GESNRGEN,
	PRODUCTID
)
XXX
fi

if [ $ERR -eq 0 ]
then
    ### load data from file ###

    NRECORDS=`wc -l <$SQLLDR_DATAFILE | sed -e "s/^ *//"`
    echo "start of program ..." | tee -a $LOGFILE
    echo "HostToRMS" | tee -a $LOGFILE
    echo "logging at \"$LOGFILE\"" | tee -a $LOGFILE
    echo "sqlldr - control file \"${SQLLDR_CTLFILE}\"" >> $LOGFILE
    echo "sqlldr - logging file \"${SQLLDR_LOGFILE}\"" >> $LOGFILE
    echo "sqlldr - load data file \"$SQLLDR_DATAFILE\" ($NRECORDS records) to \"$TABNAME\" ..." | tee -a $LOGFILE
    $ORACLE_HOME/bin/sqlldr userid=$DBUSRPWD control=${SQLLDR_CTLFILE} log=${SQLLDR_LOGFILE} errors=1000000 silent=FEEDBACK

    RETVAL=$?
    if [ $RETVAL -ne 0 ]
    then
	echo "*** ERROR: sqlldr exit with error $RETVAL ***" | tee -a $LOGFILE >&2
	ERR=90
    elif [ -s ${SQLLDR_BADFILE} ]
    then
	NBADRECORDS=`wc -l SQLLDR_BADFILE | sed -e "s/^ *//"`
	echo "*** ERROR: sqlldr cannot upload ${NBADRECORDS:-0} records ***" | tee -a $LOGFILE >&2
	ERR=91
    fi

    ### execute STPs (if defined) ###

    if [ $ERR -eq 0 -a "$SQLEXE_STPNAME" != "" ]
    then
	for STPNAME in `echo $SQLEXE_STPNAME | sed -e "s/,/ /g"`
	do
	    echo "execute STP \"$STPNAME\" ..." | tee -a $LOGFILE
	    echo "execute ${STPNAME};\nquit;" \
		| $ORACLE_HOME/bin/sqlplus $DBUSRPWD 2>&1 \
		>$TMPFILE.1
	    RETVAL=$?
	    ### check for errors ###
	    if [ $RETVAL -ne 0 ]
	    then
		echo "*** ERROR: calling STP failed ***" | tee -a $LOGFILE >&2
		ERR=94
	    elif (cat $TMPFILE.1 | grep "^ORA-" >/dev/null)
	    then
		echo "*** ERROR: STP returns some errors (see logfile) ***" | tee -a $LOGFILE >&2
		ERR=95
	    fi
	    cat $TMPFILE.1 >>$LOGFILE
	    if [ $ERR -ne 0 ]
	    then
		break
	    fi
	done
    fi

    if (basename "$SQLLDR_DATAFILE" | grep "\." >/dev/null)
    then
	ARCHFIL=$ARCHIVEDIR/`basename "$SQLLDR_DATAFILE" | sed -e "s/\.[^\.]*$/_${DATESUFFIX:-$$}&/"`
    else
	ARCHFIL=$ARCHIVEDIR/`basename "$SQLLDR_DATAFILE"`_${DATESUFFIX:-$$}
    fi
    cp $SQLLDR_DATAFILE $ARCHFIL && \
	echo "data file stored at archive \"$ARCHFIL\"" >> $LOGFILE

    cat ${SQLLDR_LOGFILE} \
	| egrep "successfully loaded|not loaded due to data errors" \
	| sed -e "s/^ *//" \
	| grep -v "^0" \
	| tee -a $LOGFILE

    if [ $ERR -ne 0 ]
    then
	echo "\nready, exit with errors (errorcode=$ERR)" | tee -a $LOGFILE
    else
	echo "\nready" | tee -a $LOGFILE
    fi

    if [ ${DEBUG:-0} -eq 0 -a "$TMPFILE" != "" ]
    then
	rm -f $TMPFILE.*
    fi

fi

################################################################################

[ ${DEBUG:-0} -ne 0 ] && echo ">>>ERR=$ERR" >&2

exit $ERR

################################################################################
