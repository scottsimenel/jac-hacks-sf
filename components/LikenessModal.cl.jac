"""Post-Quiz Avatar Personalization Modal Component."""

def:pub LikenessModal(
    likeness_mode: str,
    skin_tone: str,
    hair_color: str,
    gender_expression: str,
    onSetModeAttr: EventHandler,
    onSetModePhoto: EventHandler,
    onSkinChange: EventHandler,
    onHairChange: EventHandler,
    onGenderChange: EventHandler,
    onSubmit: EventHandler
) -> JsxElement {
    attr_bg = "#a855f7" if likeness_mode == "attributes" else "transparent";
    photo_bg = "#a855f7" if likeness_mode == "photo" else "transparent";

    return
        <div style={{"maxWidth": "600px", "margin": "2rem auto", "textAlign": "center"}}>
            <div
                style={{
                    "background": "#161b26",
                    "borderRadius": "24px",
                    "padding": "2.5rem",
                    "border": "1px solid rgba(168, 85, 247, 0.3)"
                }}
            >
                <h2 style={{"fontSize": "1.8rem", "fontWeight": "800", "marginBottom": "0.5rem"}}>🎨 Customize Your Caricature Avatar</h2>
                <p style={{"color": "#94a3b8", "fontSize": "0.95rem", "marginBottom": "2rem"}}>
                    Quiz complete! Specify your likeness parameters so Agent 3 can paint your personalized avatar.
                </p>

                <div style={{"display": "flex", "gap": "1rem", "justifyContent": "center", "marginBottom": "2rem"}}>
                    <button
                        onClick={onSetModeAttr}
                        style={{
                            "padding": "0.6rem 1.2rem",
                            "borderRadius": "8px",
                            "background": attr_bg,
                            "color": "#ffffff",
                            "border": "1px solid #a855f7",
                            "cursor": "pointer"
                        }}
                    >
                        Manual Physical Attributes
                    </button>
                    <button
                        onClick={onSetModePhoto}
                        style={{
                            "padding": "0.6rem 1.2rem",
                            "borderRadius": "8px",
                            "background": photo_bg,
                            "color": "#ffffff",
                            "border": "1px solid #a855f7",
                            "cursor": "pointer"
                        }}
                    >
                        Upload Selfie / Photo
                    </button>
                </div>

                <div style={{"display": "flex", "flexDirection": "column", "gap": "1rem", "textAlign": "left", "marginBottom": "2rem"}}>
                    <div>
                        <label style={{"fontSize": "0.85rem", "color": "#94a3b8"}}>Skin Tone:</label>
                        <input type="text" value={skin_tone} onChange={onSkinChange} style={{"width": "100%", "padding": "0.6rem", "borderRadius": "6px", "background": "#0d0f17", "border": "1px solid #334155", "color": "#fff"}}/>
                    </div>
                    <div>
                        <label style={{"fontSize": "0.85rem", "color": "#94a3b8"}}>Hair Color & Style:</label>
                        <input type="text" value={hair_color} onChange={onHairChange} style={{"width": "100%", "padding": "0.6rem", "borderRadius": "6px", "background": "#0d0f17", "border": "1px solid #334155", "color": "#fff"}}/>
                    </div>
                    <div>
                        <label style={{"fontSize": "0.85rem", "color": "#94a3b8"}}>Gender Expression:</label>
                        <input type="text" value={gender_expression} onChange={onGenderChange} style={{"width": "100%", "padding": "0.6rem", "borderRadius": "6px", "background": "#0d0f17", "border": "1px solid #334155", "color": "#fff"}}/>
                    </div>
                </div>

                <button
                    onClick={onSubmit}
                    style={{
                        "width": "100%",
                        "padding": "1rem",
                        "fontSize": "1.1rem",
                        "fontWeight": "700",
                        "borderRadius": "12px",
                        "background": "linear-gradient(135deg, #6366f1, #a855f7)",
                        "color": "#ffffff",
                        "border": "none",
                        "cursor": "pointer"
                    }}
                >
                    ⚡ Generate My Custom Avatar & Archetype
                </button>
            </div>
        </div>;
}
