from  random import choice

def get_response(user_input: str) -> str:
    lowered: str = user_input.lower()

    if lowered == '':
        return 'Well, you\'re awfully silent...'
    elif 'hello' in lowered:
        return 'Hello there!'
    elif 'how are you' in lowered:
        return 'Good, thanks!'
    elif 'bye' in lowered:
            return 'See you!'
    else:
        return choice(['I do not understand...',
        'What are you talking about dude?',
        'I seem to not know what you mean'])