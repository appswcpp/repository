# BAH Draft Review Disposition and Rationale

All 49 BAH draft-review comments have been resolved in the next source revision. This register records the disposition, rationale, and principal source update for each comment so that the response does not have to be reconstructed from the revised documents.

Disposition terms: **Accept** incorporates the requested change; **Accept with adaptation** preserves the requested outcome with revised wording or scope; **Clarify with reviewer** retains the AppSW-iTC position and states the rationale.

## Agent registration and communication tests

| ID | Disposition | Response and rationale | Principal source update |
| --- | --- | --- | --- |
| BAH-029 | Accept with adaptation | Removed the unexplained first-type/second-type distinction. The TSS now identifies a selected protected registration channel, its relationship, FTP_DIT_EXT.1 claim, and security characteristics. | Agent Supporting Document, FCO_CPC_EXT.1 TSS |
| BAH-030 | Accept | Made the channel-description activity conditional on selecting a channel protected according to FTP_DIT_EXT.1; no channel description is required for the no-channel selection. | Agent Supporting Document, FCO_CPC_EXT.1 TSS |
| BAH-031 | Accept with adaptation | Added an explicit statement that an FTP_DIT_EXT.1-protected registration channel may operate over any untrusted network; no trusted-registration-network assumption is made. | Agent PP-Module and Supporting Document, FCO_CPC_EXT.1 |
| BAH-032 | Accept | Adopted the TD0594 wording so the negative test applies only where communication is possible but has not been explicitly enabled. | Agent Supporting Document, FCO_CPC_EXT.1 Test 1.2 |
| BAH-033 | Accept | Added the established one-Server test instruction for disabling components in turn and confirming communication ceases. | Agent Supporting Document, FCO_CPC_EXT.1 Test 2 |
| BAH-034 | Accept | Removed the Test 4 subtest that attempted to use a registration-only channel after registration. FCO pairing control is covered by Tests 1 and 2; protected-channel testing is covered by FTP_DIT_EXT.1. | Agent Supporting Document, FCO_CPC_EXT.1 Test |
| BAH-035 | Accept | Removed Test 4. Post-registration steady-state channel behavior is covered by FTP_DIT_EXT.1 rather than adding a second FCO_CPC_EXT.1 activity. | Agent Supporting Document, FCO_CPC_EXT.1 Test |

## Agent terminology and SFR iteration cleanup

| ID | Disposition | Response and rationale | Principal source update |
| --- | --- | --- | --- |
| BAH-013 | Accept | Removed the /Agent suffix from FCO_CPC_EXT.1 because it is not an iteration. | Agent PP-Module |
| BAH-027 | Accept | Removed the /Agent suffix from FCO_CPC_EXT.1 throughout the Agent Supporting Document. | Agent Supporting Document |
| BAH-028 | Accept | Removed the obsolete statement that the relevant SFR is an iteration defined by the module. | Agent Supporting Document |

## Distributed TOE allocation, IPC, and loopback scope

