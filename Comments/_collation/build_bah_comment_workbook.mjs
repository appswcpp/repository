import fs from "node:fs/promises";
import path from "node:path";
import { SpreadsheetFile, Workbook } from "@oai/artifact-tool";

const workspace = process.cwd();
const inputPath = path.join(workspace, "Comments", "_collation", "bah_comment_register.json");
const outputDir = path.join(workspace, "outputs", "bah_comment_collation");
const records = JSON.parse(await fs.readFile(inputPath, "utf8"));

const groupFocus = {
  "Publication metadata and referenced versions": "Refresh 2026 dates and ensure all cited PP, module, and CC versions are current.",
  "Managed runtime / application framework scope": "Align terminology, TD1026/TD1050 incorporation, TOE-boundary treatment, and update requirements.",
  "Distributed TOE allocation, IPC, and loopback scope": "Resolve allocation language, Feature Dependent usage, ST detail level, and loopback encryption scope.",
  "Agent terminology and SFR iteration cleanup": "Remove obsolete /Agent labels and iteration references, then simplify the affected wording.",
  "Agent registration and communication tests": "Decide whether to retain or revise registration-channel requirements and the related evaluator tests.",
  "Server module alignment with the base cPP": "Resolve duplicated base-cPP requirements and evaluator activities in the Server module and SD.",
};

const groups = [...new Set(records.map((record) => record.analysis_group))].sort();
const documents = [...new Set(records.map((record) => record.document))].sort();
const statusOptions = ["Not reviewed", "In analysis", "Resolved", "Deferred"];
const dispositionOptions = ["", "Accept", "Accept with adaptation", "Clarify with reviewer", "Reject with rationale"];

const workbook = Workbook.create();
const summary = workbook.worksheets.add("Summary");
const register = workbook.worksheets.add("Comment Register");
const response = workbook.worksheets.add("BAH Response");
const documentSummary = workbook.worksheets.add("Document Summary");

for (const sheet of [summary, register, response]) {
  sheet.showGridLines = false;
}

summary.mergeCells("A1:G1");
summary.getRange("A1").values = [["BAH Draft Review Comment Disposition Register"]];
summary.getRange("A2:G2").merge();
summary.getRange("A2").values = [["All 49 substantive BAH draft-review comments are resolved. The BAH Response sheet records the disposition, rationale, and principal source update for each comment."]];
summary.getRange("A1:G1").format = {
  fill: "#17365D",
  font: { bold: true, color: "#FFFFFF", size: 16 },
  horizontalAlignment: "left",
  verticalAlignment: "center",
};
summary.getRange("A2:G2").format = {
  fill: "#D9EAF7",
  font: { color: "#1F2937", italic: true },
  wrapText: true,
  verticalAlignment: "center",
};
summary.getRange("A1:G1").format.rowHeight = 30;
summary.getRange("A2:G2").format.rowHeight = 38;

summary.getRange("A4:B4").values = [["Review metric", "Value"]];
summary.getRange("A5:B7").values = [
  ["Substantive comments", null],
  ["Resolved comments", null],
  ["Commented PDFs", null],
];
summary.getRange("B5").formulas = [["=COUNTA('Comment Register'!$A$2:$A$50)"]];
summary.getRange("B6").formulas = [["=COUNTIF('Comment Register'!$K$2:$K$50,\"Resolved\")"]];
summary.getRange("B7").formulas = [["=COUNTA('Document Summary'!$A$4:$A$11)"]];
summary.getRange("A4:B4").format = { fill: "#5B9BD5", font: { bold: true, color: "#FFFFFF" } };
summary.getRange("A4:B7").format.borders = { preset: "outside", style: "thin", color: "#9EADBA" };
summary.getRange("A5:A7").format = { fill: "#EDF3F8", font: { bold: true } };
summary.getRange("B5:B7").format = { fill: "#FFF2CC", font: { bold: true }, horizontalAlignment: "center" };

