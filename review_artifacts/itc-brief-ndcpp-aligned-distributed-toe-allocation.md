# iTC Discussion Brief: NDcPP-Aligned Distributed-TOE Requirement Allocation

**Meeting purpose:** Confirm the AppSW-iTC's replacement of the bespoke _Applicable Components_ label with the NDcPP distributed-TOE allocation vocabulary, while preserving the element-level mapping and Evaluation Activity (EA) coverage controls that motivated the original label.

**Status:** Meeting draft; reflects the current uncommitted source revision. It is not a published PP position until the iTC approves the text and the revision is published.

**Recommended outcome:** Approve the three-term allocation model below, approve the separation of claim condition from component allocation, and retain the mapping and coverage guardrails. No fourth allocation category is needed.

## 1. The question for the iTC

The narrow question is not whether AppSW needs to weaken or broaden distributed-TOE coverage. It is whether the PP should use a separate term—_Applicable Components_—to express which components implement a requirement, or should use the established NDcPP term _Feature Dependent_ with enough normative detail to prevent a coverage escape.

The proposed answer is:

> Use only **All Components**, **At Least One Component**, and **Feature Dependent** as component-allocation categories. Record any feature, selection, or objective that controls whether an SFR enters the ST as a **separate claim condition**. For a claimed Feature Dependent SFR or SFR element, map every implementing TOE Component to the element(s) it implements and retain all required coverage.

This adopts NDcPP vocabulary without discarding the protection intended by the former AppSW wording.

## 2. Executive summary

The former _Applicable Components_ category was introduced for a sound reason: a distributed AppSW TOE may contain distinct Server, Agent, service, helper, or update components, and a component that implements a claimed security function should not disappear from the evaluation merely because another component implements a similar function. The concern was particularly acute for different images, packages, configurations, interfaces, protected channels, and update paths.

BAH correctly identified that this category substantially overlapped with the already-recognized NDcPP term _Feature Dependent_. Retaining both terms risks making readers believe that they express different kinds of optionality, or that a multi-element SFR must be satisfied in full by every component that participates in any part of it.

The revision therefore removes the separate label but retains the substance:

| Question | Controlling concept | Result |
| --- | --- | --- |
| Is the SFR included in the ST? | Claim condition | A feature, selection, objective, or other rule controls inclusion where the applicable SFR permits it. |
| Which component implements each included SFR element? | Component allocation | _All Components_, _At Least One Component_, or _Feature Dependent_. |
| May the operational environment provide the behavior? | Explicit SFR permission | It may do so only where the SFR expressly permits platform-provided functionality. |
| What must be evaluated? | Mapping and the applicable EAs | Every mapped component, artifact, configuration, interface, channel, relationship, and required end-to-end behavior remains in scope. |

The TOE still satisfies every claimed SFR as a whole. The allocation model does not make an SFR optional, remove a component from the TOE boundary, reduce an EA, or transfer compliance from one component to another.

## 3. Why AppSW originally used “Applicable Components”

The term was not intended to invent a new conformance category. It was a guardrail against three practical misunderstandings:

1. **Feature inclusion being confused with component responsibility.** A selection may determine whether an SFR is in the ST. That does not answer which distributed component implements it after it is included.
2. **A component-level coverage escape.** An ST must not test a Server implementation and infer that a distinct Agent image, package, configuration, channel, or update path is covered merely because both serve a related purpose.
3. **A multi-element SFR being over-applied.** Where different components implement different elements, it is neither accurate nor necessary to say that each component independently satisfies the entire SFR.

Those concerns remain valid. The conclusion is that AppSW needs a clear **allocation-and-mapping rule**, not that it needs a fourth label.

## 4. Why use the NDcPP model now

