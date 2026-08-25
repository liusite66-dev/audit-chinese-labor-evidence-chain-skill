# Chinese Labor Evidence Chain Audit Evals

```json
{
  "skill":"audit-chinese-labor-evidence-chain-skill",
  "criteria":[
    {"id":"unit-tests","text":"Pipeline tests pass","type":"command","cmd":"python3 -m unittest discover -s tests -v"},
    {"id":"syntax","text":"Python scripts compile","type":"command","cmd":"python3 -m py_compile scripts/*.py"},
    {"id":"xlsx-sheets","text":"Report contains the eight Chinese worksheets","type":"llm-judge"}
  ],
  "golden":[
    {"id":"complete-and-gap","input":"golden/complete-and-gap/input.json","expected":null,"split":"val","expected_status":"pending-first-green"},
    {"id":"privacy-gate","input":"golden/privacy-gate/input.json","expected":null,"split":"val","expected_status":"pending-first-green"},
    {"id":"invalid-status","input":"golden/invalid-status/input.json","expected":null,"split":"test","expected_status":"pending-first-green"}
  ]
}
```
