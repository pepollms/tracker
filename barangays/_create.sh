function create_file() {
    if [ $# -eq 0 ]; then
        echo "Missing barangay id parameter."
        return 1
    fi
    arg_id=$1
    local contents=""
    contents+="---\n"
    contents+="layout: barangay\n"
    contents+="barangay_id: ${arg_id}\n"
    contents+="---"
    local file="barangay_${arg_id}.md"

    echo -e ${contents} > "${file}"
}

for i in {1..542}; do
    create_file $i
done
