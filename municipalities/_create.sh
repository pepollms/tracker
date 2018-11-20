function create_file() {
    if [ $# -eq 0 ]; then
        echo "Missing municipality id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: municipality\n"
    contents+="municipality_id: ${arg_id}\n"
    contents+="---"
    local file="municipality_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

for i in {1..18}; do
    create_file $i
done
