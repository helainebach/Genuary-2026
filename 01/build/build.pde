import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#0F0404, #FFF9EB, #365639, #FFD36C, #FFA395};
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 1;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
}

void draw() {
  background(palette[0]);
  sig(day, prompts.getString(day - 1, "prompt"), true, 1, 0);
  noFill();
  stroke(palette[3]);
  strokeWeight(1);
  for (int j = 0; j < 20; ++j) {
    pushMatrix();
    translate(width/2, height/2);
    beginShape();
    int v = 10;
    int r = (width/3)-j*10;
    for (int i = 0; i < v; ++i) {
      float a = TWO_PI/v*i;
      float x = sin(a)*r;
      float y = cos(a)*r;
      vertex(x, y);
    }
    endShape(CLOSE);
    popMatrix();
  }

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
