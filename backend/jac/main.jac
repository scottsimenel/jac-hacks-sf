"""
Hyper-Personalized Personality & Caricature Avatar Generator
Core Jac Graph Architecture & Multi-Agent Engine
"""

import mbti_calculator;

# =============================================================================
# DATA NODES
# =============================================================================

node UserSessionNode {
    has session_id: str;
    has created_at: str;
    has completed: bool = False;
    has likeness_type: str = "attributes"; # "photo" or "attributes"
    has photo_url: str = "";
    has skin_tone: str = "medium";
    has hair_color: str = "brown";
    has hair_style: str = "short";
    has gender_expression: str = "neutral";
    has accessories: str = "none";
}

node QuestionNode {
    has question_id: int;
    has dimension: str; # "EI", "SN", "TF", "JP"
    has prompt: str;
    has option_1: str;
    has option_2: str;
}

node AnswerNode {
    has question_id: int;
    has dimension: str;
    has choice: int; # 1 or 2
    has freeform_text: str = "";
}

node TraitArchetypeNode {
    has mbti_anchor: str = ""; # e.g. "ENTP"
    has unhinged_title: str = ""; # e.g. "Captain of ENTP Chaos"
    has summary_quote: str = "";
    has top_traits: list[str] = []; # e.g. ["Chaos Orchestrator", "Hyper-Focused"]
    has appearance_text: str = "";
    has reality_text: str = "";
    has strengths: list[str] = [];
    has flaws: list[str] = [];
    has radar_self: int = 75;
    has radar_emotion: int = 60;
    has radar_attitude: int = 85;
    has radar_action: int = 90;
    has radar_social: int = 80;
    has visual_keywords: list[str] = [];
}

node AvatarArtifactNode {
    has avatar_url: str = "";
    has story_poster_url: str = "";
    has is_fallback: bool = False;
    has prompt_layer_1_mbti: str = "";
    has prompt_layer_2_traits: str = "";
    has prompt_layer_3_likeness: str = "";
    has seed: int = 42;
}

# =============================================================================
# EDGES
# =============================================================================

edge session_has_answer {}
edge session_has_trait {}
edge session_has_avatar {}
edge question_next {}

# =============================================================================
# WALKERS (AGENTS)
# =============================================================================

walker IntakeWalker {
    has current_question_id: int = 1;
    has answers_collected: list[dict] = [];

    can get_next_question with UserSessionNode entry {
        print(f"[Agent 1: IntakeWalker] Active on session '{here.session_id}' for Q{self.current_question_id}");
    }
}

walker TraitWalker {
    has raw_answers: list[dict] = [];

    can synthesize_traits with UserSessionNode entry {
        mbti_result = mbti_calculator.calculate_mbti_type(self.raw_answers);
        mbti_code = mbti_result.get("type", "ENTP");
        scores = mbti_result.get("scores", {});

        title_prefix = "Captain of " if mbti_code.startswith("E") else "Mastermind of ";
        title = title_prefix + mbti_code + " Chaos";

        archetype = TraitArchetypeNode(
            mbti_anchor=mbti_code,
            unhinged_title=title,
            summary_quote="Zero science, 100% uncannily accurate chaos.",
            top_traits=["Chaos Orchestrator", "Paper-Thin Confidence", "Left-on-Read Survivor", "Hyper-Focused Deep Diver"],
            appearance_text=f"Others see a composed {mbti_code} visionary.",
            reality_text="Inside is pure unhinged caffeine energy and 3 AM overthinking.",
            strengths=["Infinite Idea Generation", "Unmatched Crisis Adaptability", "High Vibe Energy"],
            flaws=["Zero Finishing Ability", "Selective Hearing", "Overthinking 2 AM Texts"],
            radar_self=82,
            radar_emotion=65,
            radar_attitude=88,
            radar_action=92,
            radar_social=78,
            visual_keywords=["pirate hat", "glowing blueprints", "caffeine mug"]
        );
        here ++> archetype;

        print(f"[Agent 2: TraitWalker] Calculated Baseline MBTI Anchor: {mbti_code}");
        print(f"[Agent 2: TraitWalker] Dimension Point Breakdown: {scores}");
        print(f"[Agent 2: TraitWalker] Synthesized Archetype Node: '{title}'");
    }
}

walker AvatarWalker {
    has mbti_anchor: str = "";
    has unhinged_title: str = "";
    has likeness_payload: dict[str, str] = {};

    can generate_avatar_prompt with UserSessionNode entry {
        layer_1 = f"Style of iconic {self.mbti_anchor} MBTI character archetype";
        layer_2 = f"Customized outfit and scene for title '{self.unhinged_title}'";
        skin = self.likeness_payload.get("skin_tone", "medium");
        hair = self.likeness_payload.get("hair_color", "brown");
        layer_3 = f"User physical features: {skin} skin, {hair} hair";

        full_prompt = f"{layer_1}, {layer_2}, {layer_3}";
        print(f"[Agent 3: AvatarWalker] 3-Layer Synthesized Avatar Prompt: '{full_prompt}'");
    }
}

# =============================================================================
# MAIN ENTRY
# =============================================================================

with entry {
    print("=================================================");
    print("Jac Multi-Agent Core Engine & Nodes Initialized.");
    print("=================================================");

    session = UserSessionNode(
        session_id="test-session-001",
        created_at="2026-07-26",
        skin_tone="olive",
        hair_color="dark brown"
    );

    sample_answers = [
        {"dimension": "EI", "choice": 1},
        {"dimension": "SN", "choice": 2},
        {"dimension": "TF", "choice": 1},
        {"dimension": "JP", "choice": 2}
    ];

    IntakeWalker(current_question_id=1) spawn session;
    TraitWalker(raw_answers=sample_answers) spawn session;
    AvatarWalker(
        mbti_anchor="ENTP",
        unhinged_title="Captain of ENTP Chaos",
        likeness_payload={"skin_tone": "olive", "hair_color": "dark brown"}
    ) spawn session;
}
