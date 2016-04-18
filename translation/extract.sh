# usage: ./extract.sh [ce] file_to_extract.txt

LANG=$1
FILENAME=$2
if [ "$LANG" != 'c' ] && [ "$LANG" != 'e' ] || [ -z "$FILENAME" ]; then
    echo 'usage:
    chinese: ./extract.sh c file_to_extract.txt
    english: ./extract.sh e file_to_extract.txt'
    exit 1
fi

if [ "$LANG" = 'c' ]; then
    awk 'BEGIN{chinese=0} /^&&&*/{chinese=1-chinese;next;} {if(chinese){print}}' $FILENAME
elif [ "$LANG" = 'e' ]; then
    awk 'BEGIN{chinese=0} /^&&&*/{chinese=1-chinese;next;} {if(!chinese){print}}' $FILENAME
fi

