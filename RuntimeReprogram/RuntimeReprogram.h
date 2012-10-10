#ifndef RUNTIMEREPROGRAM_H
#define RUNTIMEREPROGRAM_H

enum {
  AM_PROXIMITY = 6,
  TIMER_PERIOD_MILLI = 2000,
  IS_LEADER = 1 /* Flip this bit to toggle the two functionalities */
};

typedef nx_struct RTRMsg {
  nx_uint16_t nodeid;
  nx_uint16_t counter;
} RTRMsg;

#endif
