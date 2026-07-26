"""Implementations for the Jac Client App Component."""

impl app.startQuiz -> None {
    step = "quiz";
    current_q = 0;
}

impl app.selectChoiceA -> None {
    ans_item = {
        "question_id": q_item["id"],
        "dimension": q_item["dim"],
        "choice": 1,
        "freeform_text": freeform_input
    };
    user_answers = user_answers + [ans_item];
    freeform_input = "";

    if current_q + 1 < len(questions_list) {
        current_q = current_q + 1;
    } else {
        step = "likeness";
    }
}

impl app.selectChoiceB -> None {
    ans_item = {
        "question_id": q_item["id"],
        "dimension": q_item["dim"],
        "choice": 2,
        "freeform_text": freeform_input
    };
    user_answers = user_answers + [ans_item];
    freeform_input = "";

    if current_q + 1 < len(questions_list) {
        current_q = current_q + 1;
    } else {
        step = "likeness";
    }
}

impl app.updateFreeform(e: ChangeEvent) -> None {
    freeform_input = e.target.value;
}

impl app.updateSkin(e: ChangeEvent) -> None {
    skin_tone = e.target.value;
}

impl app.updateHair(e: ChangeEvent) -> None {
    hair_color = e.target.value;
}

impl app.updateGender(e: ChangeEvent) -> None {
    gender_expression = e.target.value;
}

impl app.prevQuestion -> None {
    if current_q > 0 {
        current_q = current_q - 1;
    }
}

impl app.submitLikeness -> None {
    step = "loading";
    
    # Spawn SubmitLikeness walker to backend server endpoints
    res = root spawn SubmitLikeness(
        session_id=session_id,
        likeness_type=likeness_mode,
        photo_url=photo_url,
        skin_tone=skin_tone,
        hair_color=hair_color,
        hair_style=hair_style,
        gender_expression=gender_expression,
        accessories=accessories
    );

    if len(res.reports) > 0 {
        archetype = res.reports[0];
        result_title = archetype.unhinged_title;
        result_mbti = archetype.mbti_anchor;
        result_traits = archetype.top_traits;
        result_quote = archetype.summary_quote;
        result_appearance = archetype.appearance_text;
        result_reality = archetype.reality_text;
        result_strengths = archetype.strengths;
        result_flaws = archetype.flaws;
    }

    step = "result";
}

impl app.toggleDeep -> None {
    show_deep_analysis = not show_deep_analysis;
}

impl app.generateStory -> None {
    show_story_card = True;
}

impl app.triggerReRoll -> None {
    step = "loading";
    step = "result";
}
