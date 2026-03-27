#!/usr/bin/env bash

# Submits rp-pipeline jobs to run the xF.v4 nextflow pipeline on the downsampled xF test sample

# Usage function
function usage() {
    echo ""
    echo "usage: ./run-test-sample.sh --intent string --transform_hash string --docker_tag string"
    echo ""
    echo "  --intent (required)               'intent' field for job submissions"
    echo "  --docker_tag (required)           docker_tag to use"
    echo "  --fastq_url (optional)            'gcs_tumor_fastq_url' field for job submissions, default is downsamp_sample"
    echo "  --order_id (optional)             'order_id' field for job submissions, default is fastq basename"
    echo "  --cancer_type (optional)          'cancer_type' field for job submissions, default is null"
    echo "  --cancer_type_tmo (optional)          'cancer_type_tmo' field for job submissions, default is TMO15488554"
    echo "  --cancer_type_lims (optional)          'cancer_type_lims' field for job submissions, default is Tumor of Unknown Origin"
    echo "  --cancer_type_oncotree (optional)          'cancer_type_oncotree' field for job submissions, default is CUP"
    echo "  --transform_hash (optional)       transform_hash to use, default is first 7 chars of docker_tag"
    echo "  --resume_task_id (optional)       resume_task_id to use"
    exit 1
}

# Read arguments
# req
INTENT=""
DOCKER_TAG=""

# opt
# FASTQ_URL="gs://tl-bet-sequencer-output-fastq-us/Fake_Setler_Run/xFv2-031119-test_T_S_R_xF.v2.tar" # no-hla
FASTQ_URL="gs://tl-bet-sequencer-output-fastq-us/25-POS43002_CSQ1_5M.tar.gz" # hla
ORDER_ID=""
CANCER_TYPE="null"
CANCER_TYPE_TMO="TMO15488554"
CANCER_TYPE_LIMS="Tumor of Unknown Origin"
CANCER_TYPE_ONCOTREE="CUP"
TRANSFORM_HASH=""
RESUME_TASK_ID=""

while [[ $# -gt 0 ]]; do
    case $1 in
    --intent)
        INTENT="$2"
        shift 2
        ;;
    --transform_hash)
        TRANSFORM_HASH="$2"
        shift 2
        ;;
    --docker_tag)
        DOCKER_TAG="$2"
        shift 2
        ;;
    --resume_task_id)
        RESUME_TASK_ID="$2"
        shift 2
        ;;
    --fastq_url)
        FASTQ_URL="$2"
        shift 2
        ;;
    --order_id)
        ORDER_ID="$2"
        shift 2
        ;;
    --cancer_type)
        CANCER_TYPE="$2"
        shift 2
        ;;
    --cancer_type_tmo)
        CANCER_TYPE_TMO="$2"
        shift 2
        ;;
    --cancer_type_lims)
        CANCER_TYPE_LIMS="$2"
        shift 2
        ;;
    --cancer_type_oncotree)
        CANCER_TYPE_ONCOTREE="$2"
        shift 2
        ;;
    -*)
        echo "Parameter $1 not recognized."
        usage
        ;;
    esac
done

GIT_SHA_FULL="$(git rev-parse HEAD)"
GIT_SHA="${GIT_SHA_FULL:0:7}"

# check all necessary variables are available
# auto fill optional args
if [[ -z "$INTENT" ]]; then
    # ticket_id="$(git rev-parse --abbrev-ref HEAD | grep -oE "BIO-[0-9]+")"
    branch_name="$(git rev-parse --abbrev-ref HEAD | sed -E "s/^.+\///")"
    if [[ -n "$branch_name" ]]; then
        INTENT=$branch_name
        echo "Defaulting intent to $branch_name"
    fi
fi
if [[ -z "$DOCKER_TAG" ]]; then
    DOCKER_TAG="pr-$GIT_SHA_FULL"
    echo "Defaulting docker tag to HEAD sha $DOCKER_TAG"
fi
if [[ -z "$TRANSFORM_HASH" ]]; then
    TRANSFORM_HASH="$GIT_SHA"
    echo "Defaulting transform_hash to $TRANSFORM_HASH"
fi
if [[ -z "$ORDER_ID" ]]; then
    ORDER_ID="$(basename "$FASTQ_URL" | sed 's/\..*//')"
    echo "Defaulting order_id to $ORDER_ID"
fi
if [[ (-z $INTENT) || (-z $FASTQ_URL) || (-z $DOCKER_TAG) || (-z $ORDER_ID) || (-z $TRANSFORM_HASH) ]]; then
    echo "Missing parameters"
    usage
fi

