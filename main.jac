"""
Hyper-Personalized Personality & Caricature Avatar Generator Entry Point.
"""

import from endpoints { TraitArchetype, SubmitLikeness, InitSession }

cl {
    import from .frontend { app as ClientApp }

    def:pub app -> JsxElement {
        return <ClientApp/>;
    }
}
