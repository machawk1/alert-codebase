// $Id: BlinkToRadio.h,v 1.4 2006/12/12 18:22:52 vlahan Exp $

#ifndef BLINKTORADIO_H
#define BLINKTORADIO_H

enum {
  AM_VERSIONMSG = 8,
  TIMER_PERIOD_MILLI = 1000
};

typedef nx_struct VersionMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
  nx_uint16_t  versiontable[4][3];
} VersionMsg;

#endif
