import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import java.util.Calendar;
import java.io.File;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
int imgplace;
float[] l = new float[4];
Minim minim;
String[] songList = {"sample.mp3", "sample2.mp3", "sample3.mp3", "sample4.mp3"};
AudioPlayer[] player = new AudioPlayer[songList.length];
AudioInput input;
PImage pic;
PImage play;
PImage pause;
PImage forward5;
float linepos;
float lineposs;
boolean playing;
PImage next;
PImage previous;
String[] imglist = {"smplimg0.jpg", "smplimg1.jpg", "smplimg2.jpg", "smplimg3.jpg"};
PImage[] smplimg = new PImage[imglist.length];
float track;
AudioMetaData[] meta = new AudioMetaData[songList.length];
int songPlace = 0;
String title;
PFont titleFont;
float x;
float time;
float timer;
int secs;
int mins = 0;
float secsend;
float minsend;
int b;
int z;
int displaysecs;
DateFormat formatter = new SimpleDateFormat("mm:ss");
void setup() {

  fullScreen();
  minim = new Minim(this);
  for (int i=0; i < songList.length; i++) {
    player[i] = minim.loadFile(songList[i]);
    linepos = l[i];
    meta[i] = player[i].getMetaData();
    smplimg[i] = loadImage(imglist[i]);
    l[0]  = (9221/560.06);
    l[1] =(289906/560.06);
    l[2] = (352130/560.06);
    l[3] = (357120/560.06);
  }
  if (secs == 61) {
    z+=60;
  }
}
void draw() {
  if (songPlace == 0) {
    x = l[0];
  }   
  if (songPlace == 1) {
    x = l[1];
  } 
  if (songPlace == 2) {
    x = l[2];
  }
  if (songPlace == 3) {
    x = l[3];
  }
  println(player[songPlace].position  ());
  play = loadImage("play.jpg");
  pause = loadImage("pause.jpg");
  forward5 = loadImage("forward5.jpg");
  next = loadImage("next.jpg");
  previous = loadImage("previous.jpg");
  background(51);
  strokeWeight(1);
  fill(255);
  rectMode(CORNER);
  rect(displayWidth*.25, displayHeight*.25, displayWidth*.5, displayHeight*.5);//main
  rect(displayWidth*.25, displayHeight*.25, displayWidth*.47, displayHeight*.03);//titlebar
  rect(displayWidth*.3, displayHeight*.45, displayWidth*.41, displayHeight*.1);//bar
  imageMode(CORNER);
  image(play, displayWidth*.375, displayHeight*.625, displayWidth*.05, displayHeight*.1);
  image(pause, displayWidth*.6, displayHeight*.625, displayWidth*.1, displayHeight*.1);
  image(next, displayWidth*.425, displayHeight*.625, displayWidth*.025, displayHeight*.1);
  image(previous, displayWidth*.325, displayHeight*.625, displayWidth*.025, displayHeight*.1);
  pic = loadImage("exitbutton.png");
  fill(255);
  pushMatrix();
  fill(255, 0, 0);  
  if (mouseX > displayWidth*.72 && mouseX < displayWidth*.75 && mouseY > displayHeight*.25 && mouseY < displayHeight*.28) {
    rect(displayWidth*.72, displayHeight*.25, displayWidth*.03, displayHeight*.03);
  } else {
    image(pic, displayWidth*.72, displayHeight*.25, displayWidth*.03, displayHeight*.03);
  }
  popMatrix();
  strokeWeight(2);
  fill(0, 255, 0);
  lineposs = player[songPlace].position()/x;
  line(displayWidth*.3 + lineposs, displayHeight*.45, displayWidth*.3 + lineposs, displayHeight*.55);
  fill(0);
  textAlign(CORNER);
  text(meta[songPlace].fileName(), displayWidth*.3, displayHeight*.44);
  textAlign(CORNER);
  titleFont = createFont("ACaslonPro-Bold-48", displayHeight*.06);
  textFont(titleFont, displayHeight*.02);
  text("Music Player/" + meta[songPlace].fileName(), displayWidth*.26, displayHeight*.27, displayWidth*.75);
  Calendar positionTime = Calendar.getInstance();
  Calendar positionTimer = Calendar.getInstance();
  positionTime.setTimeInMillis(player[songPlace].position());
  positionTimer.setTimeInMillis(player[songPlace].length());
  text(formatter.format(positionTime.getTime()), displayWidth*.645, displayHeight*.445);
  text("/", displayWidth*.675, displayHeight*.445);
  text(formatter.format(positionTimer.getTime()), displayWidth*.68, displayHeight*.445);
  imageMode(CENTER);
  image(smplimg[imgplace], displayWidth*.5, displayHeight*.4, displayWidth*.1, displayHeight*.1);
}
void mousePressed() {
  if (mouseX > displayWidth*.3 && mouseX < displayWidth*.71 && mouseY > displayHeight*.45 && mouseY < displayHeight*.55 && mousePressed) {
    float mousePos = map(mouseX, displayWidth*.3, displayWidth*.71, 0, player[songPlace].length());
    player[songPlace].cue(int(mousePos));
  }
  if (mouseX > displayWidth*.6 && mouseX < displayWidth*.7 && mouseY > displayHeight*.625 && mouseY < displayHeight*.725 && mousePressed) {
    player[songPlace].pause();
    playing = false;
  }
  if (mouseX > displayWidth*.375 && mouseX < displayWidth*.425 && mouseY > displayHeight*.625 && mouseY < displayHeight*.725 && mousePressed) {
    fill(255);
    rect(displayWidth*.3, displayHeight*.45, displayWidth*.41, displayHeight*.1);
    player[songPlace].play();
    player[songPlace].rewind();
    playing = true;
    time = millis();
  } 
  if (mouseX > displayWidth*.72 && mouseX < displayWidth*.75 && mouseY > displayHeight*.25 && mouseY < displayHeight*.28 && mousePressed) {
    exit();
  }
  if (mouseX > displayWidth*.425 && mouseX < displayWidth*.45 && mouseY > displayHeight*.625 && mouseY < displayHeight*.725 && mousePressed) {
    player[songPlace].cue(player[songPlace].length());
    songPlace++;
    imgplace++;
    if (songPlace > songList.length-1) {
      songPlace = 0;
      imgplace = 0;
    }
    player[songPlace].cue(0);
  }
  if (mouseX > displayWidth*.325 && mouseX < displayWidth*.35 && mouseY > displayHeight*.625 && mouseY < displayHeight*.725 && mousePressed) {
    player[songPlace].cue(player[songPlace].length());
    songPlace--;
    imgplace--;
    if (songPlace < 0) {
      songPlace = songList.length-1;
      imgplace = imglist.length-1;
    }
    player[songPlace].cue(0);
  }
}