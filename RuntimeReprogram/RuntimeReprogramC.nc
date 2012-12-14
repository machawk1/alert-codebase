/**
 * First attempts at runtime reprogramming of the motes sans Deluge modifications
 *
 * @author Mat Kelly <mkelly@cs.odu.edu>
 * @date   Oct 10, 2012
 */
#include <Timer.h>
#include "RuntimeReprogram.h"
#include <avr/boot.h>
#include <avr/wdt.h>
//#include "Deluge.h"
#include "StorageVolumes.h"
#include "crc.h"

module RuntimeReprogramC {
  uses interface Boot;
  uses interface Leds;
  uses interface Timer<TMilli> as Timer0;
  uses interface Packet;
  uses interface AMPacket;
  uses interface AMSend;
  uses interface Receive;
  uses interface SplitControl as AMControl;
  //uses interface NetProg;
  //uses interface Deluge;
  //uses interface Init;
}
implementation {
  
  uint16_t counter;
  message_t pkt;
  bool busy = FALSE;
  RTRMsg * leaderMsg;

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
    leaderMsg = (RTRMsg *)(call Packet.getPayload(&pkt, sizeof(RTRMsg)));

	leaderMsg->nodeid = TOS_NODE_ID;
	leaderMsg->counter = counter;
	
	if(IS_LEADER == 1){
		leaderMsg->sentFromLeader = 1;
		if(counter % 3 == 0){
			setLeds(1);
		}else if(counter % 3 == 1){
			setLeds(10);
		}else if(counter % 3 == 2){
			setLeds(100);
		}
	}else {
		leaderMsg->sentFromLeader = 0;		
		//simple blink to show in runtime loop
		if(counter % 2 == 0){
			setLeds(0);
		}else {
			setLeds(1);
		}
	}
	if (call AMSend.send(AM_BROADCAST_ADDR, &pkt, sizeof(RTRMsg)) == SUCCESS) {
		busy = TRUE;
	}
  }

  event void AMSend.sendDone(message_t* msg, error_t err) {
    if (&pkt == msg) {
      busy = FALSE;
    }
  }

 event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len){
  leaderMsg = (RTRMsg*)(call Packet.getPayload(msg, sizeof(RTRMsg)));
  
  if(IS_LEADER == 1){return msg;} //the leader takes no orders
  if(!(leaderMsg->sentFromLeader)){return msg;} //non-leaders only take commands from the leader!
  
  call Timer0.stop();
  call Leds.led0On();
  call Leds.led1On();
  call Leds.led2On();
  
  //call NetProg.reboot();
  //call Deluge.forceMoteToRecvState();
  
  return msg;
 }
}