| ID | Disposition | Response and rationale | Principal source update |
| --- | --- | --- | --- |
| BAH-005 | Accept with adaptation | Retained Applicable Components for component allocation and added a plain-language rationale. Feature Dependent explains why an SFR is included in the ST; Applicable Components identifies every component that must demonstrate its allocated SFR element once it is included. The configuration now separates claim condition, component allocation, and permitted operational-environment contribution so a claim condition cannot narrow component coverage. | Server-Agent configuration, allocation rationale, required ST mapping, and worked example |
| BAH-006 | Accept with adaptation | Clarified the two-stage model with a worked update example and a required ST mapping: a feature, selection, or objective claim determines whether an SFR is included; Applicable Components identifies the components responsible for the allocated elements. It is not a new SFR type or an additional optionality mechanism. | Server-Agent configuration, allocation rationale, ST mapping, and worked example |
| BAH-007 | Accept with adaptation | Reframed the allocation rationale around allocation category plus feature-dependent condition and retained network-stack coverage independent of locality. The non-network IPC documentation and protection rationale is now addressed by the objective FPT_IPC_EXT.1 rather than by a mandatory allocation rule. | Server-Agent configuration and base cPP, distributed TOE rationale |
| BAH-008 | Accept with adaptation | Specified element-level allocation and added a plain-language update example. Components satisfy only the SFR elements they implement, while the evaluation evidence jointly covers every allocated element; a Server-image test does not satisfy an Agent update path without demonstrated equivalent implementation, configuration, and execution context. Permitted Runtime Replica scale-out is now tied to a minimum evaluated configuration, with separate coverage for new connections or security-relevant differences. | Server-Agent configuration, allocation rationale, minimum evaluated configuration, and FPT_TUD_EXT.2 example |
| BAH-046 | Accept | Converted the communication peer to an explicit multi-selection of trusted IT product and TOE Component Instance. The ST selects every target type used by the TOE. | Base cPP, FTP_DIT_EXT.1.1 |
| BAH-047 | Accept with adaptation | Moved the non-network IPC identification and protection rationale from the mandatory FTP_DIT_EXT.1 application note to the objective FPT_IPC_EXT.1. The Server-Agent configuration directs non-network IPC protection to that objective; its Evaluation Activities identify the mechanism and architecture-level protection relied upon. | Base cPP FPT_IPC_EXT.1 and Server-Agent configuration, distributed-TOE IPC guidance |
| BAH-048 | Clarify with reviewer | Aligned the cPP with the confirmed NIAP AppSW v2.0 scope: a database service reached only through the platform loopback interface is not an FTP_DIT_EXT.1 transmitted-data endpoint and is not separately tested. This boundary does not assume that local users, processes, or localhost traffic are trusted; it only does not create an evaluated trusted-channel claim in this cPP version. In-scope network-mediated communications to a trusted IT product or TOE Component Instance remain covered. In-process calls and direct local storage remain outside FTP_DIT_EXT.1; non-network IPC is addressed by the FPT_IPC_EXT.1 objective. | Base cPP, FTP_DIT_EXT.1 target selection and EA |
| BAH-049 | Accept | Applied the same explicit multi-selection of trusted IT product and TOE Component Instance in the extended-component definition. | Base cPP, FTP_DIT_EXT.1 extended-component definition |

## Managed runtime / application framework scope

| ID | Disposition | Response and rationale | Principal source update |
| --- | --- | --- | --- |
| BAH-017 | Accept | Incorporated the TD1026 wording for UWP .NET applications and the non-UWP/non-Classic-Desktop case. | Base cPP, FMT_MEC_EXT.1 Windows EA |
| BAH-018 | Accept | Recast the affected text as applying to managed runtime or application framework based TOEs. | Base cPP, managed-runtime terminology |
| BAH-019 | Accept | Recast the affected text as applying to managed runtime or application framework based TOEs. | Base cPP, managed-runtime terminology |
| BAH-020 | Accept | Clarified that Classic Desktop applications include those implemented in .NET. | Base cPP, Windows EA |
| BAH-021 | Accept | Recast the affected text as applying to managed runtime or application framework based TOEs. | Base cPP, managed-runtime terminology |
| BAH-022 | Accept | Narrowed the JIT/native-interface treatment to mechanisms within the TOE boundary. | Base cPP, FPT_AEX_EXT.1 |
| BAH-023 | Accept | Recast the affected text as applying to managed runtime or application framework based TOEs. | Base cPP, managed-runtime terminology |
| BAH-024 | Accept | Limited third-party-library and runtime treatment to artifacts within the TOE boundary and removed the operational-environment runtime documentation burden. | Base cPP, FPT_LIB_EXT.1 |
| BAH-041 | Accept | Recast the affected text as applying to managed runtime or application framework based TOEs. | Base cPP, managed-runtime terminology |
| BAH-042 | Accept | Recast the affected text as applying to managed runtime or application framework based TOEs. | Base cPP, managed-runtime terminology |
| BAH-043 | Accept | Updated the trusted-update note so a managed runtime or application framework in the TOE boundary is covered by the TOE update mechanism. | Base cPP, FPT_TUD_EXT.1 |
| BAH-044 | Accept | Added the TD1050 statement allowing the third-party-library assignment to reference a vendor-provided SBOM. | Base cPP, FPT_LIB_EXT.1 application note |
| BAH-045 | Accept | Removed the operational-environment runtime update classification and limited the update obligation to a runtime or framework within the TOE boundary. | Base cPP, FPT_TUD_EXT.1 |

