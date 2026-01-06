import java.text.SimpleDateFormat;
import java.util.Date;

color[] palette = {#0F0404, #FFF9EB, #365639, #FFD36C, #FFA395};
String pathDATA = "../../_data/";
Table prompts;
Table morse;
String folderName;
PFont font;
float off = 0;
float rate = PI / 150;
int day = 5;
String genuaryMorse = "";
ArrayList<String> morseLetters;

void setup() {
  size(1080, 1080);
  folderName = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
  font = createFont(pathDATA + "ubuntu.ttf", 20);
  prompts = loadTable(pathDATA + "prompts.csv", "header");
  morse = loadTable("morse.csv");

  // Convert "GENUARY" to morse code
  String word = "GENUARY";
  morseLetters = new ArrayList<String>();
  genuaryMorse = "";

  for (int i = 0; i < word.length(); i++) {
    char letter = word.charAt(i);
    for (int j = 0; j < morse.getRowCount(); j++) {
      if (morse.getString(j, 0).equals(str(letter))) {
        String morseCode = morse.getString(j, 1);
        morseLetters.add(morseCode);
        genuaryMorse += morseCode + " ";
        break;
      }
    }
  }
}

void draw() {
  background(palette[4]);

  // Draw morse code visualization
  fill(palette[2]);
  textAlign(CENTER, CENTER);
  textSize(50);
  text(genuaryMorse, width/2,height/2);

  sig(day, prompts.getString(day - 1, "prompt"), false, 2, 0);
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
