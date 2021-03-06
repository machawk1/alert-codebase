/* 
 *
 * @author Mat Kelly <mkelly@cs.odu.edu>
 * @date   Nov 3, 2011
 */
#include <Timer.h>
#include "Proximity.h"

configuration ProximityAppC {
}
implementation {
  components MainC;
  components LedsC;
  components ProximityC as App;
  components new TimerMilliC() as Timer0;
  components ActiveMessageC;
  components new AMSenderC(AM_PROXIMITY);
  components new AMReceiverC(AM_PROXIMITY);
  components DelugeC;

  App.Boot -> MainC;
  App.Leds -> LedsC;
  App.Timer0 -> Timer0;
  App.Packet -> AMSenderC;
  App.AMPacket -> AMSenderC;
  App.AMControl -> ActiveMessageC;
  App.AMSend -> AMSenderC;
  App.Receive -> AMReceiverC;
}
