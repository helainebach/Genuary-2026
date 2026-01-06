import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#0F0404, #FFF9EB, #365639, #FFD36C, #FFA395};
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 4;
PImage photo;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  photo = loadImage("fish.png");
  photo.resize(width, height);
}

void draw() {
  background(palette[0]);
  image(photo, 0, 0, width, height);

  int u = 10;
  for (int y = 0; y < height; y=y+u) {
    for (int x = 0; x <width; x=x+u) {
      color c = closestColor(photo.get(x, y));
      fill(c);
      noStroke();
      square(x, y, u);
    }
  }
  sig(day, prompts.getString(day - 1, "prompt"), true, 1, 0);
  off += rate;
  // record();
}

// Find the closest color in the palette to a target color
color closestColor(color target) {
  float minDistance = Float.MAX_VALUE;
  color closest = palette[0];

  float targetR = red(target);
  float targetG = green(target);
  float targetB = blue(target);

  for (color c : palette) {
    float r = red(c);
    float g = green(c);
    float b = blue(c);

    // Calculate Euclidean distance in RGB space
    float distance = sqrt(pow(targetR - r, 2) + pow(targetG - g, 2) + pow(targetB - b, 2));

    if (distance < minDistance) {
      minDistance = distance;
      closest = c;
    }
  }

  return closest;
}

// Alternative: Find closest color using perceptual weighting (more accurate to human vision)
color closestColorPerceptual(color target) {
  float minDistance = Float.MAX_VALUE;
  color closest = palette[0];

  float targetR = red(target);
  float targetG = green(target);
  float targetB = blue(target);

  for (color c : palette) {
    float r = red(c);
    float g = green(c);
    float b = blue(c);

    // Perceptual weighting: green is more important to human vision
    float distance = sqrt(2 * pow(targetR - r, 2) + 4 * pow(targetG - g, 2) + 3 * pow(targetB - b, 2));

    if (distance < minDistance) {
      minDistance = distance;
      closest = c;
    }
  }

  return closest;
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
