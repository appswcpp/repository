# Server / Agent Explanatory Clauses for Next Revision

## Purpose

Capture clarifying language for the next App SW cPP revision discussion. These clauses are intended to preserve the base cPP plus module composition model while giving labs clearer implementation expectations for multi-component software solutions.

## Base cPP and Module Composition

The PP-Configuration remains the conformance mechanism. Each TOE component is subject to the base cPP. The Server and Agent modules add role-specific requirements for TOE components that perform those roles; they do not replace or bypass the base cPP.

Suggested clause:

> Each TOE component shall be identified in the ST and mapped to the base cPP and, where applicable, to the Server Module, Agent Module, or both according to the role or roles performed by that component.

Suggested explanatory note:

> The Server and Agent modules are role-based extensions to the base cPP. A TOE component cannot claim only a Server or Agent module without also being within the scope of the base cPP. Not every base cPP SFR behavior is necessarily implemented by every TOE component, but every TOE component shall be accounted for in the ST.

## Server and Agent Role Semantics

The current Server / Agent terminology should be preserved for now to avoid community churn, but the terms should be defined broadly enough to avoid client/server, endpoint-agent, or protocol-direction assumptions.

Suggested clause:

> The terms Server Application and Agent Application describe TOE component roles for purposes of this PP-Configuration. They do not imply network client/server directionality, hosting relationship, privilege model, deployment topology, or that communication is initiated by one role rather than the other. A TOE component may perform one or both roles if identified in the ST.

Suggested Server role language:

> A Server Application is a TOE component that establishes, authorizes, configures, coordinates, brokers, manages, or otherwise governs security-relevant relationships with other TOE components.

Suggested Agent role language:

> An Agent Application is a TOE component that participates in a security-relevant TOE relationship governed, authorized, configured, coordinated, brokered, or managed by a Server Application.

## API and Interface Directionality

The PP should not assume that Agents call Server APIs. In many enterprise solutions, the Server role may call APIs exposed by Agent components, communication may be brokered, or both roles may expose and consume interfaces.

Suggested clause:

> Server and Agent roles do not imply API call direction. A Server Application may expose APIs used by Agent Applications, call APIs exposed by Agent Applications, exchange messages through a broker, or use other TOE-defined interface mechanisms. The ST shall identify the TOE components involved in each security-relevant inter-component communication path and the mechanisms used to authorize and protect that communication.

## Implementation Table Framing

The implementation table should be framed as evaluator and ST-author guidance for applying the base cPP plus module composition model, not as a separate distributed TOE conformance methodology.

Suggested clause:

> The implementation table provides guidance for consistently applying base cPP and module SFRs across separately deployed TOE components. It does not create a separate conformance model and does not permit any TOE component to bypass the base cPP.

Suggested Feature Dependent explanation:

> A "Feature Dependent" SFR or SFR element is fulfilled only where the relevant feature is implemented by a distributed TOE component. If it is included in the ST, the ST maps every implementing component to the SFR element or elements it implements. A feature, selection, or objective condition may control inclusion, but does not omit an implementing component from required coverage.

## FTP_DIT_EXT.1 and FPT_ITT.1 Replacement

`FTP_DIT_EXT.1` should replace the module-specific `FPT_ITT.1/Server` and `FPT_ITT.1/Agent` approach for protection of data transmitted between TOE components. This better matches the App SW architecture because transport protection should be based on the communication path, protocol, and TOE/platform implementation behavior rather than on Server or Agent role labels.

Suggested clause:

> Protection of data transmitted between TOE components is addressed by `FTP_DIT_EXT.1` in the base cPP. Where TOE components exchange TSF data, sensitive data, or other data covered by the requirement, the ST shall identify the communication path, the TOE components involved, the protocol or mechanism used, and whether the protection is implemented by the TOE, invoked from the platform, or provided through another allowed PP-Configuration dependency.

Suggested module impact:

> The Server and Agent modules should not define separate `FPT_ITT.1` SFRs. Module text and application notes should instead point to `FTP_DIT_EXT.1` for protection of transmitted data between TOE components.

Suggested IPsec/platform note:

> `FTP_DIT_EXT.1` should allow inter-component TOE communications to be protected using the same architectural options available for external transmitted data, including TOE-implemented protocols, platform-provided protocols, and IPsec where allowed by the applicable PP-Configuration or package dependency.

## FCO_CPC_EXT.1 Relationship to FTP_DIT_EXT.1

`FCO_CPC_EXT.1` should be shaped by the `FTP_DIT_EXT.1` architecture. It should address whether communication between TOE components is enabled, disabled, registered, authorized, enrolled, or otherwise controlled; it should not duplicate the transport-protection function now handled by `FTP_DIT_EXT.1`.

Suggested clause:

> `FCO_CPC_EXT.1` addresses control of component participation and communication relationships, including enabling, disabling, registration, enrollment, authorization, or other TOE-defined control over whether TOE components may communicate. Protection of data transmitted over those communication paths is addressed by `FTP_DIT_EXT.1`.

## X.509 Package Alignment

Module-specific X.509 SFRs should be removed if the base cPP brings in the updated X.509 package.

Suggested clause:

