MUM_PORD="production.db.endpoitn"
UK_PROD="production2.db.endpoint"
PP="preprod.db.endpoint"
PORT=5432
DB=sessions

function createDataPropsFile(){
cat << EOF > data.props
userid=$1
resource=$2
secKey= $3
EOF
echo "data.props file is successfully created"
cat data.props
}

function getSecretKey(){
    echo -n "Please Enter USER_ID: "; read USER_ID
    echo -n "Please Enter RESOURCE_JID: "; read RESOURCE_JID
    echo -n "Please Enter DB_PASSWORD: "; read DB_PASSWORD
    RESOURCE_JID_DB=\'${RESOURCE_JID}\'
    PGPASSWORD=$DB_PASSWORD psql -U $1 -h $2 -p $PORT -d $DB -t -A -F',' -c "select  secret_key from resource_data  where user_id=$USER_ID AND resource=$RESOURCE_JID_DB ;" > script.data
    SECRET_KEY=$(cat script.data)
    createDataPropsFile $USER_ID $RESOURCE_JID $SECRET_KEY
}

function generateToken(){
    #uncomment below command and change port to 8111
    #java -jar $HOME/GenerateAuthToken.jar $1 data.props http://service:81111/
    pwd 
    cat keys_${1}
    echo "Token is created Successfully"
}

echo "##### PLEASE SELECT CHOICE BY ENTER CHOICE NUMBER (EX:3 for prepord) #####"

select CHOICE in UK_PROD MUM_PROD PP QUIT
do
    case $CHOICE in 

        UK_PROD)
            echo "Execution Start for ENV: $CHOICE"
            DB_USER="sessions"
            TOKEN_ENV=lon1
            getSecretKey $DB_USER $UK_PROD
            generateToken $TOKEN_ENV
            echo "Execution finished for ENV: $CHOICE"
            ;;
        MUM_PROD)
            echo "Execution Start for ENV: $CHOICE"
            DB_USER="sessions"
            TOKEN_ENV=prod
            getSecretKey $DB_USER $MUM_PORD
            generateToken $TOKEN_ENV
            echo "Execution finished for ENV: $CHOICE"
            ;;
            
        PP)
            echo "Execution Start for ENV: $CHOICE"
            DB_USER="read_jenkins_user_for_session"
            TOKEN_ENV=preprod
            getSecretKey $DB_USER $PP
            generateToken $TOKEN_ENV
            echo "Execution finished for ENV: $CHOICE"
            ;;
        *)
            echo "QUIT or ANYTHING WHICH IS NOT EXPECTED AS CHOICE"
            break
            ;;
    esac  
done