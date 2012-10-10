/**
 * First attempts at runtime reprogramming of the motes sans Deluge modifications
 *
 * @author Mat Kelly <mkelly@cs.odu.edu>
 * @date   Oct 10, 2012
 */
#include <Timer.h>
#include "RuntimeReprogram.h"

module RuntimeReprogramC {
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
	if(val == 0){
	 call Leds.led0Off();
     call Leds.led1Off();
     call Leds.led2Off();
	}else if(val == 1){
	 call Leds.led0On();
     call Leds.led1Off();
     call Leds.led2Off();
	}else if(val == 10){
	 call Leds.led0Off();
     call Leds.led1On();
     call Leds.led2Off();	 
	}else if(val == 100){
	 call Leds.led0Off();
     call Leds.led1Off();
     call Leds.led2On();	 
	}else {	//error state
	 call Leds.led0Off();
     call Leds.led1On();
     call Leds.led2On();	 
	}
  return;
  }
 

  event void Boot.booted() {
    //call AMControl.start();
  }

  event void AMControl.startDone(error_t err) {
    if (err == SUCCESS) {
      if(IS_LEADER == 0){
		call Timer0.startPeriodic(TIMER_PERIOD_MILLI);
	  }else {
	    call Timer0.startPeriodic(TIMER_PERIOD_MILLI/4);
	  }
    }
    else {
      call AMControl.start();
    }
  }

  event void AMControl.stopDone(error_t err) {
  }

  event void Timer0.fired() {
    counter++;
    
    if(IS_LEADER == 1){
      RTRMsg* leaderMsg = (RTRMsg*)(call Packet.getPayload(&pkt, sizeof(RTRMsg)));
      
      leaderMsg->nodeid = TOS_NODE_ID;
      leaderMsg->counter = counter;
      if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(RTRMsg)) == SUCCESS) {
        busy = TRUE;
      }
      if(counter % 3 == 0){
		setLeds(1);
	  }else if(counter % 3 == 1){
		setLeds(10);
	  }else if(counter % 3 == 2){
		setLeds(100);
	  }
      
      return;
    }
    
    
    //simple blink to show in runtime loop
    if(counter % 2 == 0){
		setLeds(0);
	}else {
		setLeds(1);
	}
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

 event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
  RTRMsg* leaderMsg = (RTRMsg*)(call Packet.getPayload(msg, sizeof(RTRMsg)));
  //uint8_t str = (&metadata)->nodeid;
  // Deconstructing the message doesn't matter. When you've received one, halt
  //  drone nodes don't send packets
  
  //if(str == 50){
  call Timer0.stop();
  call Leds.led0On();
  call Leds.led1On();
  call Leds.led2On();
  //}
  
  return msg;
 }
}
