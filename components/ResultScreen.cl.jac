"""Results Hub Component."""

import from .BadgeCard { BadgeCard }

def:pub ResultScreen(
    mbti: str,
    title: str,
    quote: str,
    skin_tone: str,
    hair_color: str,
    traits: list[str],
    show_deep: bool,
    appearance: str,
    reality: str,
    strengths: list[str],
    flaws: list[str],
    onToggleDeep: EventHandler,
    onGenerateStory: EventHandler
) -> JsxElement {
    return
        <div style={{"maxWidth": "750px", "margin": "1rem auto"}}>
            <div
                style={{
                    "background": "#161b26",
                    "borderRadius": "24px",
                    "padding": "2.5rem",
                    "border": "1px solid rgba(255, 255, 255, 0.1)",
                    "boxShadow": "0 25px 50px -12px rgba(0, 0, 0, 0.7)"
                }}
            >
                <div style={{"textAlign": "center", "marginBottom": "2rem"}}>
                    <span
                        style={{
                            "fontSize": "0.8rem",
                            "padding": "0.3rem 0.8rem",
                            "borderRadius": "20px",
                            "background": "rgba(99, 102, 241, 0.2)",
                            "color": "#818cf8",
                            "fontWeight": "700"
                        }}
                    >
                        MBTI Baseline: {mbti}
                    </span>
                    <h1
                        style={{
                            "fontSize": "2.5rem",
                            "fontWeight": "900",
                            "margin": "0.75rem 0 0.5rem 0",
                            "color": "#ffffff"
                        }}
                    >
                        {title}
                    </h1>
                    <p style={{"color": "#94a3b8", "fontStyle": "italic"}}>"{quote}"</p>
                </div>

                <div
                    style={{
                        "width": "280px",
                        "height": "280px",
                        "margin": "0 auto 2rem auto",
                        "borderRadius": "20px",
                        "background": "linear-gradient(135deg, #1e1b4b, #3b0764)",
                        "border": "2px solid #a855f7",
                        "display": "flex",
                        "flexDirection": "column",
                        "alignItems": "center",
                        "justifyContent": "center",
                        "textAlign": "center",
                        "padding": "1rem"
                    }}
                >
                    <div style={{"fontSize": "4rem", "marginBottom": "0.5rem"}}>🏴‍☠️</div>
                    <span style={{"fontWeight": "700", "color": "#c084fc"}}>{mbti} Captain Caricature</span>
                    <span style={{"fontSize": "0.75rem", "color": "#94a3b8", "marginTop": "0.4rem"}}>Fused with {skin_tone} skin & {hair_color} hair</span>
                </div>

                <div style={{"display": "flex", "flexWrap": "wrap", "gap": "0.6rem", "justifyContent": "center", "marginBottom": "2rem"}}>
                    {[
                        <BadgeCard key={idx} label={trait}/>
                        for (idx, trait) in enumerate(traits)
                    ]}
                </div>

                <div style={{"display": "flex", "gap": "1rem", "justifyContent": "center", "marginBottom": "2rem"}}>
                    <button
                        onClick={onGenerateStory}
                        style={{
                            "padding": "0.8rem 1.8rem",
                            "borderRadius": "12px",
                            "background": "linear-gradient(135deg, #6366f1, #a855f7)",
                            "color": "#fff",
                            "fontWeight": "700",
                            "border": "none",
                            "cursor": "pointer"
                        }}
                    >
                        📱 Generate 9:16 Story Poster
                    </button>

                    <button
                        onClick={onToggleDeep}
                        style={{
                            "padding": "0.8rem 1.8rem",
                            "borderRadius": "12px",
                            "background": "rgba(255, 255, 255, 0.08)",
                            "color": "#fff",
                            "fontWeight": "600",
                            "border": "1px solid rgba(255, 255, 255, 0.2)",
                            "cursor": "pointer"
                        }}
                    >
                        📊 Toggle Deep Analysis
                    </button>
                </div>

                <div
                    style={{
                        "marginTop": "2rem",
                        "paddingTop": "2rem",
                        "borderTop": "1px solid rgba(255, 255, 255, 0.1)",
                        "textAlign": "left"
                    }}
                >
                    <h3 style={{"fontSize": "1.2rem", "fontWeight": "700", "color": "#c084fc", "marginBottom": "1rem"}}>Appearance vs. Reality</h3>
                    <p style={{"color": "#cbd5e1", "marginBottom": "0.5rem"}}><strong>Appearance:</strong> {appearance}</p>
                    <p style={{"color": "#cbd5e1", "marginBottom": "1.5rem"}}><strong>Reality:</strong> {reality}</p>

                    <h4 style={{"color": "#818cf8", "marginBottom": "0.75rem"}}>Synthesized Behavioral Profile</h4>
                    <div style={{"display": "grid", "gridTemplateColumns": "1fr 1fr", "gap": "1rem"}}>
                        <div>
                            <h5 style={{"color": "#4ade80", "marginBottom": "0.4rem"}}>Unfiltered Strengths</h5>
                            <p style={{"color": "#94a3b8", "fontSize": "0.85rem", "margin": "0.2rem 0"}}>⚡ High Vibe Energy & Idea Generation</p>
                            <p style={{"color": "#94a3b8", "fontSize": "0.85rem", "margin": "0.2rem 0"}}>⚡ Rapid Adaptability in Chaos</p>
                        </div>
                        <div>
                            <h5 style={{"color": "#f87171", "marginBottom": "0.4rem"}}>Unfiltered Cautions</h5>
                            <p style={{"color": "#94a3b8", "fontSize": "0.85rem", "margin": "0.2rem 0"}}>⚠️ Zero Finishing Ability</p>
                            <p style={{"color": "#94a3b8", "fontSize": "0.85rem", "margin": "0.2rem 0"}}>⚠️ 2 AM Overthinking Spiral</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>;
}
