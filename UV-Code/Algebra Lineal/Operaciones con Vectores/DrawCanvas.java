import java.awt.*;
import java.awt.event.*;
import java.awt.geom.*;
import java.util.*;
import java.util.concurrent.ArrayBlockingQueue;

import javax.swing.*;

public class DrawCanvas extends JPanel {

   int gx;
   int gy;
   Graphics g;
   int scale = 18;
   Vectores v;

   public DrawCanvas(Vectores v) {
      this.v = v;
      setPreferredSize(new Dimension(2000, 2000));
   }

   public void drawLine(Graphics ng, double x, double y, double x2, double y2) {
      ((Graphics2D) ng).draw(new Line2D.Double(gx + x * scale, gy + (-y) * scale, gx + x2 * scale, gy + (-y2) * scale));
   }
   public void drawString(Graphics ng, String name, float x, float y) {
      ng.setFont(new Font("Arial", 1, scale));
      ((Graphics2D) ng).drawString(name+" = ("+x+", "+y+")", gx + x * scale + 10, gy + (-y) * scale -10);
   }
   public void fillOval(Graphics ng, double x, double y, double w, double h) {
      ((Graphics2D) ng).fill(new Arc2D.Double(gx + x * scale - w*scale/2, gy + (-y) * scale - h*scale/2, w * scale, h * scale, 0, 360, Arc2D.CHORD));
   }
   
   @Override
   public void paintComponent(Graphics g) {
      super.paintComponent(g);
      Graphics2D g2 = (Graphics2D) g;

      gx = getWidth() / 2;
      gy = getHeight() / 2;
      this.g = g;

      Stroke s = new BasicStroke(2);
      g2.setStroke(s);

      // Crea el plano principal
      createPlane(100);

      g.setColor(Color.BLACK);


      drawVector(g,"U", 9, 3, Color.BLUE);
      drawVector(g,"V", 7, 9, Color.RED);
      drawVector(g,"X", 20, 5, Color.BLACK);
      drawVector(g,"Y", 5, 20, Color.BLACK);
      drawFunction("U", "2");

      drawFunction("V", "3");

      sumaVectores("U", "V");
      sumaVectores("X", "Y");

   //  g.setColor(Color.YELLOW);    // set the drawing color
   //  g.drawLine(30, 40, 100, 200);
   //  g.drawOval(150, 180, 10, 10);
   //  g.drawRect(200, 210, 20, 30);
   //  g.setColor(Color.RED);       // change the drawing color
   //  g.fillOval(300, 310, 30, 50);
   //  g.fillRect(400, 350, 60, 50);
   
   //  g.setColor(Color.WHITE);
   //  g.setFont(new Font("Monospaced", Font.PLAIN, 12));
   //  g.drawString("Testing custom drawing ...", 10, 20);
   }

   public void createPlane(int n) {
      g.setColor(Color.LIGHT_GRAY);
      for (int i = -n; i <= n; i++) {
         drawLine(g, -n, i, n, i);
         drawLine(g, i, -n, i, n);
      }
      g.setColor(Color.BLACK);
      drawLine(g, -n, 0, n, 0);
      drawLine(g, 0, - n, 0, n);
      for (int i = -n; i <= n; i++) {
         drawLine(g, i, 0.2, i, -0.2);
         drawLine(g, 0.2, i, -0.2, i);
      }
   }

   public void drawVector(Graphics ng, String name, double e1, double e2, Color color) {
      Graphics2D g2 = (Graphics2D) ng;
      Stroke s = new BasicStroke(2);
      g2.setStroke(s);
      ng.setColor(color);
      drawLine(ng, 0, 0, e1, e2);
      fillOval(ng, e1, e2, 0.5, 0.5);
      drawString(ng, name, (float) e1, (float) e2);
      ArrayList<Double> vector = new ArrayList<Double>();
      vector.add((double) e1);
      vector.add((double) e2);
      addVector(name, vector);
   }

   public void sumaVectores(String u, String v) {
      if (!Vectores.getVectors().containsKey(u)) {
         return;
      }
      if (!Vectores.getVectors().containsKey(v)) {
         return;
      }
      ArrayList<Double> vector_u = (ArrayList<Double>) Vectores.getVectors().get(u);
      ArrayList<Double> vector_v = (ArrayList<Double>) Vectores.getVectors().get(v);

      ArrayList<Double> vector = new ArrayList<Double>();
      for (int i = 0; i < vector_u.size(); i++) {
         vector.add(vector_u.get(i) + vector_v.get(i));
      }
      drawVector(g, "f("+u+"+"+v+")", vector.get(0), vector.get(1), Color.BLACK);
      addVector("f("+u+"+"+v+")", vector);
   }

   public void addVector(String name, ArrayList<Double> vector) {
      if (Vectores.getVectors().containsKey(name)) {
         return;
      }
      Vectores.addVector(name, vector);
      this.v.vectorsBox.addItem(name);
   }

   public void drawFunction(String name, String sk) {
      if (!Vectores.getVectors().containsKey(name)) {
         return;
      }
      Double k;
      if (sk.contains("/")) {
         String[] ska = sk.split("/");
         ArrayList<Double> ak = new ArrayList<Double>();
         for (String s: ska) {
            ak.add(Double.parseDouble(s));
         }
         k = ak.get(0) / ak.get(1);
      } else {
         k = Double.parseDouble(sk);
      }
      
      ArrayList<Double> original_vector = (ArrayList<Double>) Vectores.getVectors().get(name);
      ArrayList<Double> vector = new ArrayList<Double>();
      for (int i = 0; i < original_vector.size(); i++) {
         vector.add(original_vector.get(i) * k);
      }
      drawVector(g, "f("+sk+name+")", vector.get(0), vector.get(1), Color.BLACK);
      addVector(name, vector);
   }
}