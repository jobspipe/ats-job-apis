# Public ATS job board APIs

How to read job postings from applicant tracking systems: Greenhouse, Lever, Ashby, SmartRecruiters, Workable, Recruitee, Personio and Workday. Every endpoint below was called on November 2, 2026. Run `scripts/check.sh` to test them yourself.

All of them work per company. None returns every job across every customer, so you need each company's board name first.

| ATS | Request | Auth | Format |
|---|---|---|---|
| Greenhouse | `GET https://boards-api.greenhouse.io/v1/boards/{board}/jobs` | None | JSON |
| Lever | `GET https://api.lever.co/v0/postings/{company}?mode=json` | None | JSON |
| Ashby | `GET https://api.ashbyhq.com/posting-api/job-board/{board}` | None | JSON |
| SmartRecruiters | `GET https://api.smartrecruiters.com/v1/companies/{company}/postings` | None | JSON |
| Workable | `GET https://apply.workable.com/api/v1/widget/accounts/{account}` | None | JSON |
| Recruitee | `GET https://{company}.recruitee.com/api/offers/` | None | JSON |
| Personio | `GET https://{company}.jobs.personio.de/xml?language=en` | None | XML |
| Workday | `POST https://{tenant}.wd{n}.myworkdayjobs.com/wday/cxs/{tenant}/{site}/jobs` | None | JSON |

## Things that catch people out

- **An empty result can mean the wrong name.** SmartRecruiters answers `200` with `totalFound: 0` for a company it doesn't know, so check the total rather than the status.
- **Personio can look empty too.** A real company with no public feed returns an empty `<workzag-jobs>` document with a `200`. An unknown name returns `404`.
- **Workday needs a POST body.** A `GET` returns `400`. Send JSON:

  ```json
  {"limit": 20, "offset": 0, "searchText": "", "appliedFacets": {}}
  ```

- **Workday URLs have three unknowns:** the tenant, the `wd` number and the site name. Copy them from the company's careers URL. The list returns summaries, and each `externalPath` gets you the full posting.
- **Workday's documented REST API is a different thing.** It needs OAuth access granted by each tenant. The endpoint above is what the public careers site uses, so it can change without notice.
- **Greenhouse leaves out descriptions by default.** Add `?content=true`.
- **Fields don't match across systems.** Titles, locations, departments and dates each have their own names and formats, so plan on one parser per ATS.

## Try one

```bash
curl -s "https://api.lever.co/v0/postings/palantir?mode=json&limit=1"
curl -s "https://api.smartrecruiters.com/v1/companies/BoschGroup/postings?limit=1"
curl -s -X POST "https://nvidia.wd5.myworkdayjobs.com/wday/cxs/nvidia/NVIDIAExternalCareerSite/jobs" \
  -H "content-type: application/json" \
  -d '{"limit":1,"offset":0,"searchText":"","appliedFacets":{}}'
```

## Don't want to maintain this?

The hard part isn't the requests. It's keeping a list of every company on every ATS and a parser for each one. [JobsPipe](https://jobspipe.dev/ats-job-aggregator) does that for you: one API key, one schema, 30+ sources, no board names needed. You can try it without a key:

```bash
curl -d '{"limit":3}' https://api.jobspipe.dev/v1/sandbox/jobs/search
```

## Contributing

Found an endpoint that changed? Open an issue or a pull request with the request and what it returned.

## License

MIT
