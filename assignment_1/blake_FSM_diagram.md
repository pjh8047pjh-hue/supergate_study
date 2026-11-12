# BLAKE FSM

~~~text
      rstb = 0 (asynchronous): ANY STATE ---> IDLE; cnt_en = 0, done = 0



          ena = 0                                      cnt_done = 0

           +-----<--------+                             +-----<--------+
           |              |                             |              |
           v              |                             v              |
      +------------------------+                   +------------------------+                   +------------------------+
      |       IDLE             |    ena = 1        |       RUN              | cnt_done = 1      |       DONE             |
      |    cstate = 00         |                   |    cstate = 01         |                   |    cstate = 10         |
      |                        |------------------>|                        |------------------>|                        |
      |    cnt_en = 0          |                   |    cnt_en = 1          |                   |    cnt_en = 0          |
      |    done   = 0          |                   |    done   = 0          |                   |    done   = 1          |
      |                        |                   |                        |                   |                        |
      +------------------------+                   +------------------------+                   +------------------------+
                  ^                                                                                         |
                  |                                                                                         |
                  |                                                                                         |
                  |                                                                                         |
                  |                                                                                         |
                  +---------------------------------------<-------------------------------------------------+

                                             unconditional / next rising edge


      cstate = 11: next rising edge ---> IDLE; cnt_en = 0, done = 0
~~~

## Mermaid

~~~mermaid
stateDiagram-v2
    direction LR
    [*] --> IDLE: rstb = 0
    IDLE --> IDLE: ena = 0
    IDLE --> RUN: ena = 1
    RUN --> RUN: cnt_done = 0
    RUN --> DONE: cnt_done = 1
    DONE --> IDLE: next rising edge
    IDLE: cstate = 00
    IDLE: cnt_en = 0, done = 0
    RUN: cstate = 01
    RUN: cnt_en = 1, done = 0
    DONE: cstate = 10
    DONE: cnt_en = 0, done = 1
    note right of IDLE
      rstb = 0: asynchronous reset from any state
      cstate = 11: next rising edge returns to IDLE
    end note
~~~
