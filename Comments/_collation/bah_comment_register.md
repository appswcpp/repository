# BAH Draft Review Comment Register

Extracted 49 substantive PDF annotations from 8 commented review documents.

## Counts by document

| Document | Comments |
| --- | ---: |
| PP-Configuration-Server-Agent-v2.0-draft-review | 8 |
| PP-Configuration-Server-v2.0-draft-review | 3 |
| PP-Module-Agent-v2.0-draft-review | 2 |
| PP-Module-Server-v2.0-draft-review | 3 |
| SD-Application-Software-v2.0-draft-review | 8 |
| SD-Module-Agent-v2.0-draft-review | 11 |
| SD-Module-Server-v2.0-draft-review | 4 |
| cPP-Application-Software-v2.0-draft-review | 10 |

## Initial topic grouping

| Topic | Comments |
| --- | ---: |
| Clarification / rationale | 11 |
| Editorial / publication | 24 |
| Evaluation activity / testing | 4 |
| Requirement alignment | 8 |
| TOE architecture / communication | 2 |

## Analysis grouping

| Group | Comments |
| --- | ---: |
| Agent registration and communication tests | 7 |
| Agent terminology and SFR iteration cleanup | 3 |
| Distributed TOE allocation, IPC, and loopback scope | 8 |
| Managed runtime / application framework scope | 13 |
| Publication metadata and referenced versions | 14 |
| Server module alignment with the base cPP | 4 |

## Resolution progress — 2026-07-21

- **Resolved (49):** BAH-001–049. The complete disposition, rationale, and principal source update are recorded in `BAH_Draft_Review_Disposition_and_Rationale.md` and the `BAH Response` worksheet.
- **Decision input still needed (0):** None.
- **Implemented scope:** 2026 metadata and cross-references; CC reference refresh; TD1026 and TD1050 text; managed-runtime/framework TOE-boundary narrowing; Agent FCO terminology and evaluator-test corrections; removal of the duplicated Server FMT_MEC Test 2; modernization of the base and Server FPT_AEX evaluation activities, including an enforcing mandatory-access-control check for container payloads; clarified feature-dependent applicability versus Applicable Components allocation; explicit FTP_DIT_EXT.1 peer selection; loopback database-service scope and evaluator coverage; and architecture-level non-network IPC guidance.
- **Validation:** XML well-formedness and the uniqueness of the new FTP_DIT_EXT.1 identifiers passed; source-diff checks passed; and the updated Server-Agent configuration and Agent Supporting Document were rebuilt at Letter size and visually checked. The base cPP/SD PDF builder remains gated on a clean source worktree, so the edited base XML was not promoted or published from this worktree.

## Full register

### BAH-001 - PP-Configuration-Server-Agent-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:39:50
- Anchor: PP-Configuration for Enterprise Server Applications and Agent/Application Component(s), Version 1.0e, 2024-02-15 • As a shorthand reference, it can be identified as "CFG_APP-Server-Agent_V1.0e""
- Comment: update

### BAH-002 - PP-Configuration-Server-Agent-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:40:00
- Anchor: cPP_APP_SW_V1.1
- Comment: update

### BAH-003 - PP-Configuration-Server-Agent-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:40:06
- Anchor: MOD_Server_v1.1
- Comment: update

### BAH-004 - PP-Configuration-Server-Agent-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:40:14
- Anchor: MOD_Agent_v1.1
- Comment: update

### BAH-005 - PP-Configuration-Server-Agent-v2.0-draft-review (page 3)

- Topic: TOE architecture / communication
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:46:02
- Anchor: Feature Dependent The requirement applies only when the feature, selection, or objective requirement is claimed for the distributed TOE. The ST shall identify the TOE component or components that perform the relevant function, make the relevant selection, or rely on the relevant platform functionality.
- Comment: See Applicable Components comment

### BAH-006 - PP-Configuration-Server-Agent-v2.0-draft-review (page 3)

