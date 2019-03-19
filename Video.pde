class Video extends Animation {
  Movie movie;
  float volume=1, playWidth, playHeight;
  Video(WSN wsn, String path) {
    movie = new Movie(wsn, path);
  }
  void display(int mode, float x, float y, float factor) {
    switch(mode) {
    case GUI.SCALE:
      animeWidth=gui.unit(movie.width)*factor;
      animeHeight=gui.unit(movie.height)*factor;
      break;
    case GUI.WIDTH:
      animeWidth=factor;
      animeHeight=movie.height*factor/movie.width;
      break;
    case GUI.HEIGHT:
      animeWidth=movie.width*factor/movie.height;
      animeHeight=factor;
    }
    image(movie, x, y, animeWidth, animeHeight);
  }
  void play() {
    movie.play();
    isPlaying=true;
  }
  void repeat() {
    isPlaying=true;
    movie.loop();
  }
  void end() {
    isPlaying=false;
    movie.stop();
  }
  void pause() {
    isPlaying=false;
    movie.pause();
  }
  int hours() {
    return round(movie.time())/3600;
  }
  int minutes() {
    return round(movie.time()%3600)/60;
  }
  int seconds() {
    return round(movie.time())%60;
  }
  float position() {
    return movie.time()/movie.duration();
  }
}
