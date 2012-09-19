/*
 * "Copyright (c) 2000-2005 The Regents of the University  of California.  
 * All rights reserved.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose, without fee, and without written agreement is
 * hereby granted, provided that the above copyright notice, the following
 * two paragraphs and the author appear in all copies of this software.
 * 
 * IN NO EVENT SHALL THE UNIVERSITY OF CALIFORNIA BE LIABLE TO ANY PARTY FOR
 * DIRECT, INDIRECT, SPECIAL, INCIDENTAL, OR CONSEQUENTIAL DAMAGES ARISING OUT
 * OF THE USE OF THIS SOFTWARE AND ITS DOCUMENTATION, EVEN IF THE UNIVERSITY OF
 * CALIFORNIA HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 * 
 * THE UNIVERSITY OF CALIFORNIA SPECIFICALLY DISCLAIMS ANY WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.  THE SOFTWARE PROVIDED HEREUNDER IS
 * ON AN "AS IS" BASIS, AND THE UNIVERSITY OF CALIFORNIA HAS NO OBLIGATION TO
 * PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS, OR MODIFICATIONS."
 *
 * Copyright (c) 2002-2003 Intel Corporation
 * All rights reserved.
 *
 * This file is distributed under the terms in the attached INTEL-LICENSE     
 * file. If you do not find these files, copies can be found by writing to
 * Intel Research Berkeley, 2150 Shattuck Avenue, Suite 1300, Berkeley, CA, 
 * 94704.  Attention:  Intel License Inquiry.
 */

/**
 * Implementation for Blink application.  Toggle the red LED when a
 * Timer fires.
 *
 * @author tinyos-help@millennium.berkeley.edu
 * @author Chieh-Jan Mike Liang <cliang4@cs.jhu.edu>
 * @author Razvan Musaloiu-E. <razvanm@cs.jhu.edu>
 **/

#include "Timer.h"
#include "Mote.h"

module BlinkC
{
  uses interface Timer<TMilli> as Timer0;
  uses interface Leds;
  uses interface Boot;
  uses command uint8_t motestate();  // Added state command -dct-
}

implementation
{
  enum {
    S_IDLE,
    S_PUB,
    S_RECV
  };

  uint8_t state = S_IDLE;

  event void Boot.booted()
  {
    call Timer0.startPeriodic( 100 + 200 * version );
  }

  event void Timer0.fired()
  {
    // Determine current state -dct-
    state = call motestate();
    
    // Blink the LED corresponding to the state -dct-
    // Green = IDLE
    // Yellow = PUBLISH/TRANSMIT
    // Red = RECEIVE
    switch(state) {              
        case(S_IDLE):
            call Leds.led0Off();
            call Leds.led1Toggle();
            call Leds.led2Off();
	break;  
        case(S_PUB):
            call Leds.led0Off();
            call Leds.led1Off();
            call Leds.led2Toggle();
	break;  
        case(S_RECV):
            call Leds.led0Toggle();
            call Leds.led1Off();
            call Leds.led2Off();
	break;
    }  
  }
}