- Topic: Clarification / rationale
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:46:39
- Anchor: Applicable Components Every TOE component that performs the relevant function shall satisfy the requirement. The ST shall identify the components to which the requirement applies. This category does not exclude other TOE components from the base cPP; it identifies the TOE components that have concrete implementation obligations for the SFR because they perform the relevant function, make the relevant selection, or rely on the relevant platform functionality.
- Comment: I believe this and Feature Dependent can be combined to a single concept. The recommendation of Feature Dependent was this term has been used in other PPs already.

### BAH-007 - PP-Configuration-Server-Agent-v2.0-draft-review (page 3)

- Topic: Requirement alignment
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 16:10:23
- Anchor: The ST shall provide an SFR allocation rationale that identifies whether each claimed requirement is satisfied by all TOE components, by applicable TOE components that perform the relevant function, by at least one TOE component, as a feature dependent requirement, or by an allowed operational environment dependency. The ST shall describe all inter-component TOE communications and identify the mechanisms used to authorize and protect those communications. Communication between TOE components that uses a network interface or network protocol stack is treated as transmitted data for FTP_DIT_EXT.1 regardless of whether the route is loopback, same-host virtual networking, container networking, a LAN, or a WAN. Non- network local inter-process communication, such as named pipes, Unix domain sockets, shared memory, platform-brokered IPC, or equivalent mechanisms, shall be identified in the ST and mapped to the applicable base cPP controls, platform access controls, object permissions, isolation mechanisms, configuration controls, or operational guidance.
- Comment: See comments in the base PP

### BAH-008 - PP-Configuration-Server-Agent-v2.0-draft-review (page 3)

- Topic: Requirement alignment
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 16:15:53
- Anchor: Every TOE component that performs the relevant function shall satisfy the requirement. The
- Comment: It is possible that an SFR (e.g., FCO_CPC) is only partly met with one component and another component meets another part. This could be applied that the SFR must fully be met on both components. Recommend using the standard language for Feature Dependent only.

### BAH-009 - PP-Configuration-Server-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:38:30
- Anchor: cPP_APP_SW_V1.0
- Comment: update

### BAH-010 - PP-Configuration-Server-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:38:37
- Anchor: MOD_Server_v1.0
- Comment: update

### BAH-011 - PP-Configuration-Server-v2.0-draft-review (page 2)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:39:15
- Anchor: PP-Configuration for Enterprise Server Applications, Version 1.0e, 2024-02-15 • As a shorthand reference, it can be identified as "CFG_APP-Server_V1.0e""
- Comment: update

### BAH-012 - PP-Module-Agent-v2.0-draft-review (page 3)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:17:59
- Anchor: • PP-Module Reference: collaborative PP-Module for Agent Applications • PP-Module Version: 1.0e • PP-Module Date: 2023-02-15
- Comment: Update

### BAH-013 - PP-Module-Agent-v2.0-draft-review (page 5)

- Topic: Editorial / publication
- Analysis group: Agent terminology and SFR iteration cleanup
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:23:17
- Anchor: FCO_CPC_EXT.1/Agent
- Comment: Delete "/Agent" from all uses of this SFR as there is no need for a iteration.

### BAH-014 - PP-Module-Server-v2.0-draft-review (page 4)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 13:39:44
- Anchor: • PP-Module Reference: collaborative PP-Module for Server Applications • PP-Module Version: 1.0e • PP-Module Date: 2024-02-15
- Comment: Update

### BAH-015 - PP-Module-Server-v2.0-draft-review (page 9)

- Topic: Requirement alignment
- Analysis group: Server module alignment with the base cPP
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:07:18
- Anchor: The assignment in FPT_AEX_EXT.1.3 in the Collaborative Protection Profile for Application Software must be "no exceptions".
- Comment: the base PP does not seem to allow exceptions for this one.

### BAH-016 - PP-Module-Server-v2.0-draft-review (page 9)

- Topic: Requirement alignment
- Analysis group: Server module alignment with the base cPP
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:07:46
- Anchor: FPT_AEX_EXT.2.1/Server The application shall be compatible with security features provided by the platform vendor.
- Comment: Unsure added value of this requirement from the base PP. Perhaps it was more applicable previously.

### BAH-017 - SD-Application-Software-v2.0-draft-review (page 15)

