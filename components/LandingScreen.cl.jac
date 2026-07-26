"""Landing Screen Component."""

def:pub LandingScreen(onStart: EventHandler) -> JsxElement {
    return
        <div style={{"maxWidth": "700px", "margin": "3rem auto", "textAlign": "center"}}>
            <div
                style={{
                    "display": "inline-block",
                    "padding": "0.4rem 1rem",
                    "borderRadius": "30px",
                    "background": "rgba(168, 85, 247, 0.15)",
                    "color": "#c084fc",
                    "fontSize": "0.85rem",
                    "fontWeight": "600",
                    "marginBottom": "1.5rem",
                    "border": "1px solid rgba(168, 85, 247, 0.3)"
                }}
            >
                ✨ MBTI Is Dead. Long Live Hyper-Personalized Chaos.
            </div>

            <h1
                style={{
                    "fontSize": "2.8rem",
                    "fontWeight": "900",
                    "lineHeight": "1.1",
                    "marginBottom": "1.5rem",
                    "color": "#ffffff"
                }}
            >
                Discover Your Unhinged Personality Title & Caricature Avatar
            </h1>

            <p style={{"fontSize": "1.1rem", "color": "#94a3b8", "marginBottom": "2.5rem", "lineHeight": "1.6"}}>
                Take the 28-question adaptive quiz. Agent 2 synthesizes your expressive title (Captain, Low-Key Legend, Main Character), and Agent 3 paints a custom 3-layer caricature avatar blending your visual likeness!
            </p>

            <button
                onClick={onStart}
                style={{
                    "padding": "1rem 2.5rem",
                    "fontSize": "1.15rem",
                    "fontWeight": "700",
                    "borderRadius": "14px",
                    "background": "linear-gradient(135deg, #6366f1, #a855f7)",
                    "color": "#ffffff",
                    "border": "none",
                    "cursor": "pointer"
                }}
            >
                🚀 Start Test (Zero Upfront Barrier)
            </button>
        </div>;
}
