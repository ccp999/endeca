TEMPDIR=/vagrant/tmp
ORACLE_HOME=/home/vagrant/Oracle/Middleware_Orch
ENDECA_STUDIO_DOMAIN_NAME=endeca_studio
ENDECA_SERVER_DOMAIN_NAME=endeca_server
ENDECA_PS_DOMAIN_NAME=endeca_provisioning
stopServerWLS()
{
	if [ -e $TEMPDIR/stopServerWLS.log ];
	then
		rm -f $TEMPDIR/stopServerWLS.log
	fi

	$ORACLE_HOME/user_projects/domains/$ENDECA_SERVER_DOMAIN_NAME/bin/stopWebLogic.sh &>  $TEMPDIR/stopServerWLS.log

	# Kill any remaining process abdruptly
	ps -ef|grep java | grep -v grep|grep Middleware | awk '{print $2}' | xargs kill -9 &> /dev/null
	ps -ef|grep dgraph | grep -v grep|grep Middleware | awk '{print $2}' | xargs kill -9 &> /dev/null
}

stopStudioWLS() 
{
	if [ -e $TEMPDIR/lstopStudioWLS.log ]; 
	then
		rm $TEMPDIR/stopStudioWLS.log
	fi

	$ORACLE_HOME/user_projects/domains/$ENDECA_STUDIO_DOMAIN_NAME/bin/stopWebLogic.sh &>  $TEMPDIR/stopStudioWLS.log
}

stopPSWLS() {
	if [ -e $TEMPDIR/stopPSWLS.log ]; then
		rm -f $TEMPDIR/stopPSWLS.log
	fi

	$ORACLE_HOME/user_projects/domains/$ENDECA_PS_DOMAIN_NAME/bin/stopWebLogic.sh &>  $TEMPDIR/stopPSWLS.log
}

printf "Stopping All-in-one Endeca server."
stopPSWLS;
stopStudioWLS;
stopServerWLS;
printf  "Successful.\n";