summary.mergeCells("A9:C9");
summary.getRange("A9").values = [["Resolved discussion groups"]];
summary.getRange("A9:C9").format = { fill: "#70AD47", font: { bold: true, color: "#FFFFFF" } };
summary.getRange("A10:C10").values = [["Discussion group", "Comments", "Review focus"]];
summary.getRange("A10:C10").format = { fill: "#E2F0D9", font: { bold: true } };
const groupRows = groups.map((group) => [group, null, groupFocus[group] || "Review and classify."]);
summary.getRange(`A11:C${10 + groupRows.length}`).values = groupRows;
for (let row = 11; row < 11 + groupRows.length; row += 1) {
  summary.getRange(`B${row}`).formulas = [[`=COUNTIF('Comment Register'!$J$2:$J$50,A${row})`]];
}
summary.getRange(`A10:C${10 + groupRows.length}`).format.borders = { preset: "outside", style: "thin", color: "#A8C893" };
summary.getRange(`A11:A${10 + groupRows.length}`).format = { fill: "#F5FAF1", wrapText: true, verticalAlignment: "center" };
summary.getRange(`B11:B${10 + groupRows.length}`).format = { horizontalAlignment: "center", font: { bold: true } };
summary.getRange(`C11:C${10 + groupRows.length}`).format = { wrapText: true, verticalAlignment: "center" };
summary.getRange(`A11:C${10 + groupRows.length}`).format.rowHeight = 42;

summary.mergeCells("E4:G4");
summary.getRange("E4").values = [["Commented review documents"]];
summary.getRange("E4:G4").format = { fill: "#5B9BD5", font: { bold: true, color: "#FFFFFF" } };
summary.getRange("E5:F5").values = [["Document", "Comments"]];
summary.getRange("E5:F5").format = { fill: "#D9EAF7", font: { bold: true } };
const docRows = documents.map((document) => [document, null]);
summary.getRange(`E6:F${5 + docRows.length}`).values = docRows;
for (let row = 6; row < 6 + docRows.length; row += 1) {
  summary.getRange(`F${row}`).formulas = [[`=COUNTIF('Comment Register'!$B$2:$B$50,E${row})`]];
}
summary.getRange(`E5:F${5 + docRows.length}`).format.borders = { preset: "outside", style: "thin", color: "#9EADBA" };
summary.getRange(`E6:E${5 + docRows.length}`).format = { wrapText: true, verticalAlignment: "center" };
summary.getRange(`F6:F${5 + docRows.length}`).format = { horizontalAlignment: "center", font: { bold: true } };
summary.getRange(`E6:F${5 + docRows.length}`).format.rowHeight = 30;

summary.getRange("A21:G21").merge();
summary.getRange("A21").values = [["Reviewer handoff: use the BAH Response sheet for the complete disposition, rationale, and principal source update. The Comment Register preserves the original annotation context."]];
summary.getRange("A21:G21").format = { fill: "#FFF2CC", font: { italic: true }, wrapText: true, verticalAlignment: "center" };
summary.getRange("A21:G21").format.rowHeight = 34;
summary.getRange("A:A").format.columnWidth = 35;
summary.getRange("B:B").format.columnWidth = 12;
summary.getRange("C:C").format.columnWidth = 55;
summary.getRange("D:D").format.columnWidth = 4;
summary.getRange("E:E").format.columnWidth = 46;
summary.getRange("F:F").format.columnWidth = 12;
summary.getRange("G:G").format.columnWidth = 4;

