---
name: audit-chinese-labor-evidence-chain-skill
description: Audit evidence coverage, conflicts, burden of proof, and supplementation gaps in mainland China labor-contract disputes from user facts and DOCX, PDF, XLSX, image, TXT, or Markdown evidence. Use when a worker, employer, lawyer, or legal agent needs a Chinese XLSX evidence-chain report for employment relationship, contract validity, wages, overtime, termination, compensation, damages, or non-compete disputes. Do not calculate money or deadlines, draft pleadings, or decide that evidence is authentic or admissible.
license: MIT
activation: /audit-chinese-labor-evidence-chain-skill
metadata:
  author: liusite66-dev
  version: 1.0.0
  created: 2026-08-24
  last_reviewed: 2026-08-24
  review_interval_days: 180
provenance:
  maintainer: liusite66-dev
  version: 1.0.0
  created: 2026-08-24
  source_references:
    - 中国劳动合同纠纷证据链审计产品方案
---

# /audit-chinese-labor-evidence-chain-skill

将劳动合同纠纷的请求事项、法律要件、待证事实、证据及缺口整理为可追溯的五层矩阵。

## 安全门

在读取案件事实或证据前，说明当前 Agent 是本地还是云端。建议用户先脱敏；云端环境必须明确告知原始材料将由云端 Agent 读取，并取得用户本次明确同意。未确认时不得预览、转换、哈希或搜索材料。

## 工作流

1. 让用户选择 `劳动者`、`用人单位` 或 `中立` 立场。自由文本缺少主体、入离职时间、工资结构、解除事实或请求事项时，只追问影响分析的字段。
2. Read `references/labor-issue-map.md` for claim elements, burden-of-proof prompts, and evidence patterns. 不支持工伤认定、社保待遇、集体争议或纯劳务合同的实体审计；在报告中标注范围外事项。
3. 把事实整理为 JSON 后，通过标准输入运行：

```bash
python3 scripts/run_pipeline.py prepare --facts-json - --perspective worker --evidence FILE... --workspace TEMP_DIR --processing-environment cloud --privacy-confirmed
```

4. 读取输出的 `case-bundle.json`，再读取其中每个 `markdown_path`。不得把临时 Markdown 复制到其他目录。
5. 为每项请求分别分析，不得因同一证据与多个请求相关就自动认定全部覆盖。每条证据必须保留来源文件和页码、段落或行号；定位不稳定时写“页码待人工确认”。
6. 根据相关法律事实发生时间确定适用版本。默认检索全国人大、国务院、人社部门、最高人民法院等官方来源；用户已授权的法律数据库 MCP/API 仅作增强。Read `references/source-policy.md` for source and temporal rules.
7. 生成严格符合 `references/analysis-schema.md` 的 JSON。覆盖状态只能是 `完整覆盖`、`部分覆盖`、`缺失`、`相互冲突`、`待确认`。只列真实性、合法性、关联性和证明力风险，不声称证据真实、合法或必然被采信。
8. 通过标准输入生成报告并清理临时材料：

```bash
python3 scripts/run_pipeline.py report --case-bundle TEMP_DIR/case-bundle.json --analysis-json - --output CASE_劳动争议证据链审计报告.xlsx --cleanup
```

9. 只向用户报告成果路径、矩阵统计和需优先补证的事项；提醒报告仍可能包含敏感信息。

## 边界

- 不计算经济补偿、赔偿金、加班费或期限；需要时调用专门计算 Skill。
- 不起草仲裁申请书、答辩状或正式法律意见。
- 不把未检索到当作法律不存在，也不使用模型记忆作为现行法唯一证据。
- 网络不可用时继续证据审计，在“法律依据”和“处理记录”说明未核验范围。
- 不修改证据原件，不覆盖既有报告，不保留临时 Markdown。

## Gotchas

- MarkItDown 的 DOCX/PDF 转换不保证原页码；优先使用脚本补充的 OOXML、PDF 页或 XLSX 行定位。
- 图片和扫描 PDF 的 OCR 结果只能作为线索，必须回看原件。
- 文书形成时间不当然等于法律适用时间；使用与请求要件相关的法律事实发生时间。
