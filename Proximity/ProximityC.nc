/**
 * Rudimentary Proximity Detection, adapted from BlinkToRadio
 *
 * @author Mat Kelly <mkelly@cs.odu.edu>
 * @date   Nov 3, 2011
 */
#include <Timer.h>
#include "Proximity.h"

module ProximityC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
}
implementation {

  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;

  void setLeds(uint16_t val) {
	/* ****************************************************  
	 * Power level, the second number in the conditional
	 *  should range from 0-31 
	 * ************************************************* */
	if(val == 0){	//no comm in awhile, turn 'em off!
	 call Leds.led0Off();
     call Leds.led1Off();
     call Leds.led2Off();
	}else if(val < 10/1){			//red
	 call Leds.led0On();
     call Leds.led1Off();
     call Leds.led2Off();
    }else if(val < 17/1){	//yellow
	 call Leds.led0Off();
     call Leds.led1Off();
     call Leds.led2On(); // yellow led is 2
    }else if(val < 31/1){ // red
	 call Leds.led0Off();
     call Leds.led1On();
     call Leds.led2Off();
	}
  return;
  }
 

  event void Boot.booted() {
    //call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    counter++;
    if (!busy) {
      ProximityMsg* btrpkt = 
	(ProximityMsg*)(call Packet.getPayload(&pkt, sizeof(ProximityMsg)));
      if (btrpkt == NULL) {return;}
      
      btrpkt->nodeid = TOS_NODE_ID;
      btrpkt->counter = counter;
      if (call AMSend.send(AM_BROADCAST_ADDR, 
          &pkt, sizeof(ProximityMsg)) == SUCCESS) {
        busy = TRUE;
      }
    }
    if(counter > 8){
		setLeds(0);
	}
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

 event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
  rf230packet_metadata_t *packetMetadata = ((rf230packet_metadata_t *)(msg->metadata));
  rf230_metadata_t metadata = packetMetadata->rf230;
  uint8_t str = (&metadata)->power;
  setLeds(str);
  counter = 0;
  return msg;
 }
}
