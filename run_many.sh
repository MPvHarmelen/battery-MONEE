WAIT_TIME=1100
MAIN_DIR=properties
SKIP=4
PARALLEL=2

for run in {10..16}; do
    for description in $(ls -1 $MAIN_DIR/run$run | cut -d'.' -f 2); do
        if [[ SKIP -gt 0 ]]; then
            echo "Skipping run $run $description"
            SKIP=$((SKIP-1))
            continue
        fi
        for (( i = 0; i < $PARALLEL; i++ )); do
            echo "Starting run $run $description"
            gnome-terminal --working-directory=$(pwd) -e "../run_once.sh $run $description"
        done
        echo "Waiting $WAIT_TIME seconds"
        sleep $WAIT_TIME
        gnome-terminal --working-directory=$(pwd) -e "../run_once.sh $run $description"
    done
done

