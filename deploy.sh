set +e
set +x
set +v

ARGS="${@:1}"

if [ ${#ARGS[@]} == 0 ]
then
    echo "Please, pass the arguments to the deploy script"
    exit 1
fi

if [ ${ARGS[0]} == "up" ]
then
    docker build . -t expenses-ui
fi

docker-compose -p expenses-ui -f ui.yaml $ARGS
