/* Copyright (c) 2007 Johns Hopkins University.
*  All rights reserved.
*
*  Permission to use, copy, modify, and distribute this software and its
*  documentation for any purpose, without fee, and without written
*  agreement is hereby granted, provided that the above copyright
*  notice, the (updated) modification history and the author appear in
*  all copies of this source code.
*
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS `AS IS'
*  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*  ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS
*  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
*  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, LOSS OF USE, DATA,
*  OR PROFITS) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
*  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
*  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
*  THE POSSIBILITY OF SUCH DAMAGE.
*/

/**
 * @author Razvan Musaloiu-E. <razvanm@cs.jhu.edu>
 * @author Chieh-Jan Mike Liang <cliang4@cs.jhu.edu>
 */

#include "imgNum2volumeId.h"
#include "Mote.h"

module DelugeP
{
  uses {
    interface Boot;
    interface Leds;
    interface DisseminationValue<DelugeCmd>;
    interface StdControl as DisseminationStdControl;
    interface DisseminationUpdate<DelugeCmd>;
    interface ObjectTransfer;
    interface SplitControl as RadioSplitControl;
    interface NetProg;
    interface StorageMap[uint8_t volumeId];
    interface DelugeMetadata;
    interface DelugeVolumeManager;
    interface Resource;
    interface BlockRead[uint8_t volumeId];  // added BlockRead -dct-
//    interface Timer<TMilli> as DelayTimer;  // added delaytimer -dct-
    interface Timer<TMilli> as VersionMsgSendTimer; //added VersionMsgSendTimer -mlr-
    interface Packet; //added Packet for sending VersionMsg -mlr-
    interface AMSend; //added AMSend for sending VersionMsg -mlr-
    interface Receive; //added Receive for receiving VersionMsg -mlr-
#ifdef DELUGE_BASESTATION
    interface AMSend as SerialAMSender; //added for sending VersionMsg to the serial port -mlr-
#endif
  }
  provides {
    event void storageReady();
    command void stop();
    command uint8_t motestate(); // Added state command -dct-
  }
}