- Topic: Editorial / publication
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-08 23:02:06
- Anchor: The evaluator shall determine and verify that Windows Universal Applications use either the Windows.Storage namespace, Windows.UI.ApplicationSettings namespace, or the IsolatedStorageSettings namespace for storing application specific settings. For .NET applications, the evaluator shall determine and verify that the application uses one of the locations listed in
- Comment: TD 1026 needs to be updated to "The evaluator shall determine and verify that Windows Universal Applications use either the Windows.Storage namespace, Windows. UI.ApplicationSettings namespace, or the IsolatedStorageSettings namespace for storing application specific settings. If a .NET application is implemented as a UWP application, it shall be evaluated using these UWP requirements. For .NET applications that do not use the UWP application model and do not operate as Classic Desktop applications, the evaluator shall determine and verify that the application uses one of the locations listed in"

### BAH-018 - SD-Application-Software-v2.0-draft-review (page 15)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:53:52
- Anchor: For applications that rely on managed runtimes or application frameworks
- Comment: Change to "For managed runtime or application framework based TOEs"

### BAH-019 - SD-Application-Software-v2.0-draft-review (page 15)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:54:57
- Anchor: guidance documentation contains any information necessary to configure If the TOE relies on a managed runtime or application framework,
- Comment: Change to "For managed runtime or application framework based TOEs, "

### BAH-020 - SD-Application-Software-v2.0-draft-review (page 16)

- Topic: Editorial / publication
- Analysis group: Managed runtime / application framework scope
- Annotation: Text; author: 525185; date: 2026-07-08 23:02:17
- Anchor: applications, the Monitor and
- Comment: TD1026 needs to be updated to add "(including those implemented in .NET)"

### BAH-021 - SD-Application-Software-v2.0-draft-review (page 18)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:56:07
- Anchor: If the application uses a managed runtime or application framework
- Comment: Change to "For managed runtime or application framework based TOEs "

### BAH-022 - SD-Application-Software-v2.0-draft-review (page 18)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 16:00:29
- Anchor: FFI, native plug-ins, or equivalent mechanisms, the evaluator shall verify that the TSS identifies those mechanisms and describes whether they are included in the TOE boundary, bundled with the TOE, or provided by the operational environment.
- Comment: Should only apply when part of the TOE boundary.

### BAH-023 - SD-Application-Software-v2.0-draft-review (page 22)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:56:45
- Anchor: If the TOE relies on managed runtimes or application frameworks
- Comment: Change to "For managed runtime or application framework based TOEs "

### BAH-024 - SD-Application-Software-v2.0-draft-review (page 22)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 16:04:10
- Anchor: the evaluator shall verify that the TSS identifies each runtime or framework bundled with the TOE, or required from the operational environment.
- Comment: Remove. Bundled with the TOE is same as within the TOE boundary. OE runtimes and app frameworks should not have libraries documented. Should only apply when part of the TOE boundary.

### BAH-025 - SD-Module-Agent-v2.0-draft-review (page 1)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:51:35
- Anchor: Common Criteria (CC) version 3
- Comment: update

### BAH-026 - SD-Module-Agent-v2.0-draft-review (page 3)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:52:54
- Anchor: collaborative PP-Module for Agent Applications, Version 1.1, 2022-08-16
- Comment: update

### BAH-027 - SD-Module-Agent-v2.0-draft-review (page 5)

- Topic: Editorial / publication
- Analysis group: Agent terminology and SFR iteration cleanup
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:12:26
- Anchor: FCO_CPC_EXT.1/Agent
- Comment: remove all use of "/Agent"

### BAH-028 - SD-Module-Agent-v2.0-draft-review (page 5)

- Topic: Editorial / publication
- Analysis group: Agent terminology and SFR iteration cleanup
- Annotation: Highlight; author: 525185; date: 2026-07-12 21:48:00
- Anchor: the relevant SFR iteration, if present, that specifies
- Comment: Delete. no more iterations defined by the Modules

### BAH-029 - SD-Module-Agent-v2.0-draft-review (page 5)

