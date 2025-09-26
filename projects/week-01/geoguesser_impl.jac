impl GeoGuesser.init{
    this.position = Point(0, 0);
    this.target = Point(random(-100, 100), random(-100, 100));
    this.placeName = "Unknown";
    this.score = 0;
    this.attempts = 0;
    this.max_attempts = 10;
    this.found = false;
}


impl GeoGuesser.pr_guess{ }


impl GeoGuesser.pr_end{ }
