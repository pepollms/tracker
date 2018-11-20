function create_file() {
    if [ $# -eq 0 ]; then
        echo "Missing district id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: district\n"
    contents+="district_id: ${arg_id}\n"
    contents+="---"
    local file="district_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

for i in {1..3}; do
    create_file $i
done
