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
 * @author Chieh-Jan Mike Liang <cliang4@cs.jhu.edu>
 * @author Razvan Musaloiu-E. <razvanm@cs.jhu.edu>
 */

#include "Deluge.h"
#include "StorageVolumes.h"

configuration DelugeC {
  uses interface Leds;
}

implementation
{
  components ObjectTransferC;
  
  components new BlockReaderC(VOLUME_DELUGE1) as BlockReaderDeluge1;
    // Removed due to space limitations -dct-
//  components new BlockReaderC(VOLUME_DELUGE2) as BlockReaderDeluge2;
//  components new BlockReaderC(VOLUME_DELUGE3) as BlockReaderDeluge3;

  components new BlockWriterC(VOLUME_DELUGE1) as BlockWriterDeluge1;
    // Removed due to space limitations -dct-
//  components new BlockWriterC(VOLUME_DELUGE2) as BlockWriterDeluge2;
//  components new BlockWriterC(VOLUME_DELUGE3) as BlockWriterDeluge3;
  
  ObjectTransferC.BlockRead[VOLUME_DELUGE1]  -> BlockReaderDeluge1;
#ifdef DELUGE_BASESTATION
    // Removed due to space limitations -dct-
//  ObjectTransferC.BlockRead[VOLUME_DELUGE2]  -> BlockReaderDeluge2;
//  ObjectTransferC.BlockRead[VOLUME_DELUGE3]  -> BlockReaderDeluge3;
#endif

  ObjectTransferC.BlockWrite[VOLUME_DELUGE1] ->  BlockWriterDeluge1;
#ifdef DELUGE_BASESTATION
    // Removed due to space limitations -dct-
//  ObjectTransferC.BlockWrite[VOLUME_DELUGE2] ->  BlockWriterDeluge2;
//  ObjectTransferC.BlockWrite[VOLUME_DELUGE3] ->  BlockWriterDeluge3;
#endif

  ObjectTransferC.Leds = Leds;
  
  components new DisseminatorC(DelugeCmd, DELUGE_KEY);
  components DisseminationC;
  components ActiveMessageC;
  components NetProgC, DelugeP;
  components new TimerMilliC() as Timer;
  components LocalTimeMilliC;            //added local time component -dct-
  components BlockStorageManagerC;
  components DelugeMetadataC;
  components new DelugeMetadataClientC();
  components new DelugeVolumeManagerClientC();
  components new BlockStorageLockClientC();
  components MainC;


  DelugeP.Boot -> MainC;
  DelugeP.BlockRead[VOLUME_DELUGE1] -> BlockReaderDeluge1; // Added for flash reads -dct-
  DelugeP.Leds = Leds;  
#ifndef DELUGE_BASESTATION
  DelugeP.DisseminationValue -> DisseminatorC;
#endif
  // Added to allow commanding from DelugeP -dct-
  DelugeP.DisseminationUpdate -> DisseminatorC;
  DelugeP.DisseminationStdControl -> DisseminationC;
  DelugeP.ObjectTransfer -> ObjectTransferC;
  DelugeP.NetProg -> NetProgC;
  DelugeP.RadioSplitControl -> ActiveMessageC;
  DelugeP.StorageMap -> BlockStorageManagerC;
  DelugeP.DelugeMetadata -> DelugeMetadataClientC;
  DelugeP.storageReady <- DelugeMetadataC;
  DelugeP.DelugeVolumeManager -> DelugeVolumeManagerClientC;
  DelugeP.Resource -> BlockStorageLockClientC;
  DelugeP.VersionMsgSendTimer -> Timer;         //added VersionMsgSendTimer -mlr-
  components new AMSenderC(AM_VERSIONMSG);      //added AMSender for sending VersionMSG -mlr-
  components new AMReceiverC(AM_VERSIONMSG);    //added AMReceiverC for receiving VersionMSG -mlr-
#ifdef DELUGE_BASESTATION
  components new SerialAMSenderC(AM_VERSIONMSG);//added SerialAMSender for sending VersionMSG to serial port -mlr-
#endif
  DelugeP.AMSend -> AMSenderC;                  //added AMSend for sending VersionMsg -mlr-
  DelugeP.Packet -> AMSenderC;                  //added Packet for creating VersionMsg -mlr-
  DelugeP.Receive -> AMReceiverC;               //added Receive for receiving VersionMsg -mlr-
#ifdef DELUGE_BASESTATION
  DelugeP.SerialAMSender -> SerialAMSenderC;    //added SerialAMSender for sending VersionMsg to serial port -mlr-
#endif

#if defined(DELUGE_BASESTATION) || defined(DELUGE_LIGHT_BASESTATION)
  components SerialStarterC;
  components new FlashVolumeManagerC(DELUGE_AM_FLASH_VOL_MANAGER);
#endif

#ifdef DELUGE_BASESTATION
  components new DelugeManagerC(DELUGE_AM_DELUGE_MANAGER);

  DelugeManagerC.DisseminationUpdate -> DisseminatorC;
#endif

}