implementation
{
  enum {
    S_IDLE,
    S_PUB,
    S_RECV
  };

  DelugeCmd lastCmd;
//  DelugeCmd localcmd;
  uint8_t state = S_IDLE;
  uint16_t current_pub = 0;
  VersionMsg VTable;       // Added global version table -dct-
  ImgInfo imgData;         // Added for image retrieval -dct-

  message_t pkt; //added for VersionMsg -mlr-
  bool busy = FALSE; //added for VersionMsg -mlr-
//  bool imgDataReady = FALSE; // -dct-

  event void storageReady()
  {
    call Leds.led1On();    // Indicates storage ready -dct-
    call RadioSplitControl.start();
  }

  event void Boot.booted()
  {
    call Leds.led2On();   // Indicates successful boot -dct-
    lastCmd.uidhash = DELUGE_INVALID_UID;
  }

  event void RadioSplitControl.startDone(error_t error)
  {
    uint8_t i;
    uint8_t currentVolume;

    if (error == SUCCESS) {
      call DisseminationStdControl.start();
#ifdef DELUGE_BASESTATION
      for (i=0 ; i<MAX_MOTES ; i++)
      {
         VTable.versiontable[i][0] = i;
      }
#endif
      VTable.nodeid = TOS_NODE_ID;
      VTable.versiontable[TOS_NODE_ID][1] = version;
#ifndef DELUGE_BASESTATION
     call VersionMsgSendTimer.startPeriodic(10000); //added periodic timer (10 secs) -mlr0

     // Determine the uidhash and size of the current image -dct-
     currentVolume = _imgNum2volumeId[1];
     call BlockRead.read[currentVolume](0, &imgData, 8);      
#endif
    }
    call Leds.led0On();   // Indicates timer started -dct-
  }

  command void stop()
  {
    call Resource.release();
    if (state == S_RECV) {
//      printf("erase %d\n", lastCmd.imgNum);
      call DelugeVolumeManager.erase(lastCmd.imgNum);
    }
    call ObjectTransfer.stop();
    state = S_IDLE;
  }

  command uint8_t motestate()  // Added state command -dct-
  {
    return(state);
  }

  task void taskRequest()
  {
    signal Resource.granted();
  }
  
  void request()
  {
    if (call Resource.isOwner()) {
      post taskRequest();
    } else {
      call Resource.request();
    }
  }

  event void DisseminationValue.changed()
  {
    const DelugeCmd *cmd = call DisseminationValue.get();
//    printf("cmd: %d uidhash: 0x%lx imgNum: %d size: %u\n", cmd->type, cmd->uidhash, cmd->imgNum, cmd->size);
    call Leds.led2On();
    switch (cmd->type) {
    case DELUGE_CMD_STOP:
      call stop();
      break;
    case DELUGE_CMD_ONLY_DISSEMINATE:
    case DELUGE_CMD_DISSEMINATE_AND_REPROGRAM:
      if (state == S_RECV) {
	if (cmd->uidhash == lastCmd.uidhash) {
	  if (cmd->imgNum == lastCmd.imgNum) {
	    // Same uidhash, same imgNum, only cmd should be
	    // different.  That will be properly updated by the last
	    // statement from this function.
	    break;
	  }
	}
	call stop();
      }
      if (cmd->uidhash != IDENT_UIDHASH) {
	call DelugeMetadata.read(cmd->imgNum);
      } else {
//	state = S_PUB;
//	request();
      }
      break;
//    case DELUGE_CMD_NOOP:            // added NOOP command -dct-
//      call DelayTimer.startOneShot(1024);
//      break;
    }
    lastCmd = *cmd;
//    printf("lastCmd: %d uidhash: 0x%lx\n", lastCmd.type, lastCmd.uidhash);
  }
  
//  event void DelayTimer.fired() // added timer event -dct-
//  {
//    switch (lastCmd.type) {
//    case DELUGE_CMD_NOOP:            // added NOOP reboot to image 1 -dct-
//      call NetProg.programImageAndReboot(call StorageMap.getPhysicalAddress[imgNum2volumeId(2)](0));  
//      call NetProg.reboot();
//      break;
//    }
//  }

 VersionMsg* BuildMessage() //added BuildMessage for creating VersionMsg -mlr-
  {
	uint8_t i;
        uint16_t currentTime;

      VersionMsg* msg = (VersionMsg*)(call Packet.getPayload(&pkt, sizeof(VersionMsg))); 
	
      currentTime =  (uint16_t) ((call VersionMsgSendTimer.getNow()) / 1024);

      if (msg == NULL) {
	return NULL;
      }
      
      msg->nodeid = TOS_NODE_ID;
      for (i=0;i<MAX_MOTES;i++)
      {
         if (i == TOS_NODE_ID)
         {
             msg->versiontable[i][0] = TOS_NODE_ID;
             msg->versiontable[i][1] = version;
             msg->versiontable[i][2] = currentTime;
             VTable.versiontable[i][2] = currentTime;
         } else {
             msg->versiontable[i][0] = VTable.versiontable[i][0];
             msg->versiontable[i][1] = VTable.versiontable[i][1];
             msg->versiontable[i][2] = VTable.versiontable[i][2];
         }
      }

      return msg;
  }

 event void VersionMsgSendTimer.fired() //added Message Timer event -mlr-
 {
      if (!busy) {
      VersionMsg* btrpkt =BuildMessage();
	
	    
      if (btrpkt == NULL) {
	return;
      }

//Was here      
      
      if (call AMSend.send(AM_BROADCAST_ADDR, 
          &pkt, sizeof(VersionMsg)) == SUCCESS) {
        busy = TRUE;
      }	      
    }
 }

 event void AMSend.sendDone(message_t* msg, error_t err) //added sendDone event for VersionMsg -mlr-
 {
    if (&pkt == msg) {
      busy = FALSE;
    }
 }

#ifdef DELUGE_BASESTATION
 void WriteToSerial(int len, message_t* msg) //added WriteToSerial for sending VersionMsg -mlr-
 {
    call SerialAMSender.send(AM_BROADCAST_ADDR, msg, len);
 }
#endif

  event message_t* Receive.receive(message_t* msg, void* payload, uint8_t len)//added receive event for VersionMsg -mlr-
  {
    int i;

    if (len == sizeof(VersionMsg)) 
    {
      VersionMsg* btrpkt = (VersionMsg*)payload;
      for (i=0;i<MAX_MOTES;i++)
      {
         if (i == btrpkt->nodeid)
         {
             VTable.versiontable[i][2] = btrpkt->versiontable[i][2];
             VTable.versiontable[i][1] = btrpkt->versiontable[i][1];
         } else {
            if (i != TOS_NODE_ID)
            {
               if ((btrpkt->versiontable[i][2] > VTable.versiontable[i][2]) ||
                   (btrpkt->versiontable[i][1] > VTable.versiontable[i][1]))
               {
                   VTable.versiontable[i][2] = btrpkt->versiontable[i][2];
                   VTable.versiontable[i][1] = btrpkt->versiontable[i][1];
               }
            }
         }
         btrpkt->versiontable[i][0] = VTable.versiontable[i][0];
         btrpkt->versiontable[i][1] = VTable.versiontable[i][1];
         btrpkt->versiontable[i][2] = VTable.versiontable[i][2];
      }

      call Leds.led0On();

#ifdef DELUGE_BASESTATION
      WriteToSerial(len, msg);
#endif

#ifndef DELUGE_BASESTATION
      if (state == S_IDLE)
      {
         if (btrpkt->versiontable[btrpkt->nodeid][1] > version)
         {
             // Enter Recv Mode
//             call DelugeMetadata.read(1);
//             state = S_RECV;
//             request();
         } else if (version > btrpkt->versiontable[btrpkt->nodeid][1]) {
             // Set Timer to enter Pub Mode
	     state = S_PUB;
             current_pub = btrpkt->nodeid;
             request();
         }
     } else if (state == S_PUB) {
         if ((btrpkt->nodeid == current_pub)  && (btrpkt->versiontable[btrpkt->nodeid][1] == version))
         {
             call stop();
         }
     }

#endif

    }
    return msg;
  }

#ifdef DELUGE_BASESTATION
 event void SerialAMSender.sendDone(message_t* msg, error_t error) 
  {

    call Leds.led0Off();
 
  } //added sendDone for sending VersionMsg -mlr-
#endif

  event void ObjectTransfer.receiveDone(error_t error)
  {
    call Leds.set(LEDS_LED1 | LEDS_LED2);
    state = S_IDLE;
    
    if (error == SUCCESS) {
      switch (lastCmd.type) {
      case DELUGE_CMD_ONLY_DISSEMINATE:
//	state = S_PUB;
//	request();
	break;
      case DELUGE_CMD_DISSEMINATE_AND_REPROGRAM:
	call NetProg.programImageAndReboot(call StorageMap.getPhysicalAddress[lastCmd.imgNum](0));
	break;
      }
    } else {
      call DelugeVolumeManager.erase(lastCmd.imgNum);
    }
  }

  event void DelugeMetadata.readDone(uint8_t imgNum, DelugeIdent* ident, error_t error)
  {
//    printf("readDone 0x%lx imgNum: %d size: %lu\n", lastCmd.uidhash, lastCmd.imgNum, lastCmd.size);
    if (ident->uidhash == lastCmd.uidhash) {
      if (lastCmd.type == DELUGE_CMD_DISSEMINATE_AND_REPROGRAM) {
	call NetProg.programImageAndReboot(call StorageMap.getPhysicalAddress[imgNum](0));
      } else {
	// We already have the image so we'll go ahead and start publishing.
//	state = S_PUB;
//	request();
      }
    } else {
      state = S_RECV;
      request();
    }
  }

  event void Resource.granted()
  {

    switch (state) {
    case S_PUB:
//      printf("start pub 0x%lx imgNum: %d size: %u\n", lastCmd.uidhash, lastCmd.imgNum, lastCmd.size);
//      call ObjectTransfer.publish(lastCmd.uidhash, lastCmd.size, lastCmd.imgNum);
//      if (imgDataReady == TRUE)
//      {
         lastCmd.uidhash = imgData.uidhash;
         lastCmd.size = imgData.size;
         lastCmd.imgNum = 2;
         lastCmd.type = DELUGE_CMD_DISSEMINATE_AND_REPROGRAM;
         call DisseminationUpdate.change(&lastCmd);	     
         call ObjectTransfer.publish(imgData.uidhash, imgData.size, 2);
//      }
      break;
    case S_RECV:
      call ObjectTransfer.receive(lastCmd.uidhash, lastCmd.size, lastCmd.imgNum);
      break;
    }
  }

// Added to satisfy BlockRead -dct-
  event void BlockRead.readDone[uint8_t imgNum](storage_addr_t addr, void* buf, storage_len_t len, error_t error) 
  {
//     imgDataReady = TRUE;
  }
  event void BlockRead.computeCrcDone[uint8_t imgNum](storage_addr_t addr, storage_len_t len, uint16_t crc, error_t error) {}
  default command error_t BlockRead.read[uint8_t imgNum](storage_addr_t addr, void* buf, storage_len_t len) { return FAIL; }

  event void DelugeVolumeManager.eraseDone(uint8_t imgNum) {}
  event void RadioSplitControl.stopDone(error_t error) {}
  default async void command Leds.set(uint8_t val) {}
}
