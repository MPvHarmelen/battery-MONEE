RUN=$1
DESCRIPTION=$2

./roborobo -l properties/run$RUN/Battery.$DESCRIPTION.properties > depletionLogs/$DESCRIPTION-run$RUN.txt
