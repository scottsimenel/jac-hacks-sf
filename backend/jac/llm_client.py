"""
Groq LLM Synthesis Client for Agent 2 (Trait & Title Synthesizer)
"""

import os
import json
import urllib.request
import urllib.error

GROQ_ENDPOINT = "https://api.groq.com/openai/v1/chat/completions"
MODEL_NAME = "llama-3.3-70b-versatile"

def load_env():
    """Load .env file if present without external dependencies."""
    env_path = os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(__file__))), ".env")
    if os.path.exists(env_path):
        with open(env_path, "r", encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, val = line.split("=", 1)
                    os.environ[key.strip()] = val.strip()

def synthesize_unhinged_profile(mbti_anchor: str, user_comments: list = None) -> dict:
    """
    Call Groq API using Llama 3.3 70B to synthesize a hyper-personalized,
    unhinged title, trait badges, appearance vs. reality roast, and 5-model radar metrics.
    """
    load_env()
    api_key = os.getenv("GROQ_API_KEY")
    if not api_key:
        print("[Agent 2 LLM Client] GROQ_API_KEY not found. Returning deterministic fallback.")
        return None

    comments_str = "\n".join([f"- {c}" for c in user_comments]) if user_comments else "None provided."

    system_prompt = (
        "You are an expert unhinged personality profiler. "
        "Your task is to take a user's calculated MBTI anchor code and their free-form comments, "
        "and synthesize a sharp, witty, meme-literate, and uncannily accurate personality profile. "
        "You MUST respond ONLY with a valid JSON object matching this schema:\n"
        "{\n"
        '  "unhinged_title": "string (e.g. Captain of Unfinished Side-Quests)",\n'
        '  "summary_quote": "string (short sarcastic tagline)",\n'
        '  "top_traits": ["3-4 short punchy trait badges"],\n'
        '  "appearance": "string (what others see on the outside)",\n'
        '  "reality": "string (internal chaotic truth)",\n'
        '  "strengths": ["2-3 unfiltered strengths"],\n'
        '  "flaws": ["2-3 unfiltered flaws"],\n'
        '  "radar_self": 80 (0-100 score),\n'
        '  "radar_emotion": 65 (0-100 score),\n'
        '  "radar_attitude": 85 (0-100 score),\n'
        '  "radar_action": 90 (0-100 score),\n'
        '  "radar_social": 75 (0-100 score),\n'
        '  "visual_keywords": ["3-4 outfit/prop keywords for AI avatar, e.g. pirate hat, glowing blueprints"]\n'
        "}"
    )

    user_prompt = (
        f"Calculated MBTI Baseline: {mbti_anchor}\n"
        f"User Free-Form Commentary:\n{comments_str}\n\n"
        "Generate the unhinged personality profile JSON now."
    )

    payload = {
        "model": MODEL_NAME,
        "messages": [
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": user_prompt}
        ],
        "temperature": 0.8,
        "response_format": {"type": "json_object"}
    }

    req = urllib.request.Request(
        GROQ_ENDPOINT,
        data=json.dumps(payload).encode("utf-8"),
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "User-Agent": "JacPersona/1.0"
        },
        method="POST"
    )

    try:
        with urllib.request.urlopen(req, timeout=10.0) as resp:
            data = json.loads(resp.read().decode("utf-8"))
            content = data["choices"][0]["message"]["content"]
            parsed = json.loads(content)
            print(f"[Agent 2 LLM Client] Successfully synthesized profile via Groq ({MODEL_NAME}): '{parsed.get('unhinged_title')}'")
            return parsed
    except Exception as err:
        print(f"[Agent 2 LLM Client] Groq API call failed or timed out: {err}. Falling back to rule-based engine.")
        return None
