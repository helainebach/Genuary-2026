import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#0F0404, #FFF9EB, #365639, #FFD36C, #FFA395};
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = HALF_PI;
float rate = PI / 180;
int day = 2;
int c = 3; // Start with palette[3]
float prevTanValue = 0;
boolean hasChangedColor = false; // Prevent multiple color changes

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[2]);
  float tanValue = tan(off);
  float x = map(tanValue, -10, 10, 0, width);
  float s = map(abs(tanValue), -10, 10, 150, 300);
  // Check if tan(off) reached the extreme values (ball at edges)
  if (((prevTanValue < 11 && tanValue >= 11) || (prevTanValue > -11 && tanValue <= -11)) && !hasChangedColor) {
    c = (c == 3) ? 4 : 3;
    hasChangedColor = true;
  }
  // Reset the flag when ball is in middle range (not at edges)
  if (tanValue > -8 && tanValue < 8) {
    hasChangedColor = false;
  }
  prevTanValue = tanValue;
  println(x);
  fill(palette[c]);
  noStroke();
  ellipse(x, height/2, s, 200);
  sig(day, prompts.getString(day - 1, "prompt"), false, 1, 2);
  off += rate;
  // record();
}

void record() {
  saveFrame("../exports/" + folderName + "/###.png");
  if (frameCount > TWO_PI / rate) exit();
}

void keyPressed() {
  switch(key) {
  case 'p':
    String fileName = new SimpleDateFormat("yyyyMMddHHmmss'.png'").format(new Date());
    saveFrame("../exports/" + folderName + "/" + fileName);
    break;
  }
}

void sig(int d, String prompt, boolean bg, int textCol, int bgCol) {
  String txt = "#genuary" + d + " // " + prompt + " // @helainebach";
  int n = txt.length();

  if (bg) {
    fill(palette[bgCol]);
    stroke(palette[bgCol]);
    strokeWeight(10);
    rectMode(CORNER);
    rect((width - 20) - n * 10, 20, n * 10, 20);
  }
  textFont(font);
  textAlign(RIGHT, TOP);
  fill(palette[textCol]);
  text(txt, width - 20, 20);
}
