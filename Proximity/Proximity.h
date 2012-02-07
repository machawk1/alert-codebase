#ifndef PROXIMITY_H
#define PROXIMITY_H

enum {
  AM_PROXIMITY = 6,
  TIMER_PERIOD_MILLI = 250
};

typedef nx_struct ProximityMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
} ProximityMsg;

#endif