const headers = [
  "ID",
  "Document",
  "Page",
  "Annotation Type",
  "Author",
  "Comment Date",
  "Anchor Text",
  "Reviewer Comment",
  "Initial Topic",
  "Discussion Group",
  "Status",
  "Disposition",
  "Owner",
  "Resolution Notes",
  "Source PDF",
];
register.getRange("A1:O1").values = [headers];
register.getRange("A1:O1").format = {
  fill: "#17365D",
  font: { bold: true, color: "#FFFFFF" },
  wrapText: true,
  verticalAlignment: "center",
};
const dataRows = records.map((record) => [
  record.id,
  record.document,
  record.page,
  record.annotation_type,
  record.author || "Not recorded",
  record.date || "Not recorded",
  record.anchor_text || "No text anchor recoverable",
  record.comment,
  record.initial_topic,
  record.analysis_group,
  record.status,
  record.disposition,
  record.owner,
  record.resolution_notes,
  record.source_file,
]);
register.getRange(`A2:O${dataRows.length + 1}`).values = dataRows;
const table = register.tables.add(`A1:O${dataRows.length + 1}`, true, "CommentRegister");
table.style = "TableStyleMedium2";
register.freezePanes.freezeRows(1);
register.freezePanes.freezeColumns(2);
register.getRange(`C2:C${dataRows.length + 1}`).format.horizontalAlignment = "center";
register.getRange(`G2:O${dataRows.length + 1}`).format.wrapText = true;
register.getRange(`A2:O${dataRows.length + 1}`).format.verticalAlignment = "top";
register.getRange(`A2:O${dataRows.length + 1}`).format.rowHeight = 88;
register.getRange(`K2:K${dataRows.length + 1}`).dataValidation = { rule: { type: "list", values: statusOptions } };
register.getRange(`L2:L${dataRows.length + 1}`).dataValidation = { rule: { type: "list", values: dispositionOptions } };
register.getRange(`K2:K${dataRows.length + 1}`).conditionalFormats.add("containsText", { text: "Not reviewed", format: { fill: "#FCE4D6", font: { color: "#9C0006" } } });
register.getRange(`K2:K${dataRows.length + 1}`).conditionalFormats.add("containsText", { text: "Resolved", format: { fill: "#E2F0D9", font: { color: "#006100" } } });

const widths = [12, 43, 8, 16, 14, 22, 56, 74, 29, 43, 17, 24, 18, 48, 45];
for (let index = 0; index < widths.length; index += 1) {
  register.getRangeByIndexes(0, index, dataRows.length + 1, 1).format.columnWidth = widths[index];
}
register.getRange(`A2:O${dataRows.length + 1}`).format.autofitRows();
register.getRange("A1:O1").format.rowHeight = 34;

response.getRange("A1:F1").merge();
response.getRange("A1").values = [["BAH Draft Review Disposition and Rationale"]];
response.getRange("A2:F2").merge();
response.getRange("A2").values = [["Reviewer-facing response for all 49 BAH draft-review comments. Each row identifies the disposition, rationale, and principal source update in the next revision."]];
response.getRange("A1:F1").format = {
  fill: "#17365D",
  font: { bold: true, color: "#FFFFFF", size: 16 },
  horizontalAlignment: "left",
  verticalAlignment: "center",
};
response.getRange("A2:F2").format = {
  fill: "#D9EAF7",
  font: { color: "#1F2937", italic: true },
  wrapText: true,
  verticalAlignment: "center",
};
response.getRange("A1:F1").format.rowHeight = 30;
response.getRange("A2:F2").format.rowHeight = 38;
const responseHeaders = ["ID", "Document", "Discussion Group", "Disposition", "Response and Rationale", "Principal Source Update"];
const responseRows = records.map((record) => [
  record.id,
  record.document,
  record.analysis_group,
  record.disposition,
  record.resolution_notes,
  record.source_update,
]);
response.getRange("A4:F4").values = [responseHeaders];
response.getRange("A4:F4").format = {
  fill: "#5B9BD5",
  font: { bold: true, color: "#FFFFFF" },
  wrapText: true,
  verticalAlignment: "center",
};
response.getRange(`A5:F${responseRows.length + 4}`).values = responseRows;
const responseTable = response.tables.add(`A4:F${responseRows.length + 4}`, true, "BAHResponse");
responseTable.style = "TableStyleMedium2";
response.freezePanes.freezeRows(4);
response.freezePanes.freezeColumns(1);
response.getRange(`A5:F${responseRows.length + 4}`).format = { wrapText: true, verticalAlignment: "top" };
response.getRange(`A5:F${responseRows.length + 4}`).format.rowHeight = 72;
response.getRange(`D5:D${responseRows.length + 4}`).conditionalFormats.add("containsText", { text: "Accept", format: { fill: "#E2F0D9", font: { color: "#006100" } } });
response.getRange(`D5:D${responseRows.length + 4}`).conditionalFormats.add("containsText", { text: "Clarify", format: { fill: "#FFF2CC", font: { color: "#7F6000" } } });
const responseWidths = [12, 42, 42, 24, 78, 54];
for (let index = 0; index < responseWidths.length; index += 1) {
  response.getRangeByIndexes(0, index, responseRows.length + 4, 1).format.columnWidth = responseWidths[index];
}
response.getRange("A4:F4").format.rowHeight = 34;

