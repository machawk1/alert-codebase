/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package retasking.gui;


import javax.swing.SwingUtilities;
import javax.swing.table.DefaultTableModel;
import net.tinyos.message.Message;
import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.util.PrintStreamMessenger;

/**
 *
 * @author mruffing
 *
 * The DelugeMsgReader class is a TinyOS MessageListener that captures and
 * displays VersionMessage(s) distrubuted by the sensor network (IRIS motes)
 */
public class DelugeMsgReader implements net.tinyos.message.MessageListener {

    private MoteIF moteIF;
    private DefaultTableModel _guiTable;

  //Constructor - requires a connection string and a GUI table model.
  public DelugeMsgReader(String source, DefaultTableModel model) throws Exception {

      _guiTable = model;

    if (source != null) {
      moteIF = new MoteIF(BuildSource.makePhoenix(source, PrintStreamMessenger.err));
    }
    else {
      moteIF = new MoteIF(BuildSource.makePhoenix(PrintStreamMessenger.err));
    }
  }

    public void UpdateGUI(final int array[][]) {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {

                //Remove all the data from the guiTable
                _guiTable.getDataVector().removeAllElements();

                _guiTable.addRow(new Object[]{array[0][0], array[0][1], array[0][2]});
                _guiTable.addRow(new Object[]{array[1][0], array[1][1], array[1][2]});
		_guiTable.addRow(new Object[]{array[2][0], array[2][1], array[2][2]});
		_guiTable.addRow(new Object[]{array[3][0], array[3][1], array[3][2]});
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);

    }

  public void start() {
  }

  public void messageReceived(int to, Message message) {
    long t = System.currentTimeMillis();
    //    Date d = new Date(t);
    System.out.print("" + t + ": ");
    System.out.println(message);

    //Update the Table Model
    UpdateGUI(((VersionMessage)message).get_versiontable());
    
  }

  //Register to receive certain message types.
  public void addMsgType(Message msg) {
    moteIF.registerListener(msg, this);
  }
}
