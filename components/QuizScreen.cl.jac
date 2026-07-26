"""Quiz Screen Component."""

def:pub QuizScreen(
    current_q: int,
    total_q: int,
    dim: str,
    prompt: str,
    opt_a: str,
    opt_b: str,
    freeform_text: str,
    onSelectA: EventHandler,
    onSelectB: EventHandler,
    onTextChange: EventHandler,
    onKeyDownInput: EventHandler,
    onPrevQ: EventHandler
) -> JsxElement {
    progress_pct = int(((current_q + 1) / total_q) * 100);
    pct_str = f"{progress_pct}%";

    return
        <div style={{"maxWidth": "650px", "margin": "1rem auto"}}>
            <div style={{"marginBottom": "1.5rem"}}>
                <div style={{"display": "flex", "justifyContent": "space-between", "alignItems": "center", "fontSize": "0.85rem", "color": "#94a3b8", "marginBottom": "0.5rem"}}>
                    <div style={{"display": "flex", "alignItems": "center", "gap": "0.75rem"}}>
                        {current_q > 0 ? (
                            <button
                                onClick={onPrevQ}
                                style={{
                                    "padding": "0.2rem 0.6rem",
                                    "borderRadius": "6px",
                                    "background": "rgba(255, 255, 255, 0.08)",
                                    "color": "#cbd5e1",
                                    "border": "1px solid rgba(255, 255, 255, 0.15)",
                                    "cursor": "pointer",
                                    "fontSize": "0.8rem"
                                }}
                            >
                                ← Back
                            </button>
                        ) : None}
                        <span>Question {current_q + 1} of {total_q}</span>
                    </div>
                    <span>{pct_str} Completed</span>
                </div>
                <div style={{"width": "100%", "height": "8px", "background": "#1e293b", "borderRadius": "4px", "overflow": "hidden"}}>
                    <div style={{"width": pct_str, "height": "100%", "background": "linear-gradient(90deg, #6366f1, #a855f7)"}}></div>
                </div>
            </div>

            <div
                style={{
                    "background": "#161b26",
                    "borderRadius": "20px",
                    "padding": "2rem",
                    "border": "1px solid rgba(255, 255, 255, 0.08)"
                }}
            >
                <span style={{"fontSize": "0.75rem", "color": "#a855f7", "fontWeight": "700", "textTransform": "uppercase", "letterSpacing": "1px"}}>
                    Dimension: {dim}
                </span>
                <h2 style={{"fontSize": "1.35rem", "fontWeight": "700", "margin": "0.75rem 0 1.5rem 0", "lineHeight": "1.4"}}>
                    {prompt}
                </h2>

                <div style={{"display": "flex", "flexDirection": "column", "gap": "1rem", "marginBottom": "1.5rem"}}>
                    <button
                        onClick={onSelectA}
                        style={{
                            "padding": "1.2rem",
                            "borderRadius": "12px",
                            "background": "rgba(255, 255, 255, 0.03)",
                            "border": "1px solid rgba(255, 255, 255, 0.1)",
                            "color": "#f1f5f9",
                            "textAlign": "left",
                            "fontSize": "1rem",
                            "cursor": "pointer"
                        }}
                    >
                        <strong style={{"color": "#818cf8", "marginRight": "0.5rem"}}>A.</strong> {opt_a}
                    </button>

                    <button
                        onClick={onSelectB}
                        style={{
                            "padding": "1.2rem",
                            "borderRadius": "12px",
                            "background": "rgba(255, 255, 255, 0.03)",
                            "border": "1px solid rgba(255, 255, 255, 0.1)",
                            "color": "#f1f5f9",
                            "textAlign": "left",
                            "fontSize": "1rem",
                            "cursor": "pointer"
                        }}
                    >
                        <strong style={{"color": "#c084fc", "marginRight": "0.5rem"}}>B.</strong> {opt_b}
                    </button>
                </div>

                <div style={{"marginTop": "1rem"}}>
                    <label style={{"fontSize": "0.8rem", "color": "#94a3b8", "display": "block", "marginBottom": "0.4rem"}}>
                        Optional Context / Unhinged Comment (Press Enter ↵ or Next to advance):
                    </label>
                    <div style={{"display": "flex", "gap": "0.5rem"}}>
                        <input
                            type="text"
                            value={freeform_text}
                            onChange={onTextChange}
                            onKeyDown={onKeyDownInput}
                            placeholder="e.g. 'I start 5 projects at 2 AM and finish none'"
                            style={{
                                "flex": "1",
                                "padding": "0.75rem",
                                "borderRadius": "8px",
                                "background": "#0d0f17",
                                "border": "1px solid #334155",
                                "color": "#f1f5f9",
                                "fontSize": "0.9rem"
                            }}
                        />
                        <button
                            onClick={onSelectA}
                            style={{
                                "padding": "0.75rem 1.2rem",
                                "borderRadius": "8px",
                                "background": "linear-gradient(135deg, #6366f1, #a855f7)",
                                "color": "#ffffff",
                                "fontWeight": "700",
                                "border": "none",
                                "cursor": "pointer",
                                "whiteSpace": "nowrap"
                            }}
                        >
                            Next ➔
                        </button>
                    </div>
                </div>
            </div>
        </div>;
}
