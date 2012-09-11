/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package examples;

import javax.swing.JTable;
import javax.swing.SwingUtilities;
import javax.swing.table.DefaultTableModel;
import net.tinyos.message.Message;
import net.tinyos.message.MoteIF;
import net.tinyos.packet.BuildSource;
import net.tinyos.util.PrintStreamMessenger;

/**
 *
 * @author mruffing
 */
public class DelugeMsgReader implements net.tinyos.message.MessageListener {

    private MoteIF moteIF;
    private DefaultTableModel _guiTable;

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

  public void CodeToUpdateGUI()
  {
      //_guiTable.addRow(new Object[] { "Hello World", 0, 0 });
      //_guiTable.addRow(new Object[] { "This is the second row", 0, 0});
  }

  public void start() {
  }

  public void messageReceived(int to, Message message) {
    long t = System.currentTimeMillis();
    //    Date d = new Date(t);
    System.out.print("" + t + ": ");
    System.out.println(message);

    UpdateGUI(((VersionMessage)message).get_versiontable());
    

  }


  private static void usage() {
    System.err.println("usage: MsgReader [-comm <source>] message-class [message-class ...]");
  }

  public void addMsgType(Message msg) {
    moteIF.registerListener(msg, this);
  }
}
