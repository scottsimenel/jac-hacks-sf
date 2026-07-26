# Implementation Plan — Agent 2: Trait & Title Synthesizer (`TraitWalker`)

Build and integrate **Agent 2 (`TraitWalker`)** to bridge deterministic MBTI dichotomy scoring with LLM-powered unhinged title synthesis, roasted behavioral analysis, 5-model radar metrics, and 3-layer visual avatar prompt contract generation.

## Strategy Rationale
Integrating live LLM synthesis into Agent 2 ensures:
- **Unhinged & Memorable Archetypes**: Replaces static placeholder titles with sharp, dynamic, meme-literate personality profiles (e.g. *"Captain of Unfinished Side-Quests"*, *"Mastermind of 3 AM Overthinking"*).
- **Free-Form Text Analysis**: Incorporates user situational comments directly into the LLM synthesis prompt to produce hyper-tailored roasted breakdowns.
- **Visual Theme Extraction**: Generates custom visual keywords (`visual_theme_keywords`) used by Agent 3 for caricature avatar rendering.

---

## User Review Required

> [!IMPORTANT]
> **LLM Provider Integration**:
> - We will implement a resilient LLM synthesis handler in `backend/jac/trait_synthesizer.py` supporting OpenAI / Replicate / LiteLLM API providers, with an automatic fallback mechanism to deterministic rule-based title generation if no API key is set.
> - **Inputs**: Deterministic MBTI 4-letter anchor code + 28-question answer choices + free-form user comments.
> - **Outputs**: Unhinged custom title, 3-4 trait badges, sarcastic tagline, appearance vs. reality roast, 5-model radar metrics (0-100), and visual theme keywords.

---

## Proposed Changes

### Backend Architecture (`backend/`)

#### [NEW] [backend/jac/trait_synthesizer.py](file:///Users/scottsimenel/Development/jac-hacks/backend/jac/trait_synthesizer.py)
- Python synthesis module containing:
  - System prompt engineering for witty, sarcastic, meme-literate profiler persona.
  - JSON schema enforcement & validation (`TraitSynthesizerOutput`).
  - Automatic fallback engine for offline execution when `OPENAI_API_KEY` / `REPLICATE_API_TOKEN` is unavailable.

#### [MODIFY] [endpoints.sv.jac](file:///Users/scottsimenel/Development/jac-hacks/endpoints.sv.jac)
- Update `SubmitLikeness` and `GetResult` walkers to invoke `trait_synthesizer.synthesize_archetype()` passing the deterministic MBTI scores and user free-form answers.

#### [MODIFY] [backend/jac/main.jac](file:///Users/scottsimenel/Development/jac-hacks/backend/jac/main.jac)
- Update `TraitWalker` to execute LLM synthesis and store rich `TraitArchetypeNode` properties on the Jac graph.

### Frontend Updates (`frontend.cl.jac` & `components/`)

#### [MODIFY] [components/ResultScreen.cl.jac](file:///Users/scottsimenel/Development/jac-hacks/components/ResultScreen.cl.jac)
- Render synthesized 5-model radar metrics (Self, Emotion, Attitude, Action, Social) and strengths/flaws list in the expandable Deep Analysis drawer.

---

## Verification Plan

### Automated Verification
- **Unit & Integration Test**: Create `backend/tests/test_agent_2.py` testing deterministic fallback + LLM synthesis payload parsing.
- **Jac Compilation Check**: Verify `~/.local/bin/jac check main.jac` (100% pass).

### Manual Verification
- Execute `SubmitLikeness` walker with hybrid inputs (choices + free-form comment `"I spend 3 hours picking a movie then fall asleep"`).
- Verify that `unhinged_title` and `top_traits` dynamically reflect the free-form text.
- Verify Deep Analysis radar chart metrics render cleanly on `ResultScreen`.
