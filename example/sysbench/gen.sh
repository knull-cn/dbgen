#!/bin/sh

function redEcho(){
    echo -e "\033[31m $1 \033[0m" $2
}

# arguments : -t tbl -d db -n 1000 -tn 32
function usage(){
    echo "dbgen.sh -t 'table-name' -d 'db-name' -s 'count' -n 'table-number'"
    redEcho "\t-t"   " : set the name of table. default is sbtest."
    redEcho "\t-d"   " : set the name of database. default is sbtest."
    redEcho "\t-s"   " : set the size of record in one table. default is 100*10000."
    redEcho "\t-c"  ": set the count of the tables. default is 8.not more than 128."
    redEcho "\t-e"  ": the 'dbgen' exe file. default in current dir."
    redEcho "\t-i"  ": the 'template' file . default is 'template.sql' in current dir."
    redEcho "\t-o"  ": the data output dir. default in current dir."
}

##########################################################################################################
#--> define the variables.
##########################################################################################################
tblName="sbtest"
dbName="sbtest"
tblSize=1000000 # 1m
tblCount=8
dbgen=./dbgen       # 'dbgen' is default in current dir.
tmp=./template.sql  # 'template' is default in current dir.
out=./  # output dir default is current dir.

#size of one table.
fileSize=1000000
tblCntMax=128

##########################################################################################################
#--> here is parse the arguments.
##########################################################################################################
while getopts t:d:s:c:e:i:o: ARGS  
do  
    case $ARGS in   
        t)  #table name.
            tblName=$OPTARG 
            ;;  
        d)  # database name.
            dbName=$OPTARG
            ;;  
        s)  # size of table.
            tblSize=$OPTARG
            if [ $tblSize -le $fileSize ];
            then
                fileSize=$tblSize
            fi;
            ;;  
        c)  
            tblCount=$OPTARG
            if [ $tblCount -gt $tblCntMax ];
            then
                tblCount=$tblCntMax
            fi;
            ;;
        e)
            dbgen=$OPTARG
            ;;
        i)
            tmp=$OPTARG
            ;;
        o)
            out=$OPTARG
            ;;
        *)  
            echo "unknown args: '$ARGS'"
            usage
            exit 1
            ;;
    esac
done
echo "arguments: tblName=$tblName; dbName=$dbName; tblSize=$tblSize; tblCount=$tblCount; out=$out;"

##########################################################################################################
#--> run gen data.
##########################################################################################################
mkdir -p $out

for ((ti=1;ti<=$tblCount ;ti++))
do
    ftbl=$tblName$ti
    fout=$out/$ftbl
    fmt=$dbName"."$ftbl
    redEcho "$dbgen -i $tmp -o $fout  -t $fmt -f csv -N $tblSize -R $fileSize\n"
    $dbgen -i $tmp -o $fout  -t $fmt -f csv -N $tblSize -R $fileSize
done;