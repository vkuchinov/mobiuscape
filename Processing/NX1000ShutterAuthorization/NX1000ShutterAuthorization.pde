/*

 Controlling NX1000 camera from computer through ArduinoIDE/Processing
 bridge.
 
 REFERENCE
 https://learn.sparkfun.com/tutorials/connecting-arduino-to-processing
 http://op-co.de/blog/posts/hacking_the_nx300/
 */

import java.net.*;
import java.io.*;
import processing.serial.*;

Serial myPort;  
String val;    

void setup() {

  println(Serial.list());
  String portName = Serial.list()[3];
  //myPort = new Serial(this, portName, 9600);
  
  //controlNX();
  
  try {

    //creating socket
    String hostname = "192.168.16.1";
    int port = 7676;
    InetAddress  addr = InetAddress.getByName(hostname);
    Socket sock = new Socket(addr, port);

    BufferedReader rd = new BufferedReader(new InputStreamReader(sock.getInputStream()));

    //header
    String path = "/smp_2_";
    BufferedWriter  wr = new BufferedWriter(new OutputStreamWriter(sock.getOutputStream(), "UTF-8"));
    
    String xmldata = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
      + "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" "
      + "s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
      + "<s:Body>"
      + "<u:MULTIAF xmlns:u=\"urn:schemas-upnp-org:service:ContentDirectory:1\"></u:MULTIAF>"
      + "<u:Shot xmlns:u=\"urn:schemas-upnp-org:service:ContentDirectory:1\"></u:Shot>"
      + "</s:Body>"
      + "</s:Envelope>";

    wr.write("GET " + path + " HTTP/1.0\r\n");
    wr.write("User-Agent: SEC_RVF_{MAC ADRES}_r\n");
    wr.write("Access-Method: manual\r\n");
    wr.write("HOST: 192.168.16.1\n");
    wr.write("Connection: close\r\n");
    wr.write("\r\n");
    
    //Send second data
    System.out.println("sending data");
    wr.write(xmldata);
    wr.flush();
    
    // Response
    String line;
    while ( (line = rd.readLine ()) != null)
    println("response: " + line);

    sock.close();

  } 
  catch (Exception e) {
    e.printStackTrace();
    println("Ups, something wrong!");
  }
  
  
  
}

void draw() {
  
  val = "";
  controlNX();
//  if ( myPort.available() > 0) 
//  {  
//  val = myPort.readStringUntil('\n');  // read it and store it in val
//  if(val != null) { val.trim(); }
//  println("val is: " + val);
//  } 
//  
//  if(val != null && val.toUpperCase().contains("SHOOT'EM ALL!") == true) { controlNX(); }
  
}

void myDelay(int ms)
{
   try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e){}
}

void controlNX(){
  
  try {

    //creating socket
    String hostname = "192.168.16.1";
    int port = 7676;
    InetAddress  addr = InetAddress.getByName(hostname);
    Socket sock = new Socket(addr, port);

    BufferedReader rd1 = new BufferedReader(new InputStreamReader(sock.getInputStream()));

    //header
    String path = "/smp_4_";
    BufferedWriter  wr1 = new BufferedWriter(new OutputStreamWriter(sock.getOutputStream(), "UTF-8"));
    
    String xmldata1 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
      + "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" "
      + "s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
      + "<s:Body>"
      + "<u:MULTIAF xmlns:u=\"urn:schemas-upnp-org:service:ContentDirectory:1\"></u:MULTIAF>"
      + "<u:Shot xmlns:u=\"urn:schemas-upnp-org:service:ContentDirectory:1\"></u:Shot>"
      + "</s:Body>"
      + "</s:Envelope>";

    wr1.write("POST " + path + " HTTP/1.0\r\n");
    wr1.write("Content-Type: text/xml; charset=\"utf-8\"\r\n");
    wr1.write("HOST: 192.168.16.1\n");
    wr1.write("Content-Length: " + xmldata1.length() + "\r\n");
    wr1.write("SOAPACTION: \"urn:schemas-upnp-org:service:ContentDirectory:1#MULTIAF\"\r\n");
    wr1.write("Connection: close\r\n");
    wr1.write("\r\n");
    
    //Send second data
    System.out.println("sending data");
    wr1.write(xmldata1);
    wr1.flush();
    
    // Response
    String line;
    while ( (line = rd1.readLine ()) != null)
    println("response: " + line);

    sock.close();
     
    //delay between focusing and triggering shutter
    myDelay(2000);

    
    addr = InetAddress.getByName(hostname);
    sock = new Socket(addr, port);
    
    BufferedReader rd2 = new BufferedReader(new InputStreamReader(sock.getInputStream()));

    //header
    BufferedWriter  wr2 = new BufferedWriter(new OutputStreamWriter(sock.getOutputStream(), "UTF-8"));
    
    String xmldata2 = "<?xml version=\"1.0\" encoding=\"utf-8\"?>"
      + "<s:Envelope xmlns:s=\"http://schemas.xmlsoap.org/soap/envelope/\" "
      + "s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\">"
      + "<s:Body>"
      + "<u:Shot xmlns:u=\"urn:schemas-upnp-org:service:ContentDirectory:1\"></u:Shot>"
      + "</s:Body>"
      + "</s:Envelope>";

    wr2.write("POST " + path + " HTTP/1.0\r\n");
    wr2.write("Content-Type: text/xml; charset=\"utf-8\"\r\n");
    wr2.write("HOST: 192.168.16.1\n");
    wr2.write("Content-Length: " + xmldata2.length() + "\r\n");
    wr2.write("SOAPACTION: \"urn:schemas-upnp-org:service:ContentDirectory:1#Shot\"\r\n");
    wr2.write("Connection: close\r\n");
    wr2.write("\r\n");
    
    //Send second data
    System.out.println("sending data");
    wr2.write(xmldata2);
    wr2.flush();

    // Response
    line = "";
    while ( (line = rd2.readLine ()) != null)
    println("response: " + line);

    //close socket
    sock.close();
    
  } 
  catch (Exception e) {
    e.printStackTrace();
    println("Ups, something wrong!");
  }
  
}

