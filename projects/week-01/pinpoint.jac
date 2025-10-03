import json;
import from byllm { Model }
glob llm = Model(model_name="gemini/gemini-2.0-flash");


obj Puzzle {
    has category: str;
    has words: list[str];
}


def send_prompt(prompt: str) -> Puzzle by llm();


def send_synonym_check(prompt: str) -> str by llm();


def convert_to_json(response: str) -> dict {
    return {"category" : response["category"] , "words" : response["words"] };
}


def get_user_input()  -> str {
    return input();
}


def calculate_score(attempts: int, max_attempts: int = 4) -> float {
    if attempts > max_attempts {
        return 0.0;
    }
    return 1.0 - ((attempts - 1) * (1.0 / max_attempts));
}


def check_synonym(user_answer: str, correct_answer: str, word_list: list[str]) -> str {
    prompt =
        f"In a word game, the clues were {word_list}. The correct category is '{correct_answer}'. A user guessed '{user_answer}'. Are these two phrases contextually synonymous or equivalent for this game? Respond with only 'YES' or 'NO'.";
    response = send_synonym_check(prompt=prompt);
    print("Synonym check response from Gemini:", response);
    return response;
}


def check_answer(user_answer: str, correct_answer: str, word_list: list[str]) -> bool {
    print(
        "Checking user answer:",
        user_answer.lower(),
        "against correct answer:",
        correct_answer.lower()
    );
    if (correct_answer.lower().find(user_answer.lower()) != -1) {
        print("Direct match found.");
        return True;
    }
    print("Direct match failed. Checking for synonyms...");
    synonym_check =
        check_synonym(
            correct_answer=correct_answer,
            user_answer=user_answer,
            word_list=[]
        );
    if (synonym_check == "YES" || synonym_check == "OK" ) {
        return True;
    } else {
        return False;
    }
}


with entry {
    print("Welcome to PinPoint Game!");
    print("Generating a new puzzle from Gemini");
    puzzle_prompt =
        "Generate a single, clever puzzle for a word game. The puzzle must have a list of 4 distinct words and a single category that connects them. The category should be a short phrase. Provide your response as a single JSON object with two keys: 'category' (a string) and 'words' (a list of 4 strings).";
    llm_response = send_prompt(puzzle_prompt);
    assert isinstance(llm_response, Puzzle) ;
    correct_category = llm_response.category;
    guesses_made = 0;
    score = 100;
    has_won = False;
    print(
        "Puzzle is ready. You have 4 chances to guess the category. Let the games begin"
    );
    print(
        "----------------------------------------------------------------------------"
    );
    while guesses_made < 4 and not has_won  {
        print(llm_response.words[guesses_made]);
        user_input = get_user_input();
        guesses_made += 1;
        is_correct =
            check_answer(user_input, llm_response.category, llm_response.words);
        if is_correct {
            has_won = True;
            score = calculate_score(guesses_made);
            print(
                "Congratulations! You've guessed the category correctly. The category is:",
                llm_response.category
            );
            print("Your score is:", score * 100, "%");
        } else {
            print("Incorrect guess. Try again.");
            if guesses_made == 4 {
                print(
                    "Sorry, you've used all your attempts. The correct category was:",
                    llm_response.category
                );
                score = 0;
                print("Your score is:", score * 100, "%");
            }
        }
    }
}


with entry:__main__ { }


# We are creating a word pinpoint game



#  The game is very simple. You are prompted with a collection of words and you need to give the



# answer as to what connects or explains them. All 5 clues belong to a common category. Guess the category in as few clue reveals as possible.



# Example:



# 1. Amboseli



# 2. Maasai Mara



# 3. Serengetti



# 4. Tsavo



# Answer - National Parks



# For each wrong answer you give, the weighted score reduces i.e getting right on first try earns you 1.0 =100%



# and getting it right on the fourth try earns you 0.25 = 25%



# We need a nodes to hold the words, the answer and the score



# We need an edge to hold the relationship between the words and the answer



# We need walkers to hold the current position in the graph



# At the point of user input, we need to check if the answer is correct or not

