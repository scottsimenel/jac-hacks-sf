# Implementation Plan — Agent 2: Trait & Title Synthesizer (`TraitWalker` in Jac)

Build and integrate **Agent 2 (`TraitWalker`)** using 100% **Jac native constructs** (`by llm()` generative abilities, Jac graph nodes, and Jac walkers).

## Strategy Rationale & Jac Prominence
Implementing Agent 2 natively in Jac ensures:
- **Native Jac LLM Synthesis (`by llm()`)**: Uses Jac's first-class `by llm(reason=...)` semantics directly inside `.jac` files for schema-driven LLM synthesis.
- **Jac Graph Native Traversal**: Stores and connects synthesized archetypes on the Jac node graph (`UserSession ++> TraitArchetype`).
- **Direct Jac Walker RPCs**: Executed natively via Jac walkers (`walker:pub SubmitLikeness`) without external python middleware layers.

---

## User Review Required

> [!IMPORTANT]
> **Jac LLM Syntax & Fallback**:
> - **Jac Ability**: `can synthesize_archetype(mbti_code: str, comments: list[str]) -> dict by llm();` defined natively inside `endpoints.sv.jac`.
> - **Fallback Engine**: Pure Jac helper method (`can fallback_synthesis -> dict`) if LLM provider is offline.
> - **Inputs**: Deterministic MBTI 4-letter anchor code + free-form user comments.
> - **Outputs**: Unhinged custom title, 3-4 trait badges, sarcastic tagline, appearance vs. reality roast, 5-model radar metrics (0-100), and visual theme keywords for Agent 3.

---

## Proposed Changes

### Backend Architecture (100% Jac)

#### [MODIFY] [endpoints.sv.jac](file:///Users/scottsimenel/Development/jac-hacks/endpoints.sv.jac)
- Implement `can synthesize_archetype by llm()` directly inside `SubmitLikeness` walker.
- Connect synthesized outputs to `TraitArchetype` node graph attributes.

#### [MODIFY] [backend/jac/main.jac](file:///Users/scottsimenel/Development/jac-hacks/backend/jac/main.jac)
- Update `TraitWalker` to execute native Jac LLM synthesis and log trajectory details.

### Frontend Updates (`frontend.cl.jac` & `components/`)

#### [MODIFY] [components/ResultScreen.cl.jac](file:///Users/scottsimenel/Development/jac-hacks/components/ResultScreen.cl.jac)
- Render synthesized 5-model radar metrics (Self, Emotion, Attitude, Action, Social) and strengths/flaws list in the expandable Deep Analysis drawer.

---

## Verification Plan

### Automated Verification
- **Jac Type-Check**: Verify `~/.local/bin/jac check main.jac` passes with 0 errors.
- **Jac Graph Execution Test**: Execute `~/.local/bin/jac run backend/jac/main.jac`.

### Manual Verification
- Test `SubmitLikeness` walker with hybrid inputs (choices + free-form comment `"I spend 3 hours picking a movie then fall asleep"`).
- Verify that `unhinged_title` and `top_traits` dynamically reflect the free-form text.
- Verify Deep Analysis radar chart metrics render cleanly on `ResultScreen`.