## Publication metadata and referenced versions

| ID | Disposition | Response and rationale | Principal source update |
| --- | --- | --- | --- |
| BAH-001 | Accept | Updated the Server-Agent configuration title, version, date, and shorthand identifier to the Version 2.0 draft-review values. | Server-Agent configuration metadata |
| BAH-002 | Accept | Updated the Server-Agent configuration's base cPP reference to cPP_APP_SW_V2.0. | Server-Agent configuration references |
| BAH-003 | Accept | Updated the Server-Agent configuration's Server module reference to MOD_Server_v2.0. | Server-Agent configuration references |
| BAH-004 | Accept | Updated the Server-Agent configuration's Agent module reference to MOD_Agent_v2.0. | Server-Agent configuration references |
| BAH-009 | Accept | Updated the Server configuration title, version, date, and shorthand identifier to Version 2.0 draft-review values. | Server configuration metadata |
| BAH-010 | Accept | Updated the Server configuration's base cPP reference to cPP_APP_SW_V2.0. | Server configuration references |
| BAH-011 | Accept | Updated the Server configuration's Server module reference to MOD_Server_v2.0. | Server configuration references |
| BAH-012 | Accept | Updated Agent PP-Module metadata and revision history to Version 2.0 draft-review values. | Agent PP-Module metadata |
| BAH-014 | Accept | Updated Server PP-Module metadata and revision history to Version 2.0 draft-review values. | Server PP-Module metadata |
| BAH-025 | Accept | Updated Agent Supporting Document metadata and revision history to Version 2.0 draft-review values. | Agent Supporting Document metadata |
| BAH-026 | Accept | Updated the Agent Supporting Document's module reference to Version 2.0. | Agent Supporting Document references |
| BAH-036 | Accept | Updated the Server Supporting Document's CC and revision metadata. | Server Supporting Document metadata |
| BAH-037 | Accept | Updated the Server Supporting Document's PP-Module reference to Version 2.0. | Server Supporting Document references |
| BAH-040 | Accept | Refreshed the base cPP date and draft revision history to 2026, with matching 2026 updates across the review sources. | Base cPP and review-source metadata |

## Server module alignment with the base cPP

| ID | Disposition | Response and rationale | Principal source update |
| --- | --- | --- | --- |
| BAH-015 | Accept | Removed the inaccurate statement that FPT_AEX_EXT.1.3 contains a no-exceptions assignment; the cited base requirement has no such assignment. | Server PP-Module, FPT_AEX_EXT.2/Server application note |
| BAH-016 | Clarify with reviewer | Retained the Server refinement because containerized Server payloads need evidence that the mandatory-access-control profile reaches the actual payload. The common platform test remains in the base cPP; the Server EA adds only the container-specific evidence. | Server PP-Module and Supporting Document, FPT_AEX_EXT.2/Server |
| BAH-038 | Accept | Removed the duplicate Server FMT_MEC Test 2 and retained the base cPP evaluation activity for configuration-storage behavior. | Server Supporting Document, FMT_MEC_EXT.1/Server |
| BAH-039 | Clarify with reviewer | Retained the Server refinement and updated it for all claimed platforms by invoking the base Windows and macOS activities and adding the Linux-container mandatory-access-control check. | Server Supporting Document, FPT_AEX_EXT.2/Server |