- Topic: Clarification / rationale
- Analysis group: Agent registration and communication tests
- Annotation: Highlight; author: 525185; date: 2026-07-12 21:49:49
- Anchor: First type: the TSS identifies the relevant SFR iteration, if present, that specifies the channel used. ◦ Second type: the TSS describes details of the channel and the mechanisms that it uses.
- Comment: Not clear what the difference is here. Perhaps remove if determined not to be needed.

### BAH-030 - SD-Module-Agent-v2.0-draft-review (page 5)

- Topic: TOE architecture / communication
- Analysis group: Agent registration and communication tests
- Annotation: Highlight; author: 525185; date: 2026-07-12 21:50:32
- Anchor: Describes
- Comment: This should be conditional as the 'no channel' option can be selected

### BAH-031 - SD-Module-Agent-v2.0-draft-review (page 6)

- Topic: Requirement alignment
- Analysis group: Agent registration and communication tests
- Annotation: Highlight; author: 525185; date: 2026-07-12 21:42:56
- Anchor: • identify any aspects of the channel can be modified by the operational environment in order to improve the channel security and shall describe how this modification can be achieved (e.g. generating a new key pair, or replacing a default public key certificate). As background for the examination of the registration channel description, it is noted that the requirements above are intended to ensure that administrators can make an accurate judgement of any risks that arise from the default registration process. Examples would be the use of self-signed certificates (i.e. certificates that are not chained to an external or local Certification Authority, manufacturer-issued certificates (where control over aspects such as revocation, or which devices are issued with recognised certificates, is outside the control of the operational environment), use of generic/non-unique keys (e.g. where the same key is present on more than one instance of a device), or well-known keys (i.e. where the confidentiality of the keys is not intended to be strongly protected – note that this does not imply there is a positive action or intention to publicise the keys).
- Comment: This seems to be related to the option from the NDcPP that allows "Registration may be performed over any untrusted network" from Figure 13. Not sure if this PP has been written to allow this per selections under FCO_CPC_EXT.1.2

### BAH-032 - SD-Module-Agent-v2.0-draft-review (page 6)

- Topic: Editorial / publication
- Analysis group: Agent registration and communication tests
- Annotation: Highlight; author: 525185; date: 2026-07-12 22:10:02
- Anchor: for which communication has not been explicitly enabled.
- Comment: Update to " for which communication is possible but has not been explicitly enabled" This was updated due to feedback on MDM PP in 2021 - TD0594. Note the reason in the TD is not exactly complete/accurate. The issue is that this test as written can require two TOE components that were never meant to communicate to try and communicate to satisfy this test.

### BAH-033 - SD-Module-Agent-v2.0-draft-review (page 6)

- Topic: Editorial / publication
- Analysis group: Agent registration and communication tests
- Annotation: Text; author: 525185; date: 2026-07-12 22:13:40
- Anchor: disabled component.
- Comment: Add "In situations where one component acts as the "Server" for all other components, the test would involve disabling the components in turn on the Server and ensuring that the TOE no longer communicates with disabled components." This was updated due to feedback on MDM PP in 2021 - TD0594. Note the reason in the TD is not exactly complete/accurate. The issue is that the original test as written assumes that either side can disable the communication. Note still not 100% happy with the way this is written but it is how it has been used in MDM since.

### BAH-034 - SD-Module-Agent-v2.0-draft-review (page 7)

- Topic: Evaluation activity / testing
- Analysis group: Agent registration and communication tests
- Annotation: Highlight; author: 525185; date: 2026-07-12 22:18:46
- Anchor: If the registration channel is not subsequently used for communication between TOE components, then the evaluator shall confirm that the registration channel can no longer be used after the registration process has completed, by attempting to use the channel to communicate with each of the endpoints after registration has completed.
- Comment: There could be a lot of issues trying to invoke a communication channel that is only meant during configuration of a TOE, or only through an interface that limits when or how this channel is enacted. If the channel was considered secure per the FTP_DIT_EXT.1 requirement, unsure what this will satisfy. There is not a test exactly like this in the other PPs. There is a test for an unsecure channel that should not be used but that is not an option in this PP with the selections in CPC_EXT.1.2. Recommend removing this subtest and maybe the whole Test 4.

### BAH-035 - SD-Module-Agent-v2.0-draft-review (page 7)

- Topic: Evaluation activity / testing
- Analysis group: Agent registration and communication tests
- Annotation: Highlight; author: 525185; date: 2026-07-12 22:25:47
- Anchor: the registration channel is subsequently used for communication between TOE components then the evaluator shall confirm
- Comment: This sub-test seems to be for the TOE post registration which would be handled by the guidance and testing of FTP_DIT_EXT.1. This SFR is for the TOE during registration. The first sub-test of Test 3 ensures that the guidance and testing of the registration channel is tested as part of FTP_DIT_EXT.1. Thus, registration and post-registration channels are both being tested as part of FTP_DIT_EXT. Not sure if this is needed. Other PPs don't seem to have a test exactly like this.

### BAH-036 - SD-Module-Server-v2.0-draft-review (page 1)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:51:24
- Anchor: Common Criteria (CC) version 3 and
- Comment: update

### BAH-037 - SD-Module-Server-v2.0-draft-review (page 3)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-10 14:52:38
- Anchor: collaborative PP-Module for Server Applications, Version 1.1, 2022-08-16
- Comment: update

### BAH-038 - SD-Module-Server-v2.0-draft-review (page 6)

- Topic: Evaluation activity / testing
- Analysis group: Server module alignment with the base cPP
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:02:17
- Anchor: Test 2: The evaluator shall run the application while monitoring it with the following platform specific tools and make changes to its configuration. The evaluator shall verify that the tool logs show corresponding changes to the locations identified in the TSS for storage of configuration data. The following platform specific tools and procedures must be used: ◦ Windows: SystInternal tool ProcMon ▪ The evaluator shall run the application while monitoring it with the SysInternal tool ProcMon and make changes to its configuration. The evaluator shall verify that ProcMon logs show corresponding changes to the locations identified in the TSS for storage of configuration data. ◦ Linux or macOS: strace (or equivalent utility) ▪ The evaluator shall run the application while monitoring it with the utility strace. The evaluator shall make security-related changes to its configuration. The evaluator shall verify that strace logs corresponding changes to configuration files that reside in /etc (for system-specific configuration) or in the user’s home directory (for user-specific configuration).
- Comment: This test isn't really aligned with this SFR's wording and seems mostly a replication of FMT_MEC_EXT.1 from the base PP. The base PP and SFR goes more into storage location. Without these further context, this EA would have issues being met when configuration options are stored internally. Recommend removing and relying on base PP EA only. Test 1 fully covers SFR wording.

### BAH-039 - SD-Module-Server-v2.0-draft-review (page 7)

- Topic: Evaluation activity / testing
- Analysis group: Server module alignment with the base cPP
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:09:11
- Anchor: 2.4.1.1.1. TSS No activities specified. 2.4.1.1.2. Operational Guidance No activities specified. 2.4.1.1.3. Test The evaluator shall configure the platform in the ascribed manner and carry out one of the prescribed tests: • Test 1: [conditional] If the application is being tested on Windows, the evaluator shall ensure that the application can run successfully with Windows Defender Exploit Guard Exploit Protection configured with the following minimum mitigations enabled; Control Flow Guard (CFG), Randomize memory allocations (Bottom-Up ASLR), Export address filtering (EAF), Import address filtering (IAF), and Data Execution Prevention (DEP). The following link describes how to enable Exploit Protection, https://docs.microsoft.com/en-us/windows/security/threat- protection/microsoft-defender-atp/enable-exploit-protection. • Test 2: [conditional] If the application is being tested on Linux, the evaluator shall ensure that the application can successfully run on a system with SELinux (or equivalent platform vendor recommended security features) enabled and enforcing. • Test 3: [conditional] If the application is being tested on macOS, the evaluator shall ensure that the application can successfully run on a system without disabling System Integrity Protection (SIP).
- Comment: As stated in the Module: "Unsure added value of this requirement from the base PP. Perhaps it was more applicable previously." If there is value, then I think a test is needed for all OS's as is the case with the base PP.

### BAH-040 - cPP-Application-Software-v2.0-draft-review (page 1)

- Topic: Editorial / publication
- Analysis group: Publication metadata and referenced versions
- Annotation: Highlight; author: 525185; date: 2026-07-08 22:49:37
- Anchor: Version: 2.0 2025-06-16
- Comment: Update dates across all documents to 2026

### BAH-041 - cPP-Application-Software-v2.0-draft-review (page 18)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:36:06
- Anchor: For applications that rely on managed runtimes or application frameworks,
- Comment: Change to "For managed runtime or application framework based TOEs, "

### BAH-042 - cPP-Application-Software-v2.0-draft-review (page 20)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:35:47
- Anchor: or by a platform vendor who may be able to guarantee support platform APIs. For applications that rely on managed runtimes or application frameworks,
- Comment: Change to "For managed runtime or application framework based TOEs, "

### BAH-043 - cPP-Application-Software-v2.0-draft-review (page 21)

- Topic: Editorial / publication
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-08 22:16:41
- Anchor: code. If the TOE includes or bundles a managed runtime or application framework, the update mechanism description shall identify whether updates to the runtime or framework are TOE updates,
- Comment: This should say: "the update mechanism described shall cover updates to the managed runtime or application framework"

### BAH-044 - cPP-Application-Software-v2.0-draft-review (page 21)

- Topic: Clarification / rationale
- Analysis group: Managed runtime / application framework scope
- Annotation: Text; author: 525185; date: 2026-07-08 22:53:08
- Anchor: dependencies, plug-ins, native interface libraries, and other executable dependency artifacts packaged with the TOE. FPT_TUD_EXT.1 Support for Trusted Updates
- Comment: Add TD1050 paragraph to App Note: "It is acceptable to complete the Assignment with a reference to the vendor-provided SBOM instead of listing the libraries in the ST."

### BAH-045 - cPP-Application-Software-v2.0-draft-review (page 21)

- Topic: Requirement alignment
- Analysis group: Managed runtime / application framework scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:38:48
- Anchor: description shall identify whether updates to the runtime or framework are TOE updates, application dependency updates, platform updates, or operational environment updates.
- Comment: All of these would be outside of the TOE and would not be applicable to the SFR. Recommend deleting and updating per above comment

### BAH-046 - cPP-Application-Software-v2.0-draft-review (page 22)

- Topic: Requirement alignment
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-08 22:50:13
- Anchor: trusted IT product or TOE component.
- Comment: [selection: trusted IT product, TOE component]

### BAH-047 - cPP-Application-Software-v2.0-draft-review (page 22)

- Topic: Editorial / publication
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:48:18
- Anchor: TOE components is not sufficient rationale for omitting protection of transmitted data. If TOE components communicate using non-network local inter-process communication, such as named pipes, Unix domain sockets, shared memory, platform-brokered IPC, or equivalent mechanisms, the ST shall identify the mechanism and describe the base cPP requirements, platform access controls, object permissions, isolation mechanisms, configuration controls, or operational guidance that protect the communication path and restrict access to authorized TOE components.
- Comment: This seems getting into a level of detail we haven't seen in other PPs to date. Would be good to have quick call for the need to describe this level of design detail. If this is purely to justify why something does not need to have an encrypted connection, unsure if this needs to be described in the ST.

### BAH-048 - cPP-Application-Software-v2.0-draft-review (page 22)

- Topic: Editorial / publication
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-10 15:51:52
- Anchor: this loopback,
- Comment: If a TOE component installs a database and uses the loopback to communicate with that database and is the only component communicating with that database, this seems to now mandate encryption to that database. Understand this might be coming from NIAP's concern about people getting around requirements by installing a distributed TOE all on one machine. But is this the intended result.

### BAH-049 - cPP-Application-Software-v2.0-draft-review (page 69)

- Topic: Requirement alignment
- Analysis group: Distributed TOE allocation, IPC, and loopback scope
- Annotation: Highlight; author: 525185; date: 2026-07-08 22:51:26
- Anchor: trusted IT product or TOE component.
- Comment: [selection: trusted IT product, TOE component]
