#!/usr/bin/env sh

# Getting PHP INI Paths
PHPINI=`php -i | grep "Loaded Configuration File" | awk -F" => " '{print $2}'`
PHPMODULES=`php -i | grep "Scan this dir" |  awk -F" => " '{print $2}'`

# Setting if is verbose mode or not
VERBOSE_MODE=false
if [ "$VERBOSE" == "true" ]
then
    VERBOSE_MODE=true
fi

# Disable modules
for VAR in `printenv | grep DISABLEMODULE | cut -d= -f1 | cut -d_ -f2 | awk '{print tolower($0)}'`
do
    if [ -f "$PHPMODULES/$VAR.ini" ]
    then
        ${VERBOSE_MODE} && echo "Disabling Module $VAR ..."
        rm "$PHPMODULES/$VAR.ini"
    else
        ${VERBOSE_MODE} && echo "Module not found $VAR"
    fi
done

# List available modules
if [ "$VERBOSE" == "true" ]
then
    echo
    echo "Available Modules:"
    for VAR in `ls $PHPMODULES/ | sort`
    do
        echo $VAR | awk -F"." '{printf $1; printf " "}'
    done
    echo
fi

# No arguments, simply exit
if [ -z "$1" ];
then
    exit;
fi

# Run the parameters
exec ${@}
