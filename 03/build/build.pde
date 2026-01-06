import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#0F0404, #FFF9EB, #365639, #FFD36C, #FFA395};
String pathDATA = "../../_data/";
Table prompts;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 3;
IntList fibonacci;

void setup() {
  size(1080, 1080);

  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  fibonacci = new IntList();
  fibonacci.append(0);
  fibonacci.append(1);
}

void draw() {
  frameRate(2);
  background(palette[3]);
  sig(day, prompts.getString(day - 1, "prompt"), false, 2, 0);
  int n = fibonacci.size();
  int last = fibonacci.get(n-1);
  int penul = fibonacci.get(n-2);
  fibonacci.append(last+penul);
  
  stroke(palette[2]);
  strokeWeight(2);
  fill(palette[2]);
  text(last, width/2, height/2);
  
  for (int i = 0; i < fibonacci.size(); i++) {
    circle(0, height/2, fibonacci.get(i));
  }

  if(last>width/2)exit();


  println(fibonacci);

  off += rate;
  record();
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
