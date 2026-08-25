# 中国劳动合同纠纷证据链审计 Skill

`audit-chinese-labor-evidence-chain-skill` 是一个面向 Agent 的中国劳动合同纠纷证据链审计工具。它根据用户提供的案件事实和证据材料，梳理：

`请求事项 -> 法律构成要件及举证责任 -> 待证事实 -> 证据及来源定位 -> 覆盖结论与补证动作`

最终生成中文 Excel（XLSX）审计报告。

## 功能范围

第一版支持劳动关系确认、劳动合同订立与效力、工资拖欠、加班、劳动合同解除或终止、经济补偿或赔偿相关证据链、竞业限制。

支持输入 DOCX、PDF、XLSX、PNG/JPG/TIFF 等图片、TXT 和 Markdown。

报告包含 8 个工作表：`汇总`、`案件事实与请求`、`证据清单`、`五层矩阵`、`矛盾与风险`、`缺口与补证`、`法律依据`、`处理记录`。

## 安全与法律边界

读取案件事实或证据前，Agent 必须说明当前是本地还是云端处理环境，并取得用户对读取原始材料的明确知情确认。建议先使用本地脱敏 Skill 处理敏感文件。

本 Skill 只读处理原始证据，不修改或覆盖原文件；转换后的 Markdown 仅保存在受限临时目录，报告完成后清理。它只提示真实性、合法性、关联性和证明力风险，不认定证据真实、合法或必然被采信，不计算补偿金额、加班费或仲裁期限，也不起草仲裁申请书、答辩状或正式法律意见。报告可能包含案件敏感信息，必须限制访问并妥善保管。

## 安装

```bash
python3 -m pip install -r requirements.txt
./install.sh --platform codex
```

也可以使用 `./install.sh --platform universal`、`--platform claude-code` 或 `--platform copilot`。安装器只写入对应的 Skill 子目录，不覆盖整个 Skills 根目录。

## Agent 调用

```text
/audit-chinese-labor-evidence-chain-skill
我是劳动者，公司以严重违纪为由解除劳动合同。我提供解除通知书、劳动合同、考勤表和聊天记录，请审计证据链是否完整，并生成 XLSX 报告。
```

每次选择 `劳动者`、`用人单位` 或 `中立` 立场。案件事实可以自由描述；缺少入离职时间、工资结构、解除理由、通知到达时间或具体请求等关键字段时，Agent 会定向补问。

## 脚本接口

### 第一步：准备材料

```bash
python3 scripts/run_pipeline.py prepare \
  --facts-json - \
  --perspective worker \
  --evidence ./解除通知书.docx ./劳动合同.pdf ./考勤表.xlsx \
  --workspace /tmp/labor-evidence-workspace \
  --processing-environment cloud \
  --privacy-confirmed
```

事实 JSON 示例：

```json
{
  "case_name": "张某违法解除争议",
  "summary": "公司以严重违纪为由解除劳动合同，劳动者否认违纪。",
  "claims": ["违法解除赔偿"]
}
```

`prepare` 只做本地文件转换、来源定位和临时案件包生成，输出临时目录中的 `case-bundle.json`。

### 第二步：生成报告

Agent 根据案件包和临时 Markdown 材料生成符合 `references/analysis-schema.md` 的 JSON，然后运行：

```bash
python3 scripts/run_pipeline.py report \
  --case-bundle /tmp/labor-evidence-workspace/case-bundle.json \
  --analysis-json - \
  --output ./张某_劳动争议证据链审计报告.xlsx \
  --cleanup < analysis.json
```

`--cleanup` 会删除受管临时目录；输出文件已存在时，脚本拒绝覆盖。

## 证据状态与法律依据

五层矩阵状态只能是：`完整覆盖`、`部分覆盖`、`缺失`、`相互冲突`、`待确认`。“完整覆盖”不代表证据必然真实、合法或被采信。

默认优先核验全国人大、国务院、最高人民法院、人力资源和社会保障部门等官方来源。用户授权的北大法宝等法律数据库 MCP/API 可以增强核验，但不保存账号、密码、Cookie 或 Token。适用法律版本应根据相关法律事实发生时间确定，而不是机械使用文书形成时间。

## 测试与质量检查

```bash
python3 -m unittest discover -s tests -v
python3 scripts/run_evals.py --validate
```

Skill Creator 的 `security_scan.py`、`check_pipeline.py` 和 `validate.py` 也应全部通过。

## 参考资料

- [分析 JSON 契约](references/analysis-schema.md)
- [劳动争议分析路由](references/labor-issue-map.md)
- [法律来源与时间适用政策](references/source-policy.md)
- [Skill 定义](SKILL.md)

## 许可证

MIT License。本工具仅用于辅助整理和审计，不替代律师、仲裁员或法官的专业判断。
