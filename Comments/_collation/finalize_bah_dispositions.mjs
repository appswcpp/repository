import fs from "node:fs/promises";
import path from "node:path";

const workspace = process.cwd();
const collationDir = path.join(workspace, "Comments", "_collation");
const registerPath = path.join(collationDir, "bah_comment_register.json");
const responsePath = path.join(collationDir, "BAH_Draft_Review_Disposition_and_Rationale.md");

const resolutions = {
  "BAH-001": ["Accept", "Updated the Server-Agent configuration title, version, date, and shorthand identifier to the Version 2.0 draft-review values.", "Server-Agent configuration metadata"],
  "BAH-002": ["Accept", "Updated the Server-Agent configuration's base cPP reference to cPP_APP_SW_V2.0.", "Server-Agent configuration references"],
  "BAH-003": ["Accept", "Updated the Server-Agent configuration's Server module reference to MOD_Server_v2.0.", "Server-Agent configuration references"],
  "BAH-004": ["Accept", "Updated the Server-Agent configuration's Agent module reference to MOD_Agent_v2.0.", "Server-Agent configuration references"],
  "BAH-005": ["Accept with adaptation", "Retained Applicable Components for component allocation. Feature Dependent is now explicitly a condition of applicability, not an alternative allocation that can narrow coverage.", "Server-Agent configuration, allocation definitions and worked example"],
  "BAH-006": ["Accept with adaptation", "Clarified the two-stage model: a feature or selection determines whether an SFR is claimed; Applicable Components identifies every component with a concrete obligation once it is claimed.", "Server-Agent configuration, allocation definitions and worked example"],
  "BAH-007": ["Accept with adaptation", "Reframed the allocation rationale around allocation category plus feature-dependent condition, retained network-stack coverage independent of locality, and limited non-network IPC documentation to architecture-level protection unless an SFR or EA needs more detail.", "Server-Agent configuration, distributed TOE rationale"],
  "BAH-008": ["Accept with adaptation", "Specified element-level allocation. Components need satisfy only the SFR elements they implement, while the evaluation evidence jointly covers every allocated element and cannot be satisfied by a representative component without demonstrated equivalence.", "Server-Agent configuration, allocation rule and FPT_TUD_EXT.2 example"],
  "BAH-009": ["Accept", "Updated the Server configuration title, version, date, and shorthand identifier to Version 2.0 draft-review values.", "Server configuration metadata"],
  "BAH-010": ["Accept", "Updated the Server configuration's base cPP reference to cPP_APP_SW_V2.0.", "Server configuration references"],
  "BAH-011": ["Accept", "Updated the Server configuration's Server module reference to MOD_Server_v2.0.", "Server configuration references"],
  "BAH-012": ["Accept", "Updated Agent PP-Module metadata and revision history to Version 2.0 draft-review values.", "Agent PP-Module metadata"],
  "BAH-013": ["Accept", "Removed the /Agent suffix from FCO_CPC_EXT.1 because it is not an iteration.", "Agent PP-Module"],
  "BAH-014": ["Accept", "Updated Server PP-Module metadata and revision history to Version 2.0 draft-review values.", "Server PP-Module metadata"],
  "BAH-015": ["Accept", "Removed the inaccurate statement that FPT_AEX_EXT.1.3 contains a no-exceptions assignment; the cited base requirement has no such assignment.", "Server PP-Module, FPT_AEX_EXT.2/Server application note"],
  "BAH-016": ["Clarify with reviewer", "Retained the Server refinement because containerized Server payloads need evidence that the mandatory-access-control profile reaches the actual payload. The common platform test remains in the base cPP; the Server EA adds only the container-specific evidence.", "Server PP-Module and Supporting Document, FPT_AEX_EXT.2/Server"],
  "BAH-017": ["Accept", "Incorporated the TD1026 wording for UWP .NET applications and the non-UWP/non-Classic-Desktop case.", "Base cPP, FMT_MEC_EXT.1 Windows EA"],
  "BAH-018": ["Accept", "Recast the affected text as applying to managed runtime or application framework based TOEs.", "Base cPP, managed-runtime terminology"],
  "BAH-019": ["Accept", "Recast the affected text as applying to managed runtime or application framework based TOEs.", "Base cPP, managed-runtime terminology"],
  "BAH-020": ["Accept", "Clarified that Classic Desktop applications include those implemented in .NET.", "Base cPP, Windows EA"],
  "BAH-021": ["Accept", "Recast the affected text as applying to managed runtime or application framework based TOEs.", "Base cPP, managed-runtime terminology"],
  "BAH-022": ["Accept", "Narrowed the JIT/native-interface treatment to mechanisms within the TOE boundary.", "Base cPP, FPT_AEX_EXT.1"],
  "BAH-023": ["Accept", "Recast the affected text as applying to managed runtime or application framework based TOEs.", "Base cPP, managed-runtime terminology"],
  "BAH-024": ["Accept", "Limited third-party-library and runtime treatment to artifacts within the TOE boundary and removed the operational-environment runtime documentation burden.", "Base cPP, FPT_LIB_EXT.1"],
  "BAH-025": ["Accept", "Updated Agent Supporting Document metadata and revision history to Version 2.0 draft-review values.", "Agent Supporting Document metadata"],
  "BAH-026": ["Accept", "Updated the Agent Supporting Document's module reference to Version 2.0.", "Agent Supporting Document references"],
  "BAH-027": ["Accept", "Removed the /Agent suffix from FCO_CPC_EXT.1 throughout the Agent Supporting Document.", "Agent Supporting Document"],
  "BAH-028": ["Accept", "Removed the obsolete statement that the relevant SFR is an iteration defined by the module.", "Agent Supporting Document"],
  "BAH-029": ["Accept with adaptation", "Removed the unexplained first-type/second-type distinction. The TSS now identifies a selected protected registration channel, its relationship, FTP_DIT_EXT.1 claim, and security characteristics.", "Agent Supporting Document, FCO_CPC_EXT.1 TSS"],
  "BAH-030": ["Accept", "Made the channel-description activity conditional on selecting a channel protected according to FTP_DIT_EXT.1; no channel description is required for the no-channel selection.", "Agent Supporting Document, FCO_CPC_EXT.1 TSS"],
  "BAH-031": ["Accept with adaptation", "Added an explicit statement that an FTP_DIT_EXT.1-protected registration channel may operate over any untrusted network; no trusted-registration-network assumption is made.", "Agent PP-Module and Supporting Document, FCO_CPC_EXT.1"],
  "BAH-032": ["Accept", "Adopted the TD0594 wording so the negative test applies only where communication is possible but has not been explicitly enabled.", "Agent Supporting Document, FCO_CPC_EXT.1 Test 1.2"],
  "BAH-033": ["Accept", "Added the established one-Server test instruction for disabling components in turn and confirming communication ceases.", "Agent Supporting Document, FCO_CPC_EXT.1 Test 2"],
  "BAH-034": ["Accept", "Removed the Test 4 subtest that attempted to use a registration-only channel after registration. FCO pairing control is covered by Tests 1 and 2; protected-channel testing is covered by FTP_DIT_EXT.1.", "Agent Supporting Document, FCO_CPC_EXT.1 Test"],
  "BAH-035": ["Accept", "Removed Test 4. Post-registration steady-state channel behavior is covered by FTP_DIT_EXT.1 rather than adding a second FCO_CPC_EXT.1 activity.", "Agent Supporting Document, FCO_CPC_EXT.1 Test"],
  "BAH-036": ["Accept", "Updated the Server Supporting Document's CC and revision metadata.", "Server Supporting Document metadata"],
  "BAH-037": ["Accept", "Updated the Server Supporting Document's PP-Module reference to Version 2.0.", "Server Supporting Document references"],
  "BAH-038": ["Accept", "Removed the duplicate Server FMT_MEC Test 2 and retained the base cPP evaluation activity for configuration-storage behavior.", "Server Supporting Document, FMT_MEC_EXT.1/Server"],
  "BAH-039": ["Clarify with reviewer", "Retained the Server refinement and updated it for all claimed platforms by invoking the base Windows and macOS activities and adding the Linux-container mandatory-access-control check.", "Server Supporting Document, FPT_AEX_EXT.2/Server"],
  "BAH-040": ["Accept", "Refreshed the base cPP date and draft revision history to 2026, with matching 2026 updates across the review sources.", "Base cPP and review-source metadata"],
  "BAH-041": ["Accept", "Recast the affected text as applying to managed runtime or application framework based TOEs.", "Base cPP, managed-runtime terminology"],
  "BAH-042": ["Accept", "Recast the affected text as applying to managed runtime or application framework based TOEs.", "Base cPP, managed-runtime terminology"],
  "BAH-043": ["Accept", "Updated the trusted-update note so a managed runtime or application framework in the TOE boundary is covered by the TOE update mechanism.", "Base cPP, FPT_TUD_EXT.1"],
  "BAH-044": ["Accept", "Added the TD1050 statement allowing the third-party-library assignment to reference a vendor-provided SBOM.", "Base cPP, FPT_LIB_EXT.1 application note"],
  "BAH-045": ["Accept", "Removed the operational-environment runtime update classification and limited the update obligation to a runtime or framework within the TOE boundary.", "Base cPP, FPT_TUD_EXT.1"],
  "BAH-046": ["Accept", "Converted the communication peer to an explicit multi-selection of trusted IT product and TOE Component Instance. The ST selects every target type used by the TOE.", "Base cPP, FTP_DIT_EXT.1.1"],
  "BAH-047": ["Accept with adaptation", "Retained the base cPP obligation to identify non-network IPC and clarified in the Server-Agent configuration that the description is limited to the mechanism and architecture-level protection relied upon. Detailed implementation or configuration information is required only when an SFR or EA requires it.", "Base cPP and Server-Agent configuration, distributed-TOE IPC guidance"],
  "BAH-048": ["Clarify with reviewer", "Confirmed the intended outcome: a database service reached through a network stack, including loopback, is a transmitted-data endpoint. The ST identifies it as a TOE Component Instance or selected trusted IT product; in-process calls and direct local storage remain outside FTP_DIT_EXT.1. A loopback path is explicitly exercised where present.", "Base cPP, FTP_DIT_EXT.1 target selection and EA"],
  "BAH-049": ["Accept", "Applied the same explicit multi-selection of trusted IT product and TOE Component Instance in the extended-component definition.", "Base cPP, FTP_DIT_EXT.1 extended-component definition"],
};

