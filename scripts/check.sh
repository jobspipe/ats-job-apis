#!/usr/bin/env bash
# Calls one known board per ATS and prints the HTTP status and size.
set -u
get() { printf '%-16s ' "$1"; curl -s -m 20 -o /dev/null -w '%{http_code} %{size_download}\n' "$2"; }
get greenhouse "https://boards-api.greenhouse.io/v1/boards/stripe/jobs"
get lever "https://api.lever.co/v0/postings/palantir?mode=json&limit=1"
get ashby "https://api.ashbyhq.com/posting-api/job-board/ramp"
get smartrecruiters "https://api.smartrecruiters.com/v1/companies/BoschGroup/postings?limit=1"
get workable "https://apply.workable.com/api/v1/widget/accounts/huggingface"
get recruitee "https://bunq.recruitee.com/api/offers/"
get personio "https://ew-nutrition.jobs.personio.de/xml?language=en"
printf '%-16s ' workday
curl -s -m 20 -o /dev/null -w '%{http_code} %{size_download}\n' -X POST \
  -H 'content-type: application/json' \
  -d '{"limit":1,"offset":0,"searchText":"","appliedFacets":{}}' \
  "https://nvidia.wd5.myworkdayjobs.com/wday/cxs/nvidia/NVIDIAExternalCareerSite/jobs"
