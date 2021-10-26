#!/bin/bash
set -e

RUNNER_WORKDIR="/_work"

mkdir actions-runner && cd actions-runner
curl -O -L https://github.com/actions/runner/releases/download/v2.283.3/actions-runner-linux-x64-2.283.3.tar.gz
tar xzf ./actions-runner-linux-x64-2.283.3.tar.gz
./bin/installdependencies.sh
mkdir ${RUNNER_WORKDIR}

registration_url="https://api.github.com/repos/${ORG}/${REPO}/actions/runners/registration-token"
echo "Requesting registration URL at '${registration_url}'"

payload=$(curl -sX POST -H "Authorization: token ${PAT}" ${registration_url})
export RUNNER_TOKEN=$(echo $payload | jq .token --raw-output)

./config.sh \
    --name $(hostname) \
    --token ${RUNNER_TOKEN} \
    --url https://github.com/${ORG}/${REPO} \
    --work ${RUNNER_WORKDIR} \
    --unattended \
    --label iag-tf-runner \
    --replace

remove() {
    ./config.sh remove --unattended --token "${RUNNER_TOKEN}"
}

trap 'remove; exit 130' INT
trap 'remove; exit 143' TERM

./run.sh "$*" &

wait $!