echo ""
echo -e "intent:\t\t\t""$INTENT"
echo -e "docker_tag:\t\t""$DOCKER_TAG"
echo -e "transform_hash:\t\t""$TRANSFORM_HASH"
echo -e "fastq_url:\t\t""$FASTQ_URL"
echo -e "order_id:\t\t""$ORDER_ID"
echo -e "cancer_type:\t\t""$CANCER_TYPE"
echo -e "cancer_type_tmo:\t\t""$CANCER_TYPE_TMO"
echo -e "cancer_type_lims:\t\t""$CANCER_TYPE_LIMS"
echo -e "cancer_type_oncotree:\t\t""$CANCER_TYPE_ONCOTREE"
echo ""

read -p "are params ok? [y/n]" ok
if [[ "$ok" != "y" ]]; then
    echo "launch job canceled"
    exit 1
fi

cd "$HOME/projects/tempus/bioinf-ctdna-analysis/util/launch_rp_pipeline_jobs" || exit
if [[ ! -d ".venv" ]]; then
    echo "No venv found in $PWD"
    exit
fi

source .venv/bin/activate
echo -e "\nvenv set:"
which python

echo -e "\nRunning test sample through xF nextflow pipeline..."

# add intent and time stamp to file paths to not override previous test output
date_str=$(date +%Y-%m-%d_%H:%M:%S)
data_dir=test-sample-runs/$INTENT/$date_str/data
rm -rf "$data_dir"
mkdir -p "$data_dir"/input

# set variables in samples.csv
FASTQ_URL="${FASTQ_URL//\//\\\/}" # escape the slashes in fastq url for sed
sed \
    -e "2s/INTENT/$INTENT/" \
    -e "2s/TRANSFORM_HASH/$TRANSFORM_HASH/" \
    -e "2s/DOCKER_TAG/$DOCKER_TAG/" \
    -e "2s/ORDER_ID/$ORDER_ID/" \
    -e "2s/CANCER_TYPE_TMO/$CANCER_TYPE_TMO/" \
    -e "2s/CANCER_TYPE_LIMS/$CANCER_TYPE_LIMS/" \
    -e "2s/CANCER_TYPE_ONCOTREE/$CANCER_TYPE_ONCOTREE/" \
    -e "2s/\bCANCER_TYPE\b/$CANCER_TYPE/" \
    -e "2s/FASTQ_URL/$FASTQ_URL/" \
    templates/custom_sample.csv >"$data_dir"/input/samples.csv

# if passed a resume_task_id, append it as a new column
if [[ (-n $RESUME_TASK_ID) ]]; then
    echo -e "\nresume_task_id:\t\t$RESUME_TASK_ID"
    paste -d "," <(cat "$data_dir"/input/samples.csv) <(echo -e "resume_task_id\n""$RESUME_TASK_ID") >"$data_dir"/input/samples_with_resume_task_id.csv
    mv "$data_dir"/input/samples_with_resume_task_id.csv "$data_dir"/input/samples.csv
fi

# launch sample
python rp_pipeline_adapter.py -i "$data_dir"/input/samples.csv -o "$data_dir"/logs --output-csv "$data_dir"/output/rp_pipeline_adapter_output.csv
launch_exit_code=$?
if [ "$launch_exit_code" -ne 0 ]; then
    echo -e "\nError kicking off downsampled fastq (exit code $launch_exit_code), exiting"
    exit "$launch_exit_code"
fi

# print output
echo -e "\nLaunched test sample:\n"
awk -F ',' 'NR==1 {
    for (i=1; i<=NF; i++) {
        f[$i] = i
    }
}
NR > 1 {
    print "\tanalysis_id:\t\t"$(f["analysis_id"])
    print "\thead_job_log_url:\t"$(f["head_job_log_url"])
    print "\tresume_task_id:\t\t"$(f["resume_task_id"])
    print "\texecution_id:\t\t"$(f["execution_id"])
}' "$data_dir"/output/rp_pipeline_adapter_output.csv

echo -e " \nLogs are in $data_dir/output/rp_pipeline_adapter_output.csv\n"

echo "### $INTENT ($GIT_SHA) :repeat:"
awk -F ',' 'NR==1 {
    for (i=1; i<=NF; i++) {
        f[$i] = i
    }
}
NR > 1 {
    print "- [head job]("$(f["head_job_log_url"])")"
    print "- [pipeline execution details](https://flow.bet.gcp.tempus.cloud/pipeline-execution-details/"$(f["execution_id"])")"
    print "- analysis_id: `"$(f["analysis_id"])"`"
    print "- resume_task_id: `"$(f["resume_task_id"])"`"
}' "$data_dir"/output/rp_pipeline_adapter_output.csv
echo ""

# custom gcloud watchlist stuff
# awk -F ',' 'NR==1 {
#     for (i=1; i<=NF; i++) {
#         f[$i] = i
#     }
# }
# NR > 1 {
#     print $(f["head_job_log_url"])
# }' "$data_dir"/output/rp_pipeline_adapter_output.csv | sed -r "s/^.*\/jobs\/(.+)\/.*/\1/" >>"$GCLOUD_WATCHLIST"
# echo "job id added to google batch watchlist:"
# cat "$GCLOUD_WATCHLIST"
