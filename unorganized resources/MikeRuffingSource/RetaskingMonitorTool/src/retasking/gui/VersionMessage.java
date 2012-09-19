package retasking.gui;

/**
 * This class is automatically generated by mig. DO NOT EDIT THIS FILE.
 * This class implements a Java interface to the 'VersionMessage'
 * message type.
 */

public class VersionMessage extends net.tinyos.message.Message {

    /** The default size of this message type in bytes. */
    public static final int DEFAULT_MESSAGE_SIZE = 28;

    /** The Active Message type associated with this message. */
    public static final int AM_TYPE = 6;

    /** Create a new VersionMessage of size 28. */
    public VersionMessage() {
        super(DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /** Create a new VersionMessage of the given data_length. */
    public VersionMessage(int data_length) {
        super(data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new VersionMessage with the given data_length
     * and base offset.
     */
    public VersionMessage(int data_length, int base_offset) {
        super(data_length, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new VersionMessage using the given byte array
     * as backing store.
     */
    public VersionMessage(byte[] data) {
        super(data);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new VersionMessage using the given byte array
     * as backing store, with the given base offset.
     */
    public VersionMessage(byte[] data, int base_offset) {
        super(data, base_offset);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new VersionMessage using the given byte array
     * as backing store, with the given base offset and data length.
     */
    public VersionMessage(byte[] data, int base_offset, int data_length) {
        super(data, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new VersionMessage embedded in the given message
     * at the given base offset.
     */
    public VersionMessage(net.tinyos.message.Message msg, int base_offset) {
        super(msg, base_offset, DEFAULT_MESSAGE_SIZE);
        amTypeSet(AM_TYPE);
    }

    /**
     * Create a new VersionMessage embedded in the given message
     * at the given base offset and length.
     */
    public VersionMessage(net.tinyos.message.Message msg, int base_offset, int data_length) {
        super(msg, base_offset, data_length);
        amTypeSet(AM_TYPE);
    }

    /**
    /* Return a String representation of this message. Includes the
     * message type name and the non-indexed field values.
     */
    public String toString() {
      String s = "Message <VersionMessage> \n";
      try {
        s += "  [nodeid=0x"+Long.toHexString(get_nodeid())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
        s += "  [counter=0x"+Long.toHexString(get_counter())+"]\n";
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      try {
      } catch (ArrayIndexOutOfBoundsException aioobe) { /* Skip field */ }
      return s;
    }

    // Message-type-specific access methods appear below.

    /////////////////////////////////////////////////////////
    // Accessor methods for field: nodeid
    //   Field type: int, unsigned
    //   Offset (bits): 0
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'nodeid' is signed (false).
     */
    public static boolean isSigned_nodeid() {
        return false;
    }

    /**
     * Return whether the field 'nodeid' is an array (false).
     */
    public static boolean isArray_nodeid() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'nodeid'
     */
    public static int offset_nodeid() {
        return (0 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'nodeid'
     */
    public static int offsetBits_nodeid() {
        return 0;
    }

    /**
     * Return the value (as a int) of the field 'nodeid'
     */
    public int get_nodeid() {
        return (int)getUIntBEElement(offsetBits_nodeid(), 16);
    }

    /**
     * Set the value of the field 'nodeid'
     */
    public void set_nodeid(int value) {
        setUIntBEElement(offsetBits_nodeid(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'nodeid'
     */
    public static int size_nodeid() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'nodeid'
     */
    public static int sizeBits_nodeid() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: counter
    //   Field type: int, unsigned
    //   Offset (bits): 16
    //   Size (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'counter' is signed (false).
     */
    public static boolean isSigned_counter() {
        return false;
    }

    /**
     * Return whether the field 'counter' is an array (false).
     */
    public static boolean isArray_counter() {
        return false;
    }

    /**
     * Return the offset (in bytes) of the field 'counter'
     */
    public static int offset_counter() {
        return (16 / 8);
    }

    /**
     * Return the offset (in bits) of the field 'counter'
     */
    public static int offsetBits_counter() {
        return 16;
    }

    /**
     * Return the value (as a int) of the field 'counter'
     */
    public int get_counter() {
        return (int)getUIntBEElement(offsetBits_counter(), 16);
    }

    /**
     * Set the value of the field 'counter'
     */
    public void set_counter(int value) {
        setUIntBEElement(offsetBits_counter(), 16, value);
    }

    /**
     * Return the size, in bytes, of the field 'counter'
     */
    public static int size_counter() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of the field 'counter'
     */
    public static int sizeBits_counter() {
        return 16;
    }

    /////////////////////////////////////////////////////////
    // Accessor methods for field: versiontable
    //   Field type: int[][], unsigned
    //   Offset (bits): 32
    //   Size of each element (bits): 16
    /////////////////////////////////////////////////////////

    /**
     * Return whether the field 'versiontable' is signed (false).
     */
    public static boolean isSigned_versiontable() {
        return false;
    }

    /**
     * Return whether the field 'versiontable' is an array (true).
     */
    public static boolean isArray_versiontable() {
        return true;
    }

    /**
     * Return the offset (in bytes) of the field 'versiontable'
     */
    public static int offset_versiontable(int index1, int index2) {
        int offset = 32;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 48;
        if (index2 < 0 || index2 >= 3) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index2 * 16;
        return (offset / 8);
    }

    /**
     * Return the offset (in bits) of the field 'versiontable'
     */
    public static int offsetBits_versiontable(int index1, int index2) {
        int offset = 32;
        if (index1 < 0 || index1 >= 4) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index1 * 48;
        if (index2 < 0 || index2 >= 3) throw new ArrayIndexOutOfBoundsException();
        offset += 0 + index2 * 16;
        return offset;
    }

    /**
     * Return the entire array 'versiontable' as a int[][]
     */
    public int[][] get_versiontable() {
        int[][] tmp = new int[4][3];
        for (int index0 = 0; index0 < numElements_versiontable(0); index0++) {
          for (int index1 = 0; index1 < numElements_versiontable(1); index1++) {
              tmp[index0][index1] = getElement_versiontable(index0,index1);
          }
        }
        return tmp;
    }

    /**
     * Set the contents of the array 'versiontable' from the given int[][]
     */
    public void set_versiontable(int[][] value) {
        for (int index0 = 0; index0 < value.length; index0++) {
          for (int index1 = 0; index1 < value[index0].length; index1++) {
              setElement_versiontable(index0,index1, value[index0][index1]);
          }
        }
    }

    /**
     * Return an element (as a int) of the array 'versiontable'
     */
    public int getElement_versiontable(int index1, int index2) {
        return (int)getUIntBEElement(offsetBits_versiontable(index1, index2), 16);
    }

    /**
     * Set an element of the array 'versiontable'
     */
    public void setElement_versiontable(int index1, int index2, int value) {
        setUIntBEElement(offsetBits_versiontable(index1, index2), 16, value);
    }

    /**
     * Return the total size, in bytes, of the array 'versiontable'
     */
    public static int totalSize_versiontable() {
        return (192 / 8);
    }

    /**
     * Return the total size, in bits, of the array 'versiontable'
     */
    public static int totalSizeBits_versiontable() {
        return 192;
    }

    /**
     * Return the size, in bytes, of each element of the array 'versiontable'
     */
    public static int elementSize_versiontable() {
        return (16 / 8);
    }

    /**
     * Return the size, in bits, of each element of the array 'versiontable'
     */
    public static int elementSizeBits_versiontable() {
        return 16;
    }

    /**
     * Return the number of dimensions in the array 'versiontable'
     */
    public static int numDimensions_versiontable() {
        return 2;
    }

    /**
     * Return the number of elements in the array 'versiontable'
     * for the given dimension.
     */
    public static int numElements_versiontable(int dimension) {
      int array_dims[] = { 4, 3,  };
        if (dimension < 0 || dimension >= 2) throw new ArrayIndexOutOfBoundsException();
        if (array_dims[dimension] == 0) throw new IllegalArgumentException("Array dimension "+dimension+" has unknown size");
        return array_dims[dimension];
    }

}