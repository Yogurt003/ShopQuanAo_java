package chuyenTrang;

import java.awt.CardLayout;
import java.awt.Component;
import javax.swing.JLayeredPane;
import net.miginfocom.swing.MigLayout;

/**
 *
 * @author Hao Le
 */
public class Transition extends javax.swing.JPanel {

    private JLayeredPane body;
    
    public Transition() {
        initComponents();
        setOpaque(false);
        setLayout(new MigLayout("fill", "0[fill]0", "0[fill]0"));
        body = new JLayeredPane();
        body.setLayout(new CardLayout());
        add(body);
    }
    
    public void display(Component form) {
        body.removeAll();
        body.add(form);
        body.repaint();
        body.revalidate();
        form.setVisible(true);
    }
 
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        setPreferredSize(new java.awt.Dimension(625, 436));

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 832, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 398, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents


    // Variables declaration - do not modify//GEN-BEGIN:variables
    // End of variables declaration//GEN-END:variables
}
