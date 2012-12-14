/* 
 *
 * @author Mat Kelly <mkelly@cs.odu.edu>
 * @date   Oct 10, 2012
 */
#include <Timer.h>
#include "RuntimeReprogram.h"
#include <hardware.h>

configuration RuntimeReprogramAppC {
}
implementation {
  components MainC;
  components LedsC;
  components RuntimeReprogramC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_PROXIMITY);
  components new AMReceiverC(AM_PROXIMITY);
  //components NetProgC;
  components DelugeC;
 
  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
  //App.NetProg -> NetProgC;
  //App.Deluge -> DelugeC;
}