documentSummary.showGridLines = false;
documentSummary.getRange("A1:D1").merge();
documentSummary.getRange("A1").values = [["Source PDF inventory"]];
documentSummary.getRange("A1:D1").format = { fill: "#17365D", font: { bold: true, color: "#FFFFFF", size: 14 } };
documentSummary.getRange("A3:D3").values = [["Document", "Comments", "Source", "Notes"]];
documentSummary.getRange("A3:D3").format = { fill: "#5B9BD5", font: { bold: true, color: "#FFFFFF" } };
const sourceRows = documents.map((document) => {
  const first = records.find((record) => record.document === document);
  return [document, null, first.source_file, "Original annotated PDF preserved under Comments/."];
});
documentSummary.getRange(`A4:D${sourceRows.length + 3}`).values = sourceRows;
for (let row = 4; row < 4 + sourceRows.length; row += 1) {
  documentSummary.getRange(`B${row}`).formulas = [[`=COUNTIF('Comment Register'!$B$2:$B$50,A${row})`]];
}
documentSummary.getRange(`A3:D${sourceRows.length + 3}`).format.borders = { preset: "outside", style: "thin", color: "#9EADBA" };
documentSummary.getRange(`A4:D${sourceRows.length + 3}`).format = { wrapText: true, verticalAlignment: "center" };
documentSummary.getRange(`B4:B${sourceRows.length + 3}`).format.horizontalAlignment = "center";
documentSummary.getRange(`A4:D${sourceRows.length + 3}`).format.rowHeight = 38;
documentSummary.getRange("A:A").format.columnWidth = 46;
documentSummary.getRange("B:B").format.columnWidth = 12;
documentSummary.getRange("C:C").format.columnWidth = 48;
documentSummary.getRange("D:D").format.columnWidth = 38;
documentSummary.freezePanes.freezeRows(3);

await fs.mkdir(outputDir, { recursive: true });
const workbookOutput = await SpreadsheetFile.exportXlsx(workbook);
const outputPath = path.join(outputDir, "BAH_Draft_Review_Comment_Register.xlsx");
await workbookOutput.save(outputPath);

const checks = await workbook.inspect({
  kind: "table",
  range: "BAH Response!A1:F8",
  include: "values,formulas",
  tableMaxRows: 8,
  tableMaxCols: 6,
});
console.log(checks.ndjson);
const formulaErrors = await workbook.inspect({
  kind: "match",
  searchTerm: "#REF!|#DIV/0!|#VALUE!|#NAME\\?|#N/A",
  options: { useRegex: true, maxResults: 100 },
  summary: "formula error scan",
});
console.log(formulaErrors.ndjson);
const summaryPreview = await workbook.render({ sheetName: "Summary", range: "A1:G21", scale: 1.5, format: "png" });
await fs.writeFile(path.join(outputDir, "summary_preview.png"), new Uint8Array(await summaryPreview.arrayBuffer()));
const registerPreview = await workbook.render({ sheetName: "Comment Register", range: "A1:J7", scale: 1, format: "png" });
await fs.writeFile(path.join(outputDir, "register_preview.png"), new Uint8Array(await registerPreview.arrayBuffer()));
const responsePreview = await workbook.render({ sheetName: "BAH Response", range: "A1:F9", scale: 1, format: "png" });
await fs.writeFile(path.join(outputDir, "bah_response_preview.png"), new Uint8Array(await responsePreview.arrayBuffer()));
const documentPreview = await workbook.render({ sheetName: "Document Summary", range: "A1:D11", scale: 1.5, format: "png" });
await fs.writeFile(path.join(outputDir, "document_summary_preview.png"), new Uint8Array(await documentPreview.arrayBuffer()));
console.log(`Wrote ${outputPath}`);
