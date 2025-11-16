import java.util.*;
import javax.swing.*;
import javax.swing.border.*;

import java.awt.*;
import java.awt.event.*;

import gson.Gson;
import gson.JsonArray;

public class Vectores extends JFrame implements ActionListener {

    private static Map<String, Object> vectors = new HashMap<String, Object>();
    
    private static ArrayList<Object> vectors2 = new ArrayList<Object>();

    private DrawCanvas canvas;

    Graphics g;
    JComboBox<Object> vectorsBox;

    public Vectores() {
        canvas = new DrawCanvas(this);
        Container cp = getContentPane();
        cp.setLayout(null);

        JPanel jp = new JPanel();
        jp.setLayout(null);

        JPanel p = new JPanel();
        p.setBounds(0, 0, 200, 200);

        JScrollPane scroll = new JScrollPane(canvas);
        scroll.setBounds(cp.getWidth() + 500, cp.getHeight(), 1030, 800);
        scroll.getHorizontalScrollBar().setValue(scroll.getHorizontalScrollBar().getMaximum()/2);
        scroll.getHorizontalScrollBar().setValue(scroll.getHorizontalScrollBar().getMaximum()/2 - 506);
        scroll.getVerticalScrollBar().setValue(scroll.getVerticalScrollBar().getMaximum()/2 - 395);
        // scroll.setPreferredSize(new Dimension(400, 400));

        // Crear escalar
        JLabel escalarTitle = new JLabel("Vector por un escalar");
        escalarTitle.setBounds(30, 20, 190, 30);
        escalarTitle.setFont(new Font("Arial", 1, 16));

        vectorsBox = new JComboBox<>();
        vectorsBox.setBounds(30, 60, 90, 30);

        JLabel escalarLabel = new JLabel("Escalar:");
        escalarLabel.setBounds(140, 60, 90, 30);

        JTextField escalar = new JTextField("");
        escalar.setBounds(190, 60, 80, 30);

        JButton crearEscalar = new JButton("Crear");
        crearEscalar.setFocusable(false);
        crearEscalar.setBounds(290, 60, 80, 30);
        crearEscalar.addActionListener(this);

        // suma de vectores
        // producto cruz
        // producto punto
        // paralelogramo

        //cp.add(scroll);
        // p.add(scroll);
        // jp.add(p);
        // cp.add(jp);
        cp.add(scroll);

        cp.add(escalarTitle);
        cp.add(vectorsBox);
        cp.add(escalarLabel);
        cp.add(escalar);
        cp.add(crearEscalar);
   
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setExtendedState(JFrame.MAXIMIZED_BOTH);
        setTitle("Vectores");
        setVisible(true);
     }
    
    public static void main(String args[])
    {
        new Vectores();
    }

    public void actionPerformed(ActionEvent e) {
        this.g = canvas.getGraphics();
        String name = vectorsBox.getSelectedItem().toString();
        double e1 = 0;
        double e2 = 0;
        canvas.drawVector(this.g, name, e1, e2, Color.BLACK);
        canvas.paintComponents(this.g);
    }
   
    public static void createVector(){
        ArrayList<Double> v = new ArrayList<Double>();
        Scanner sc = new Scanner(System.in);
        System.out.println("Ingresa la dimension del vector");
        int vd = sc.nextInt();
        for (int i=0; i < vd; i++)
        {
            System.out.println("Ingresa el valor " + (i + 1));
            double n = sc.nextDouble();
            v.add(n);
        }
        //addVector(v);
    }
    
    public static void addVector(String name, ArrayList<Double> v){
        vectors.put(name, v);
    }
     
    public static Map<String, Object> getVectors(){
        return vectors;
    }
}