NDcPP v4.0 has an explicit distributed-TOE allocation model. Its §3.4 uses the familiar allocation vocabulary of _All Components_, _At Least One Component_, and _Feature Dependent_, together with ST mapping of SFRs to the relevant TOE components. AppSW should use that vocabulary where it fits, rather than maintaining a near-synonym that has to be separately explained. [NDcPP v4.0, §3.4](https://nd-itc.github.io/cPP/NDcPP_v4_0.pdf)

This is an alignment decision, not a claim that all AppSW topology details are identical to a network device. AppSW still needs explicit treatment of:

- separately versioned images and packages;
- Server/Agent element distribution;
- container and runtime configurations;
- interfaces, channels, and Communication Relationship Types;
- artifact-specific trusted-update paths; and
- controlled, substantiated reuse of only implementation-specific EA portions.

Those are captured by the mapping and coverage rules, rather than by retaining _Applicable Components_ as a fourth category.

Equally, vocabulary alignment does **not** mean mechanically copying every individual allocation-table entry from NDcPP. The iTC should affirm the AppSW allocations on their own technical merits. For example, AppSW currently uses _Feature Dependent_ with element-level mapping for FCO_CPC_EXT.1 and for trusted-update functions, because responsibility can be distributed across separately versioned application components and artifacts. The mapping and retained-coverage controls are what make that AppSW-specific treatment defensible.

## 5. The proposed normative model, in plain language

### 5.1 The three allocation categories

| Category | Meaning | When it is appropriate |
| --- | --- | --- |
| **All Components** | Every distributed TOE Component implements the relevant requirement or element. | A universal baseline behavior that every component must exhibit. |
| **At Least One Component** | One or more components implement the required behavior. | Only where the relevant SFR or configuration table expressly permits this allocation. It is not an ST-author discretion to avoid coverage. |
| **Feature Dependent** | The SFR or element is fulfilled where its relevant feature is implemented by a distributed TOE Component. | A function is implemented by a subset of the TOE, or different elements are implemented by different components. |

For a claimed _Feature Dependent_ SFR or element, at least one TOE Component must implement the relevant feature. The ST maps **every** implementing TOE Component to the SFR element(s) it implements.

### 5.2 Claim condition is not an allocation category

A claim condition records why the SFR appears in the ST—for example, a completed selection, an objective claim, or a feature that the TOE offers. It is deliberately distinct from component allocation.

This distinction avoids both errors below:

- Saying that _Feature Dependent_ itself makes an SFR optional; and
- Saying that a selected or claimed SFR automatically applies in full to every component, including components that do not implement the relevant element.

The correct sequence is:

```text
Is the SFR included?  →  Which components implement its elements?  →  What coverage is required?
 claim condition           All / One / Feature Dependent              mapping + applicable EAs
```

### 5.3 Multi-element SFRs

When different TOE Components implement different elements of a multi-element SFR, each component satisfies the element(s) mapped to it. The mapped elements collectively satisfy the TOE-level SFR. This is not partial conformance: the TOE cannot claim the SFR until all of its required elements are covered.

The ST must use separate iterations when completed operations differ. A common SFR completion and TSS may be mapped to multiple components only when the operations and claimed security-relevant behavior are the same.

## 6. The key safeguards that remain unchanged

The revised model deliberately preserves the protections that were expressed through the former terminology.

| Safeguard | Rule retained in the revision | Why it matters |
| --- | --- | --- |
| **No omitted implementer** | A claim condition or Feature Dependent allocation cannot omit a component that implements the mapped function. | A Server test cannot silently stand in for a distinct Agent implementation. |
| **Instance behavior** | Every deployed TOE Component Instance exhibits the behavior allocated to its component in its identified configuration. | Scaling does not allow one instance to satisfy another instance’s allocated requirement. |
| **Element-level mapping** | The ST identifies the SFR element, claim condition, allocation, responsible component(s), artifact, configuration, interface/path, and iteration as applicable. | The evaluator can identify exactly what must be covered. |
| **Coverage is broader than allocation** | Artifacts, configurations, interfaces, channels, Communication Relationship Types, and end-to-end behavior remain EA targets. | The mapping does not reduce the stated scope of an EA. |
| **Evidence reuse is limited** | Representative execution is available only for explicitly identified implementation-specific EA portions and only after a substantiated equivalence rationale. | It avoids unnecessary duplicate execution without turning equivalence into a blanket test waiver. |
| **OE boundary remains real** | An OE service can satisfy a TOE requirement only where that SFR expressly permits platform-provided functionality. | A shared service mesh, runtime, or base image cannot be casually credited as the TOE implementation. |

In particular, shared infrastructure, a common base image, a library name, a source repository, or a build pipeline is not enough by itself to establish implementation equivalence.

## 7. Worked examples for the meeting

### 7.1 FCO_CPC_EXT.1: pairing control and registration

This is the best example for explaining why a single _Applicable Components_ phrase was awkward.

| SFR element | Illustrative responsible component | Allocation result |
| --- | --- | --- |
| FCO_CPC_EXT.1.1 — enablement | Server/control component that enables the permitted pairing | Mapped element satisfied by that component. |
| FCO_CPC_EXT.1.2 — registration | Agent component that performs registration | Mapped element satisfied by that component. |
| FCO_CPC_EXT.1.3 — disablement | Server/control component that disables the pairing | Mapped element satisfied by that component. |

The TOE-level FCO_CPC_EXT.1 claim is satisfied only when the mapped elements collectively cover enablement, registration, and disablement. The Agent does not have to demonstrate the Server’s enablement or disablement function, and the Server does not have to demonstrate the Agent’s registration behavior unless it implements that behavior. The ST still identifies the affected endpoint identities and Communication Relationship Types, and the applicable FCO/FTP testing remains required.

This also preserves the prior correction that **FCO_CPC_EXT.1 is not an `/Agent` iteration**.

### 7.2 FPT_TUD_EXT.2: Server image and Agent package

This example separates selection from allocation cleanly:

1. The trusted-update selection is the **claim condition**. If it is not selected, the SFR is not included in the ST.
2. If selected, the SFR uses **Feature Dependent** allocation.
3. Every component that performs update verification, delivery, replacement, or installation-integrity behavior is mapped to the SFR element(s) it performs.
4. A successful Server image test does not prove the Agent package path. The evidence may be reused only if the specific security-relevant implementation, configuration, execution context, and scoped EA portion are shown equivalent.

Consequently, a common registry, base image, build pipeline, or package format does not itself create a test-coverage shortcut.

### 7.3 Universal baseline versus function-specific allocation

In the twelve-container illustrative topology, universal protection requirements can be marked _All Components (all five in this example)_. Function-specific responsibilities—such as communication pairing, data transmission, or trusted-update behavior—are _Feature Dependent_ and must be mapped to their actual implementing component(s).

The point is not the number of containers. Runtime replicas do not automatically create new allocation categories. They do remain subject to the coverage required by their security-relevant configuration, identities, interfaces, trust configuration, placement, failover path, or other properties that can affect the claimed result.

### 7.4 Table-policy checks to put before the iTC

The terminology decision should not hide meaningful AppSW-specific allocation choices. The iTC should make these choices deliberately rather than importing or rejecting NDcPP entries by analogy.

| Topic | NDcPP comparator | Current AppSW treatment | Decision to request |
| --- | --- | --- | --- |
| FCO_CPC_EXT.1 | The NDcPP comparator allocates pairing control across all components. | _Feature Dependent_, with `.1.1` enablement, `.1.2` registration, and `.1.3` disablement mapped to the component(s) that implement them. | Confirm this as an intentional AppSW architectural adaptation, or identify a specific reason to make every component independently responsible. |
| FPT_TUD_EXT.1 | The NDcPP comparator uses _All Components_. | _Feature Dependent_, with every separately versioned component, artifact, and update path retained in the mapping and coverage matrix. | Confirm that the artifact/path rule provides the needed protection for a function distributed across update actors and payloads. |
| At Least One Component | A standard allocation category. | Defined, but no current Server–Agent allocation-table row uses it. | Retain the category for alignment, while confirming that no vendor may invoke it unless the SFR or table expressly assigns it. |

The recommended result is not “use Feature Dependent more freely.” It is “use it precisely for implemented functions and elements, with a visible mapping that preserves the required evaluation scope.”

## 8. What this does **not** change

The iTC should be explicit about the following non-effects:

- It does **not** create a new optional SFR mechanism.
- It does **not** let an ST author freely choose _At Least One Component_; a table or requirement must permit it.
- It does **not** let a component avoid an SFR element it actually implements.
- It does **not** reduce EA repetitions, negative tests, algorithms, protocol roles, certificate cases, configurations, interfaces, channels, relationships, artifacts, or end-to-end checks.
- It does **not** make a TOE-provided sidecar, helper, library, or update service part of the OE merely because it is packaged or deployed in a container pattern.
- It does **not** decide the separate loopback or non-network local IPC issues. Those have their own scope and objective-control treatment. The current BAH-048 disposition remains **Clarify with reviewer**, so it should be recorded as adjacent follow-up rather than silently treated as an allocation decision.
- It does **not** require every component to implement every element of a distributed SFR.

## 9. Anticipated questions and recommended responses

### “Why not keep both Feature Dependent and Applicable Components?”

They address the same allocation question. Two terms invite readers to infer an unstated semantic distinction and complicate review. The needed protections live in the mapping and coverage rules, so retaining the extra label gives little benefit and causes BAH’s concern.

### “Does Feature Dependent let the vendor decide that a mandatory SFR does not apply?”

No. The SFR’s own mandatory, optional, selection-based, or objective status controls inclusion. _Feature Dependent_ applies only after inclusion and identifies the components that implement the feature. The applicable allocation table and SFR operations control which allocation is allowed.

### “Could this let a Server test stand in for an Agent test?”

Not by itself. The Server and Agent must first be mapped to their respective SFR elements, artifacts, configurations, and paths. Representative execution is allowed only for a substantiated implementation-equivalence class and only for the exact implementation-specific EA portions it covers. Interface, channel, artifact, configuration, and end-to-end checks remain separate.

### “Does element mapping result in partial SFR satisfaction?”

No. It describes how a distributed TOE as a whole satisfies a multi-element SFR. Every required element must be mapped and covered. The outcome is more precise than requiring every component to satisfy all elements, which would be technically incorrect for a distributed function such as enablement, registration, and disablement.

### “Does this add a large documentation burden?”

It asks for concise traceability, not a bespoke document for every instance. A compact ST mapping may identify component/configuration sets, SFR iteration(s), class identifier(s), common TSS reference(s), artifacts, and relationships. Detailed equivalence evidence may remain in evaluation evidence or the test plan. Runtime replicas may be represented by a component and permitted scaling topology unless a security-relevant difference requires separate treatment.

### “Why does AppSW need explicit mapping when NDcPP seems simpler?”

The label is now the same. The AppSW configuration needs explicit mapping because it is designed for heterogeneous application components, images, packages, containers, and lifecycle paths. The mapping is the mechanism that makes the shared vocabulary defensible for that more general distributed-application setting.

## 10. Suggested meeting flow (60 minutes)

1. **Two minutes — ask for the decision.** Approve the three standard allocation terms and separate claim conditions from allocation.
2. **Five minutes — explain the problem being solved.** Show why the former term existed: prevent coverage escape and avoid over-applying a multi-element SFR.
3. **Ten minutes — walk the semantic model.** Use the four-question table in §2 and the sequence in §5.2.
4. **Fifteen minutes — work the two examples.** FCO_CPC_EXT.1 first; FPT_TUD_EXT.2 second.
5. **Ten minutes — inspect the allocation tables.** Confirm that the model is shared with NDcPP while each AppSW entry is intentionally assigned; do not import NDcPP row allocations mechanically.
6. **Ten minutes — test the objections.** Use §9 to confirm that coverage, exact conformance, and evaluator discretion are preserved.
7. **Eight minutes — record the resolution.** Agree on the proposed text below, owners, and any table-specific follow-up.

## 11. Proposed resolution for the minutes

> The AppSW-iTC agrees to use the NDcPP distributed-TOE component-allocation vocabulary of All Components, At Least One Component, and Feature Dependent. A feature, selection, or objective condition that controls SFR inclusion is recorded separately from allocation. For each claimed Feature Dependent SFR or element, the ST maps every implementing TOE Component to its implemented element(s); where components implement different elements, the elements collectively satisfy the TOE-level SFR. The mapping and Evaluation Activities retain required component, artifact, configuration, interface, channel, relationship, and end-to-end coverage. Evidence reuse remains limited to substantiated, explicitly scoped implementation-specific activity portions.

## 12. Concrete decisions to solicit

| Decision | Recommended answer | Reason |
| --- | --- | --- |
| Should AppSW retain _Applicable Components_ as a separate term? | **No.** | It duplicates Feature Dependent and is harder to defend as a distinct concept. |
| Should claim condition be a fourth allocation category? | **No.** | It governs inclusion, not implementation responsibility. |
| Should Feature Dependent include an at-least-one implementing-component condition when claimed? | **Yes.** | It prevents a claimed feature with no implementing component. |
| Should mappings be at SFR-element level when responsibility differs? | **Yes.** | It accurately handles FCO_CPC and other multi-element distributed functions. |
| Should coverage/reuse guardrails remain normative? | **Yes.** | They preserve the original purpose of the AppSW wording and prevent evaluation escape. |
| Should AppSW copy every NDcPP allocation-table row? | **No.** | Adopt the shared vocabulary and mapping discipline, then affirm each AppSW row against its own component architecture and SFR behavior. |
| Should the model be used by future AppSW PP-Configurations? | **Yes.** | It provides a single, familiar model rather than per-configuration terminology. |

## 13. Source map for the discussion

| Subject | Current source |
| --- | --- |
| Base cPP normative distributed-TOE allocation, mapping, and TOE-level completion | [`input/application.xml`](../input/application.xml), distributed TOE section around lines 229–233 |
| Base cPP evidence-reuse and retained-coverage rules | [`input/application.xml`](../input/application.xml), Evaluation Activities around lines 2321–2341 and the component-equivalence appendix |
| Server–Agent definitions, rationale, mapping requirements, and conditional update example | [`Archive/Modules/Agent/appSW_PP_Config_ServerAgent.adoc`](../Archive/Modules/Agent/appSW_PP_Config_ServerAgent.adoc), §§1.4.2–1.4.5, around lines 141–188 |
| FCO_CPC element mapping and configuration table | [`Archive/Modules/Agent/appSW_PP_Config_ServerAgent.adoc`](../Archive/Modules/Agent/appSW_PP_Config_ServerAgent.adoc), around lines 361–383 |
| Illustrated allocation, mapping, and retained EA coverage | [`allocation-coverage-guardrail.svg`](../Archive/Modules/Agent/images/allocation-coverage-guardrail.svg) and its figure placement in the configuration |
| Twelve-container allocation example and retained relationship coverage | [`Archive/Modules/Agent/appSW_PP_Config_ServerAgent.adoc`](../Archive/Modules/Agent/appSW_PP_Config_ServerAgent.adoc), around lines 468–505 |
| Reviewer dispositions | [`BAH_Draft_Review_Disposition_and_Rationale.md`](../Comments/_collation/BAH_Draft_Review_Disposition_and_Rationale.md), BAH-005 through BAH-008 |
| Adjacent scope issue to track separately | [`BAH_Draft_Review_Disposition_and_Rationale.md`](../Comments/_collation/BAH_Draft_Review_Disposition_and_Rationale.md), BAH-048 (currently “Clarify with reviewer”) |

## 14. One-minute opening statement

“We are not changing the coverage expectation for distributed AppSW TOEs. We are replacing a locally coined label with NDcPP’s established three-term allocation model. The claim condition decides whether an SFR is in the ST; the allocation identifies every component that implements each included SFR element; and the EAs still cover every required artifact, configuration, interface, channel, relationship, and end-to-end behavior. This lets us answer BAH’s terminology concern without creating a path for component or test-coverage escape.”
