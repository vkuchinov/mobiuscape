/*
mobiuscape: stitcherMkI [slit-scan]
semi-automatic version for still images of 1920px height

as a part of my MA thesis 'mobiuscapes' —
an experimental platform for taking Möbius-like
panoramas, turning landscapes inside out to
a paradoxical infinite ‘topsy-turvy’ state.

@author    Vladimir V. KUCHINOV
@email     helloworld@vkuchinov.co.uk

*/

import java.io.File;
import java.io.FilenameFilter;

String url = "churchAttic3";
int numFiles = 0;
int imgWidth = 4;
String prefix = "seq";

PImage output;

void setup() {

  numFiles = getNumJPG(url);
  size(imgWidth*numFiles, 1920);
  output = createImage( imgWidth * numFiles, 1920, RGB);
  
  for (int i = 1; i < numFiles; i++) {
   
    String path = url + "/" + prefix + nfs(i, 4).trim() + ".jpg";
    println(path);
    PImage tmp = loadImage(path);
    image(tmp, imgWidth*i, 0);
    
  }
  
  save(url + ".jpg");
  
}

int getNumJPG(String src) {

  File srcFolder = new java.io.File(dataPath(url + "/"));

  String[] filenames = srcFolder.list();

  return filenames.length;
  
}
