"""
Hyper-Personalized Personality & Caricature Avatar Generator
Server-Side Data Layer & Multi-Agent API Endpoints
"""

import from backend.jac.mbti_calculator { calculate_mbti_type }
import json;

node UserSession {
    has session_id: str,
        created_at: str,
        completed: bool = False,
        likeness_type: str = "attributes", # "photo" or "attributes"
        photo_url: str = "",
        skin_tone: str = "medium",
        hair_color: str = "brown",
        hair_style: str = "short",
        gender_expression: str = "neutral",
        accessories: str = "none";
}

node QuestionItem {
    has question_id: int,
        dimension: str,
        prompt: str,
        option_1: str,
        option_2: str;
}

node AnswerRecord {
    has question_id: int,
        dimension: str,
        choice: int,
        freeform_text: str = "";
}

node TraitArchetype {
    has mbti_anchor: str = "",
        unhinged_title: str = "",
        summary_quote: str = "",
        top_traits: list[str] = [],
        appearance_text: str = "",
        reality_text: str = "",
        strengths: list[str] = [],
        flaws: list[str] = [],
        radar_self: int = 75,
        radar_emotion: int = 60,
        radar_attitude: int = 85,
        radar_action: int = 90,
        radar_social: int = 80;
}

node AvatarArtifact {
    has avatar_url: str = "",
        story_poster_url: str = "",
        is_fallback: bool = False,
        prompt_layer_1: str = "",
        prompt_layer_2: str = "",
        prompt_layer_3: str = "",
        seed: int = 42;
}

# =============================================================================
# API WALKERS
# =============================================================================

walker:pub InitSession {
    has likeness_type: str = "attributes",
        session_id: str = "",
        reports: list[UserSession] = [];

    can init with Root entry {
        new_session = spawn here ++> UserSession(
            session_id=self.session_id if self.session_id else "session_1000",
            created_at="2026-07-26",
            likeness_type=self.likeness_type
        );
        report new_session;
    }
}

walker:pub SubmitAnswer {
    has session_id: str,
        question_id: int,
        dimension: str,
        choice: int,
        freeform_text: str = "",
        reports: list[AnswerRecord] = [];

    can record_answer with Root entry {
        new_ans = spawn here ++> AnswerRecord(
            question_id=self.question_id,
            dimension=self.dimension,
            choice=self.choice,
            freeform_text=self.freeform_text
        );
        report new_ans;
    }
}

walker:pub SubmitLikeness {
    has session_id: str,
        likeness_type: str = "attributes",
        photo_url: str = "",
        skin_tone: str = "medium",
        hair_color: str = "brown",
        hair_style: str = "short",
        gender_expression: str = "neutral",
        accessories: str = "none",
        answers_json: str = "[]",
        reports: list[TraitArchetype] = [];

    can process_likeness with Root entry {
        raw_ans = json.loads(self.answers_json) if self.answers_json else [];
        mbti_res = calculate_mbti_type(raw_ans) if len(raw_ans) > 0 else {"type": "ENTP", "scores": {}};
        mbti_code = mbti_res.get("type", "ENTP");

        title_prefix = "Captain of " if mbti_code.startswith("E") else "Mastermind of ";
        title = title_prefix + mbti_code + " Chaos";
        
        archetype = spawn here ++> TraitArchetype(
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
            radar_social=78
        );
        report archetype;
    }
}

walker:pub GetResult {
    has session_id: str,
        reports: list[TraitArchetype] = [];

    can fetch with Root entry {
        visit [-->];
    }

    can gather with TraitArchetype entry {
        report here;
    }
}
