echo *********** runnin up script *******************
sleep 3s
echo restarting duftfinder
docker restart duftfinder
docker ps

sleep 7s

echo "counting Role in database duftfinder"
let count=`mongo duftfinder --eval "printjson(db.Role.count());"`
echo $count

echo "verifiying if $count is equal to 0"
if [ "$count" == "0" ]
then
    #sleep 3s
    echo "initializing database duftfinder"
    #mongo duftfinder --eval 'var document = {name  : "document_name",title : "document_title",};db.Upsala.insert(document);'
    rm -d -r -f setup
    git clone https://github.com/flozi76/vagrant-linux-docker-vm.git setup


    #sleep 5s
    FILES=setup/DuftfinderData/*

    #cd setup/DuftfinderData
    for f in $FILES
    do
        #echo "Importing $f file to mongodb"

        fullfilename=$f
        filename=$(basename "$fullfilename")
        fname="${filename%.*}"
        ext="${filename##*.}"

        echo $filename
        echo $fname
        #echo $ext
        echo "importing file $f to collection $fname... "
        mongoimport --db duftfinder --collection "$fname" --drop --file "$f"

    # take action on each file. $f store current file name
    #cat $f
    done
else
    echo "database duftfinder allready initialized"    
fi




#for i in {'File 1','File 2'}
#  do 
#     echo "Welcome $i times"
#done