> Certificate validation and certificate path processing requirements for trusted channels, inter-component communication, and other certificate-authenticated protocols are addressed by the X.509 package selected through the base cPP, where applicable. The Server and Agent modules do not define separate X.509 SFRs.

Suggested implementation table note:

> Where inter-component communication uses certificate-authenticated protocols, the applicable X.509 package requirements are claimed according to the protocol and component behavior.

## Implementation Scope

The remaining revision work can be scoped into the following edit buckets.

### 1. Terminology Cleanup

Implement now:

* Define `TOE component` as a separately deployed portion of the TOE that is identified in the ST and mapped to applicable base cPP and module SFRs.
* Replace `TOE parts` with `TOE components`.
* Replace stale references to `Enterprise Agent` terminology with `Agent Application`, `Agent`, or `TOE component`, depending on context.
* Preserve `Server` and `Agent` nomenclature for this revision unless the iTC separately approves a rename.
* Add explanatory text that Server and Agent are role labels and do not imply protocol direction, API caller/callee behavior, deployment topology, or hosting relationship.

### 2. PP-Configuration Composition Model

Implement now:

* Clarify that every TOE component is within the scope of the base cPP.
* Clarify that Server and Agent modules are role-based extensions to the base cPP, not alternatives to it.
* Update text that currently says a component may map to the base PP, Server Module, Agent Module, or a combination so that it says each TOE component maps to the base cPP and, where applicable, to Server, Agent, or both.

### 3. FTP_DIT_EXT.1-Based Transport Protection

Implement now:

* Remove `FPT_ITT.1/Server` and `FPT_ITT.1/Agent` from the modules.
* Update module application notes and implementation mapping so inter-component transmitted data protection is handled by `FTP_DIT_EXT.1`.
* Update `FTP_DIT_EXT.1` selections and application notes to cover intra-TOE component communication.
* Ensure `FTP_DIT_EXT.1` allows TOE-implemented protocols, platform-provided protocols, and IPsec where allowed by the applicable PP-Configuration or package dependency.
* Clean up current `FTP_DIT_EXT.1` application notes so they consistently address external trusted IT products and intra-TOE component communication.

### 4. FCO_CPC_EXT.1 Refocus

Implement now:

* Keep `FCO_CPC_EXT.1` focused on control of component participation and communication relationships.
* Remove or avoid transport-protection language that duplicates `FTP_DIT_EXT.1`.
* Do not represent `FCO_CPC_EXT.1` as a Server or Agent iteration; component participation control is addressed by the single SFR and mapped to responsible TOE Components.
* Update the implementation mapping to list `FCO_CPC_EXT.1` and map its enablement, registration, and disablement elements separately.

### 5. X.509 Module Removal

Implement now:

* Remove `FIA_X509_EXT.1/ITT/Server` and `FIA_X509_EXT.1/ITT/Agent` from the modules.
* Remove corresponding module dependencies, application notes, implementation mapping rows, and SD assurance activities.
* Add pointers to the X.509 package selected through the base cPP where certificate-authenticated protocols are used.

### 6. FMT_SMF.1/Server Cleanup

Implement now:

* Revise the mandatory Server management item for communication configuration so it supports configuration of:
  * communication with trusted IT entities outside the TOE; and/or
  * communication with TOE components.
* Account for cases where communication configuration is performed during installation rather than through runtime management.
* Avoid forcing a trusted IT entity claim where the configured communication is only with TOE components.

### 7. Implementation Mapping / Allocation Table

Implement now:

* Reframe the table as implementation guidance for applying the base cPP plus module composition model, not as a separate distributed TOE conformance model.
* Record the feature, selection, objective, or other claim condition separately so that it controls whether the SFR is included in the ST; when included, use the NDcPP `Feature Dependent` allocation where the relevant feature is implemented.
* Remove `justify why the requirement does not apply to other TOE components`.
* Explain that `Feature Dependent` does not exclude a TOE component from the base cPP; it identifies each component that implements the relevant feature or SFR element, makes the relevant selection, or relies on the relevant platform functionality.
* Revisit `TOE as a Whole` entries, especially `FPT_IDV_EXT.1` and `FPT_TUD_EXT.1`, to ensure they do not obscure per-component versioning and update expectations.
* Review `FCS_` allocations and clarify that they are `Feature Dependent` because cryptographic behavior follows the component that performs, invokes, or claims the cryptographic function.
* For mandatory base SFRs with `no` selections, clarify whether each TOE component claims the SFR with the relevant selection or whether the mapping guidance identifies the SFR as not concretely implemented by components that do not perform the function.

### 8. Supporting Documents

Implement later or in a separate pass:

* Update stale Server and Agent SD content after the module SFR changes are settled.
* Remove SD assurance activities for deleted X.509 and FPT_ITT requirements.
* Align SDs with XML source format if the revision requires generated SDs rather than maintained adoc-only SDs.

### 9. TD and Final Document Hygiene

Implement in final integration pass:

* Implement all App SW 2.0 TDs that are not already incorporated.
* Check whether `ae` appears unexpectedly in final generated documents.
* Updated CC references from 3.1 to CC:2022 in modules and PP-Configurations.
* Confirm whether the crypto catalogue should be reproduced directly, following the GPCP approach, rather than linked by reference.
