import javax.swing.JFrame;
import javax.swing.JTextField;

public class Test extends JFrame {
	public static void main(String args[]) {
		new Test();
	}

	Test() {
		add(new JTextField());
		setVisible(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
	}
}
