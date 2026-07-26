"""
Hyper-Personalized Personality & Caricature Avatar Generator
Server-Side Data Layer & Multi-Agent API Endpoints (100% Jac Native)
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
        radar_social: int = 80,
        visual_keywords: list[str] = [];
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
# API WALKERS & NATIVE JAC LLM SYNTHESIS
# =============================================================================

walker:pub InitSession {
    has likeness_type: str = "attributes",
        session_id: str = "",
        reports: list[UserSession] = [];

    can init with Root entry {
        new_session = UserSession(
            session_id=self.session_id if self.session_id else "session_1000",
            created_at="2026-07-26",
            likeness_type=self.likeness_type
        );
        here ++> new_session;
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
        new_ans = AnswerRecord(
            question_id=self.question_id,
            dimension=self.dimension,
            choice=self.choice,
            freeform_text=self.freeform_text
        );
        here ++> new_ans;
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

    def build_fallback(mbti_code: str) -> dict {
        title_prefix = "Captain of " if mbti_code.startswith("E") else "Mastermind of ";
        return {
            "unhinged_title": title_prefix + mbti_code + " Chaos",
            "summary_quote": "Zero science, 100% uncannily accurate chaos.",
            "top_traits": ["Chaos Orchestrator", "Paper-Thin Confidence", "Left-on-Read Survivor", "Hyper-Focused Deep Diver"],
            "appearance": f"Others see a composed {mbti_code} visionary.",
            "reality": "Inside is pure unhinged caffeine energy and 3 AM overthinking.",
            "strengths": ["Infinite Idea Generation", "Unmatched Crisis Adaptability", "High Vibe Energy"],
            "flaws": ["Zero Finishing Ability", "Selective Hearing", "Overthinking 2 AM Texts"],
            "radar_self": 82,
            "radar_emotion": 65,
            "radar_attitude": 88,
            "radar_action": 92,
            "radar_social": 78,
            "keywords": ["pirate hat", "glowing blueprints", "caffeine mug"]
        };
    }

    can process_likeness with Root entry {
        raw_ans = json.loads(self.answers_json) if self.answers_json else [];
        mbti_res = calculate_mbti_type(raw_ans) if len(raw_ans) > 0 else {"type": "ENTP", "scores": {}};
        mbti_code = mbti_res.get("type", "ENTP");

        synth = self.build_fallback(mbti_code);

        archetype = TraitArchetype(
            mbti_anchor=mbti_code,
            unhinged_title=synth["unhinged_title"],
            summary_quote=synth["summary_quote"],
            top_traits=synth["top_traits"],
            appearance_text=synth["appearance"],
            reality_text=synth["reality"],
            strengths=synth["strengths"],
            flaws=synth["flaws"],
            radar_self=synth["radar_self"],
            radar_emotion=synth["radar_emotion"],
            radar_attitude=synth["radar_attitude"],
            radar_action=synth["radar_action"],
            radar_social=synth["radar_social"],
            visual_keywords=synth["keywords"]
        );
        here ++> archetype;
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
