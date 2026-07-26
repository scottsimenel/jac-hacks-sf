"""Trait Badge Card Component."""

def:pub BadgeCard(label: str) -> JsxElement {
    return
        <span
            style={{
                "padding": "0.5rem 1rem",
                "borderRadius": "30px",
                "background": "rgba(255, 255, 255, 0.05)",
                "border": "1px solid rgba(255, 255, 255, 0.12)",
                "fontSize": "0.85rem",
                "fontWeight": "600",
                "color": "#f1f5f9"
            }}
        >
            🔥 {label}
        </span>;
}
