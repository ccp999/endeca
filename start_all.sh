TEMPDIR=/vagrant/tmp
ORACLE_HOME=/home/vagrant/Oracle/Middleware_Orch
ENDECA_STUDIO_DOMAIN_NAME=endeca_studio
ENDECA_SERVER_DOMAIN_NAME=endeca_server
ENDECA_PS_DOMAIN_NAME=endeca_provisioning
ENDECA_STUDIO_PORT=8101
ENDECA_SERVER_PORT=7001
ENDECA_PS_PORT=8201
ENDECA_IAS_PORT=8401
UNAME=weblogic
UPASS_FIRST=!2345678

startStudioWLS() 
{
	if [ -e $TEMPDIR/startStudioWLS.log ]; 
	then
		rm -f  $TEMPDIR/startStudioWLS.log &> /dev/null
	fi

	$ORACLE_HOME/user_projects/domains/$ENDECA_STUDIO_DOMAIN_NAME/bin/startWebLogic.sh &>  $TEMPDIR/startStudioWLS.log &
	START_STATUS=1
	START_TIMEOUT=300
	LOG_STATUS=1;
	while (( ("$START_STATUS" != 0 || "$LOG_STATUS" != 0) &&  "$START_TIMEOUT" > 0 ))
		do
			printf ".";
			sleep 5
			curl --proxy "" http://localhost:$ENDECA_STUDIO_PORT/console/login/LoginForm.jsp 2> /dev/null | grep "WebLogic Server Version: 10.3.6.0" 2>&1 > /dev/null
			START_STATUS=$?
			grep "Server started in RUNNING mode" $ORACLE_HOME/user_projects/domains/$ENDECA_STUDIO_DOMAIN_NAME/servers/AdminServer/logs/AdminServer.log 2>&1 > /dev/null
			LOG_STATUS=$?
			START_TIMEOUT=`expr $START_TIMEOUT - 5`;
		done
	if [ "$START_TIMEOUT" -lt 1 ];
	then
		echo TIMEOUT
	fi

	if [ "$LOG_STATUS" -ne 0 ]; then
		printf "Unable to start Endeca Provisoning Service weblogic server.\n"
		exit 1
	fi
	printf  "Studio done\n";

}

startServerWLS()
{
	START_TIMEOUT=300
	if [ -e $TEMPDIR/startServerWLS.log ];
	then
		rm -f  $TEMPDIR/startServerWLS.log &> /dev/null 
	fi

	$ORACLE_HOME/user_projects/domains/$ENDECA_SERVER_DOMAIN_NAME/bin/startWebLogic.sh &>  $TEMPDIR/startServerWLS.log &
	START_STATUS=1
	LOG_STATUS=1;

	while ( [ "$LOG_STATUS" != 0 ] && [ "$START_TIMEOUT" > 0 ] )
		do
			printf ".";
			sleep 5
			if [ "$START_STATUS" == 0 ]; 
			then
				break;
			fi
			$ORACLE_HOME/wlserver_10.3/common/bin/wlst.sh $WORKDIR/utils/status.py -u $UNAME --password $UPASS_FIRST -w $ENDECA_SERVER_PORT &> /dev/null 
			if [ "$?" == 0 ]; 
			then
				break;
			fi
			curl http://localhost:$ENDECA_SERVER_PORT/console/login/LoginForm.jsp 2> /dev/null | grep "WebLogic Server Version: 10.3.6.0" 2>&1 > /dev/null 
			START_STATUS=$?
			grep -e "Server started in RUNNING mode" -e "BEA-000360" $TEMPDIR/startServerWLS.log 2>&1 > /dev/null
			LOG_STATUS=$?
			START_TIMEOUT=`expr $START_TIMEOUT - 5`;
		done
	if [ "$START_TIMEOUT" -lt 1 ];
	then
		echo TIMEOUT
		exit 1
	fi

	printf  "Server done\n";
}

startPSWLS() 
{
	if [ -e $TEMPDIR/startPSWLS.log ]; 
	then
		rm -f  $TEMPDIR/startPSWLS.log &> /dev/null
	fi

	$ORACLE_HOME/user_projects/domains/$ENDECA_PS_DOMAIN_NAME/bin/startWebLogic.sh &>  $TEMPDIR/startPSWLS.log &
	START_STATUS=1
	START_TIMEOUT=300
	LOG_STATUS=1;

	while (( ("$START_STATUS" != 0 || "$LOG_STATUS" != 0) &&  "$START_TIMEOUT" > 0 ))
		do
			printf ".";
			sleep 5
			curl --proxy "" http://localhost:$ENDECA_PS_PORT/console/login/LoginForm.jsp 2> /dev/null | grep "WebLogic Server Version: 10.3.6.0" 2>&1 > /dev/null
			START_STATUS=$?
			grep "Server started in RUNNING mode" $ORACLE_HOME/user_projects/domains/$ENDECA_PS_DOMAIN_NAME/servers/AdminServer/logs/AdminServer.log 2>&1 > /dev/null
			LOG_STATUS=$?
			START_TIMEOUT=`expr $START_TIMEOUT - 5`;
		done
	if [ "$START_TIMEOUT" -lt 1 ];
	then
		echo TIMEOUT
	fi

	if [ "$LOG_STATUS" -ne 0 ]; then
		printf "Unable to start Endeca Provisoning Service weblogic server.\n"
		exit 1
	fi

	printf  "Provisoning Service done\n";
}

startIAS()
{
	if [ -e $TEMPDIR/startIAS.log ]; 
	then
		rm -f  $TEMPDIR/startIAS.log &> /dev/null
	fi

	/home/vagrant/Oracle/Endeca/IAS/3.1.0/bin/ias-service.sh &>  $TEMPDIR/startIAS.log &
	START_STATUS=1
	START_TIMEOUT=300
	LOG_STATUS=1;

	while (( ("$START_STATUS" != 0 || "$LOG_STATUS" != 0) &&  "$START_TIMEOUT" > 0 ))
		do
			printf ".";
			sleep 5
			curl --proxy "" http://localhost:$ENDECA_IAS_PORT/ias-server/ias/?wsdl 2> /dev/null | grep "IasCrawlerService" 2>&1 > /dev/null
			START_STATUS=$?
			grep "IAS started in RUNNING mode" $TEMPDIR/startIAS.log 2>&1 > /dev/null
			LOG_STATUS=$?
			START_TIMEOUT=`expr $START_TIMEOUT - 5`;
		done
	if [ "$START_TIMEOUT" -lt 1 ];
	then
		echo TIMEOUT
	fi

	if [ "$LOG_STATUS" -ne 0 ]; then
		printf "Unable to start Endeca IAS Service weblogic server.\n"
		exit 1
	fi

	printf  "IAS Service done\n";
}
printf "Starting All-in-one Endeca server."
startServerWLS;
startStudioWLS;
startPSWLS;
startIAS;
printf  "Successful!\n";
