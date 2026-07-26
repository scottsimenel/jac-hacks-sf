"""
Hyper-Personalized Personality & Caricature Avatar Generator
Client-Side Interactive UI (Jac Client Engine)
"""

import from .components.LandingScreen { LandingScreen }
import from .components.QuizScreen { QuizScreen }
import from .components.LikenessModal { LikenessModal }
import from .components.ResultScreen { ResultScreen }

sv import from endpoints { TraitArchetype, SubmitLikeness, InitSession }

def:pub app -> JsxElement {
    has step: str = "landing", # "landing", "quiz", "likeness", "loading", "result"
        current_q: int = 0,
        user_answers: list[dict] = [],
        freeform_input: str = "",
        session_id: str = "session_1001",
        
        # Likeness attributes (collected post-quiz)
        likeness_mode: str = "attributes", # "attributes" or "photo"
        photo_url: str = "",
        skin_tone: str = "medium",
        hair_color: str = "dark brown",
        hair_style: str = "short crop",
        gender_expression: str = "neutral",
        accessories: str = "glasses",
        
        # Result state
        result_title: str = "Captain of ENTP Chaos",
        result_mbti: str = "ENTP",
        result_traits: list[str] = ["Chaos Orchestrator", "Paper-Thin Confidence", "Left-on-Read Survivor", "Hyper-Focused Deep Diver"],
        result_quote: str = "Zero science, 100% uncannily accurate chaos.",
        result_appearance: str = "Others see a composed ENTP visionary.",
        result_reality: str = "Inside is pure unhinged caffeine energy and 3 AM overthinking.",
        result_strengths: list[str] = ["Infinite Idea Generation", "Unmatched Crisis Adaptability", "High Vibe Energy"],
        result_flaws: list[str] = ["Zero Finishing Ability", "Selective Hearing", "Overthinking 2 AM Texts"],
        show_deep_analysis: bool = False;

    async def startQuiz -> None;
    async def selectChoiceA -> None;
    async def selectChoiceB -> None;
    async def updateFreeform(e: ChangeEvent) -> None;
    async def handleInputKeyDown(e: KeyboardEvent) -> None;
    async def updateSkin(e: ChangeEvent) -> None;
    async def updateHair(e: ChangeEvent) -> None;
    async def updateGender(e: ChangeEvent) -> None;
    async def submitLikeness -> None;
    async def toggleDeep -> None;
    async def generateStory -> None;
    async def prevQuestion -> None;
    async def triggerReRoll -> None;

    questions_list = [
        {"id": 1, "dim": "EI", "q": "Where do I typically derive motivation and confidence from:", "a": "Others.", "b": "My own thoughts."},
        {"id": 2, "dim": "EI", "q": "When attending a social gathering, I usually:", "a": "Grow more energetic as the night progresses.", "b": "Feel tired and want to go home early."},
        {"id": 3, "dim": "EI", "q": "Which sounds more appealing?", "a": "Going to a lively social venue with my partner.", "b": "Staying home for a special night with takeout."},
        {"id": 4, "dim": "EI", "q": "During dates, I typically:", "a": "Am generally talkative.", "b": "Remain quiet and reserved until I feel ready."},
        {"id": 5, "dim": "EI", "q": "In the past, I've met most romantic partners:", "a": "Through public settings like work or friends.", "b": "Through private channels like dating apps or family."},
        {"id": 6, "dim": "EI", "q": "When communicating with my partner, I prefer:", "a": "Direct verbal communication or phone calls.", "b": "Written communication like texts or letters."},
        {"id": 7, "dim": "EI", "q": "I find it easier to express my feelings:", "a": "Out loud in real-time conversations.", "b": "Through writing or artistic expression."},
        {"id": 8, "dim": "SN", "q": "When focusing on a project or task, I prefer:", "a": "Concrete facts, realistic details, and tangible outcomes.", "b": "Big-picture possibilities, creative concepts, and future potential."},
        {"id": 9, "dim": "SN", "q": "When processing new information, I trust:", "a": "Direct observation and past experience.", "b": "Intuition, patterns, and gut feelings."},
        {"id": 10, "dim": "SN", "q": "When describing an event, I tend to:", "a": "Give a step-by-step account of what literally happened.", "b": "Summarize the overall vibe, meaning, and impression."},
        {"id": 11, "dim": "SN", "q": "I tend to admire people who are:", "a": "Grounded, practical, and dependable.", "b": "Imaginative, innovative, and visionary."},
        {"id": 12, "dim": "SN", "q": "When solving problems, I rely on:", "a": "Proven methods and established procedures.", "b": "Novel solutions and unorthodox ideas."},
        {"id": 13, "dim": "SN", "q": "I am more interested in:", "a": "What is real and present right now.", "b": "What could be possible in the future."},
        {"id": 14, "dim": "SN", "q": "When learning something new, I prefer:", "a": "Hands-on practice and clear examples.", "b": "Theoretical frameworks and big-picture principles."},
        {"id": 15, "dim": "TF", "q": "When making difficult decisions, I prioritize:", "a": "Objective logic, fairness, and consistent principles.", "b": "Personal values, empathy, and harmony for those involved."},
        {"id": 16, "dim": "TF", "q": "When someone brings me a problem, my natural response is to:", "a": "Analyze the situation and offer practical solutions.", "b": "Listen empathetically and offer emotional support."},
        {"id": 17, "dim": "TF", "q": "I value being seen as:", "a": "Competent, logical, and clear-headed.", "b": "Compassionate, caring, and authentic."},
        {"id": 18, "dim": "TF", "q": "In arguments, I care most about:", "a": "Truth, logic, and factual accuracy.", "b": "Maintaining relationships and protecting feelings."},
        {"id": 19, "dim": "TF", "q": "When evaluating a plan, I ask first:", "a": "Is it effective, efficient, and logical?", "b": "Will it make people happy and feel supported?"},
        {"id": 20, "dim": "TF", "q": "I am more easily persuaded by:", "a": "Strong evidence and sound reasoning.", "b": "Emotional appeal and personal stories."},
        {"id": 21, "dim": "TF", "q": "When giving feedback, I am:", "a": "Direct, honest, and task-focused.", "b": "Tactful, gentle, and encouraging."},
        {"id": 22, "dim": "JP", "q": "My ideal schedule is:", "a": "Structured, organized, and planned ahead of time.", "b": "Flexible, spontaneous, and open to last-minute changes."},
        {"id": 23, "dim": "JP", "q": "Before going on a trip, I prefer to:", "a": "Create a detailed itinerary and reserve everything.", "b": "Pack light and figure out what to do when I arrive."},
        {"id": 24, "dim": "JP", "q": "When working on a deadline, I:", "a": "Finish early to avoid last-minute stress.", "b": "Work best under pressure as the deadline approaches."},
        {"id": 25, "dim": "JP", "q": "In daily life, I prefer to:", "a": "Have closure, decisions made, and matters settled.", "b": "Keep options open and adapt as new information comes in."},
        {"id": 26, "dim": "JP", "q": "My workspace / room is typically:", "a": "Neat, organized, with everything in its designated place.", "b": "Organized chaos, where I know where things are even if messy."},
        {"id": 27, "dim": "JP", "q": "I feel most comfortable when:", "a": "Following a routine or a clear checklist.", "b": "Having freedom to improvise and adapt on the fly."},
        {"id": 28, "dim": "JP", "q": "When making weekend plans, I usually:", "a": "Lock in plans several days in advance.", "b": "Wait until the weekend arrives to see how I feel."}
    ];

    q_item = questions_list[current_q];

    def renderScreen -> JsxElement {
        if step == "landing" {
            return <LandingScreen onStart={startQuiz} />;
        } elif step == "quiz" {
            return <QuizScreen
                current_q={current_q}
                total_q={len(questions_list)}
                dim={q_item["dim"]}
                prompt={q_item["q"]}
                opt_a={q_item["a"]}
                opt_b={q_item["b"]}
                freeform_text={freeform_input}
                onSelectA={selectChoiceA}
                onSelectB={selectChoiceB}
                onTextChange={updateFreeform}
                onKeyDownInput={handleInputKeyDown}
                onPrevQ={prevQuestion}
            />;
        } elif step == "likeness" {
            return <LikenessModal
                likeness_mode={likeness_mode}
                skin_tone={skin_tone}
                hair_color={hair_color}
                gender_expression={gender_expression}
                onSetModeAttr={lambda { likeness_mode = "attributes"; }}
                onSetModePhoto={lambda { likeness_mode = "photo"; }}
                onSkinChange={updateSkin}
                onHairChange={updateHair}
                onGenderChange={updateGender}
                onSubmit={submitLikeness}
            />;
        } else {
            return <ResultScreen
                mbti={result_mbti}
                title={result_title}
                quote={result_quote}
                skin_tone={skin_tone}
                hair_color={hair_color}
                traits={result_traits}
                show_deep={show_deep_analysis}
                appearance={result_appearance}
                reality={result_reality}
                strengths={result_strengths}
                flaws={result_flaws}
                onToggleDeep={toggleDeep}
                onGenerateStory={generateStory}
            />;
        }
    }

    return
        <div
            style={{
                "minHeight": "100vh",
                "backgroundColor": "#0d0f17",
                "color": "#f1f5f9",
                "fontFamily": "system-ui, -apple-system, sans-serif",
                "padding": "1.5rem"
            }}
        >
            <header
                style={{
                    "display": "flex",
                    "justifyContent": "space-between",
                    "alignItems": "center",
                    "maxWidth": "900px",
                    "margin": "0 auto 2rem auto",
                    "paddingBottom": "1rem",
                    "borderBottom": "1px solid rgba(255, 255, 255, 0.1)"
                }}
            >
                <div style={{"display": "flex", "alignItems": "center", "gap": "0.75rem"}}>
                    <div
                        style={{
                            "width": "36px",
                            "height": "36px",
                            "borderRadius": "10px",
                            "background": "linear-gradient(135deg, #6366f1, #a855f7)",
                            "display": "flex",
                            "alignItems": "center",
                            "justifyContent": "center",
                            "fontWeight": "bold",
                            "fontSize": "1.2rem"
                        }}
                    >
                        ⚡
                    </div>
                    <span style={{"fontSize": "1.25rem", "fontWeight": "800"}}>HyperPersona</span>
                </div>
                <span
                    style={{
                        "fontSize": "0.75rem",
                        "padding": "0.25rem 0.6rem",
                        "borderRadius": "20px",
                        "background": "rgba(99, 102, 241, 0.15)",
                        "color": "#818cf8",
                        "border": "1px solid rgba(99, 102, 241, 0.3)"
                    }}
                >
                    Powered by Jac & JacHammer
                </span>
            </header>

            {renderScreen()}
        </div>;
}
