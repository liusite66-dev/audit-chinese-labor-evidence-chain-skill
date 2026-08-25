# Analysis JSON Schema

Read this file before generating `analysis-json`. The root must be an object with these keys. Every sheet key is an array of objects; use empty arrays rather than omitting keys.

```json
{
  "overall_opinion": "证据链总体意见，不作真实性或采信结论",
  "verification_scope": "已核验的官方来源、不可用数据源及检索时间",
  "案件事实与请求": [{"type":"请求事项","item":"违法解除赔偿","statement":"用户陈述摘要","support":"材料印证情况","issue":"差异或待确认问题"}],
  "证据清单": [{"evidence_id":"E-001","name":"解除通知书","type":"书证","source_file":"解除通知书.docx","locator":"段落 3","created_at":"2026-01-05","summary":"必要摘要","authenticity_risk":"仅列风险","legality_risk":"仅列风险","relevance_risk":"仅列风险"}],
  "五层矩阵": [{"claim":"违法解除赔偿","element_and_burden":"构成要件及承担举证责任的一方","fact_to_prove":"具体待证事实","evidence_and_locator":"E-001，解除通知书.docx，段落 3","status":"部分覆盖","reason":"为何属于该状态","action":"具体补证动作"}],
  "矛盾与风险": [{"id":"C-001","type":"时间冲突","subject":"解除日期","side_a":"材料A摘要","side_b":"材料B摘要","locator":"两个来源定位","risk":"风险说明","action":"核实方式"}],
  "缺口与补证": [{"id":"G-001","claim":"违法解除赔偿","missing_fact":"缺失事实","suggested_evidence":"建议材料","holder":"可能持有人","method":"合法取得方式","priority":"高"}],
  "法律依据": [{"title":"法律名称","article":"条款","version":"版本或公布日期","effective_period":"效力期间","fact_date":"相关事实日期","source_name":"官方发布机关","source_url":"https://...","checked_at":"ISO 8601 时间","application":"与本案要件的关系"}],
  "处理记录": [{"subject":"官方法源检索","status":"成功或受限","method":"公开网页或用户授权数据库","locator_scope":"核验范围","note":"不含完整敏感原文"}]
}
```

## Required invariants

- Each matrix row represents one claim element and one fact to prove.
- Every evidence row includes `source_file` and `locator`.
- Matrix `status` is exactly one of: `完整覆盖`, `部分覆盖`, `缺失`, `相互冲突`, `待确认`.
- Evidence risks describe observable uncertainty. Do not use “真实有效”“必然采信” or equivalent conclusions.
- Use `页码待人工确认` when conversion cannot preserve a stable original location.
