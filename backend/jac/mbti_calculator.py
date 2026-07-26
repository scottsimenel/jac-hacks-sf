"""
Deterministic MBTI Scoring Calculator.
Calculates 4-letter MBTI type code (EI, SN, TF, JP) and dimension point breakdown.
"""

def calculate_mbti_type(answers):
    """
    answers: list of dicts with 'dimension' ('EI', 'SN', 'TF', 'JP') and 'choice' (1 or 2)
    """
    scores = {
        'E': 0, 'I': 0,
        'S': 0, 'N': 0,
        'T': 0, 'F': 0,
        'J': 0, 'P': 0
    }

    for item in answers:
        dimension = item.get('dimension')
        choice = int(item.get('choice', 1))

        if dimension == 'EI':
            if choice == 1:
                scores['E'] += 1
            else:
                scores['I'] += 1
        elif dimension == 'SN':
            if choice == 1:
                scores['S'] += 1
            else:
                scores['N'] += 1
        elif dimension == 'TF':
            if choice == 1:
                scores['T'] += 1
            else:
                scores['F'] += 1
        elif dimension == 'JP':
            if choice == 1:
                scores['J'] += 1
            else:
                scores['P'] += 1

    # Myers-Briggs official tie-breaker rule: on exact tie, choose I, N, F, P
    mbti_type = ''
    mbti_type += 'E' if scores['E'] > scores['I'] else 'I'
    mbti_type += 'S' if scores['S'] > scores['N'] else 'N'
    mbti_type += 'T' if scores['T'] > scores['F'] else 'F'
    mbti_type += 'J' if scores['J'] > scores['P'] else 'P'

    return {
        'scores': scores,
        'type': mbti_type
    }
