WAIT_TIME=4000
PROPERTIES_DIRS="/home/martin/Dropbox/CollectiveIntelligence/Properties/400 /home/martin/Dropbox/CollectiveIntelligence/Properties/200"
ROBO_DIR=/home/martin/Documents/repos/battery-MONEE/RoboRobo
OUT_DIR=/home/martin/Dropbox/CollectiveIntelligence/Depletionlogs
SKIP=0
PARALLEL=3

DIR=`readlink -fn $0`
BASEDIR=`dirname $DIR`

parallel=PARALLEL
# for run in {17..32}; do
for prop_dir in $PROPERTIES_DIRS; do
    for filename in $(ls -1 $prop_dir | grep level); do
        description=$(echo $filename | cut -d'.' -f 2 | cut -dr -f 1 | cut -dl -f 3)
        run=$(echo $filename | cut -d"." -f 2 | cut -dn -f2)
        if [[ SKIP -gt 0 ]]; then
            echo "Skipping run $run $description"
            SKIP=$((SKIP-1))
            continue
        fi
        echo "Starting run $run $description"
        gnome-terminal --working-directory=$ROBO_DIR -e "../run_once.sh $prop_dir/$filename $OUT_DIR/$description/level${description}run$run.txt"
        parallel=$((parallel-1))
        if [[ parallel -eq 0 ]]; then
            parallel=$PARALLEL
            echo "Waiting $WAIT_TIME seconds"
            sleep $WAIT_TIME
        fi
    done
done
# done

