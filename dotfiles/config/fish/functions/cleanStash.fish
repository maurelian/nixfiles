function cleanStash
    set -l days $argv[1]
    if test -z "$days"
        set days 30
    end
    echo "Cleaning stash entries older than $days days..."
    git stash list | awk -v days=$days '$0 ~ /.*\((.*)\)/ {split($0,a,":"); split(a[1],b,"stash@{"); split(b[2],c,"}"); cmd="date -v-"days"d +%s"; cmd | getline cutoff; close(cmd); cmd="date -j -f \"%a %b %d %H:%M:%S %Y\" \""$0"\" +%s"; cmd | getline timestamp; close(cmd); if (timestamp < cutoff) {print "Dropping stash@{"c[1]"}"; system("git stash drop stash@{"c[1]"}")}}'
    echo "Stash cleaning complete."
end
