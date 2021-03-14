ffuf_recursive(){
    mkdir -p recursive
    dom=$(echo $1 | unfurl format %s%d)
    ffuf -c -v -u $1/FUZZ -w $2 \
    -H "User-Agent: Firefox" \
    -H "X-Bug-Bounty: rez0" 
    -recursion -recursion-depth 5 \
    -mc all -ac \
    -o recursive/recursive_$dom.csv -of csv $3
}
ffuf_all(){
   mkdir -p all;
   xargs -P5 -I {} sh -c 'dom=$(echo {} | unfurl format %s%d);ffuf -c -u {}/FUZZ -w quick.txt -mc all -ac -o all/all_$dom.csv -of csv -maxtime 600 -v' < $1
}
ffuf_basicauth(){
   dom=$(echo $1 | unfurl format %s%d)
   ffuf -c -v -u $1 -w basic_auth.txt \
   -H "Authorization: Basic FUZZ" \
   -ac -mc all \
   -o basicauth_$dom.csv -of csv $2
}
ffuf_view(){
    find -name "*.csv" -exec cat {} \; \
    | sed 's/,/ /g' \
    | sort -k 5,5 -u -n \
    | vim -
}
ffuf_cols(){
    find -name "*.csv" | xargs cat \
    | cut -d, -f2,4- | awk -F, '$3==200' \
    | awk -F, 'BEGIN { OFS=FS }; { $1=substr($1, 1, 110); print }' \
    | sort -t, -k 4,4 -n -u | column -s, -t | vim -
}