const records = JSON.parse(await fs.readFile(registerPath, "utf8"));
for (const record of records) {
  const resolution = resolutions[record.id];
  if (!resolution) throw new Error(`No disposition defined for ${record.id}`);
  const [disposition, resolutionNotes, sourceUpdate] = resolution;
  record.status = "Resolved";
  record.disposition = disposition;
  record.owner = "AppSW-iTC";
  record.resolution_notes = resolutionNotes;
  record.source_update = sourceUpdate;
}
await fs.writeFile(registerPath, `${JSON.stringify(records, null, 2)}\n`, "utf8");

const groups = [...new Set(records.map((record) => record.analysis_group))].sort();
const escapeCell = (value) => String(value || "").replaceAll("|", "\\|").replaceAll("\n", " ");
const lines = [
  "# BAH Draft Review Disposition and Rationale",
  "",
  "All 49 BAH draft-review comments have been resolved in the next source revision. This register records the disposition, rationale, and principal source update for each comment so that the response does not have to be reconstructed from the revised documents.",
  "",
  "Disposition terms: **Accept** incorporates the requested change; **Accept with adaptation** preserves the requested outcome with revised wording or scope; **Clarify with reviewer** retains the AppSW-iTC position and states the rationale.",
];

for (const group of groups) {
  lines.push("", `## ${group}`, "", "| ID | Disposition | Response and rationale | Principal source update |", "| --- | --- | --- | --- |");
  for (const record of records.filter((item) => item.analysis_group === group)) {
    lines.push(`| ${record.id} | ${escapeCell(record.disposition)} | ${escapeCell(record.resolution_notes)} | ${escapeCell(record.source_update)} |`);
  }
}
lines.push("");
await fs.writeFile(responsePath, lines.join("\n"), "utf8");
console.log(`Updated ${records.length} dispositions in ${registerPath}`);
console.log(`Wrote ${responsePath}`);
