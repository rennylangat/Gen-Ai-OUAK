import random;
import from byllm.llm { Model }


glob llm = Model(model_name="gpt-4o", verbose=False);


walker GeoGuesser {
    has position: Point;
    has target: Point = Point(random(-100, 100), random(-100, 100));
    has placeName: str = "Unknown";
    has score: int = 0;
    has attempts: int = 0;
    has max_attempts: int = 10;
    has found: bool = false;

    can init with `root entry;
    can pr_guess with score entry;
    can pr_end with entry;
}


with entry:__main__ {
    GeoGuesser.init();
}


impl GeoGuesser.init{
    this.position = Point(0, 0);
    this.target = Point(random(-100, 100), random(-100, 100));
    this.placeName = "Unknown";
    this.score = 0;
    this.attempts = 0;
    this.max_attempts = 10;
    this.found = false;
    # We need to initialise the LLM here
    llm =
        Model(model_name="gpt-4o", verbose=False);
}


impl GeoGuesser.pr_guess{ }


impl GeoGuesser.pr_end{ }
