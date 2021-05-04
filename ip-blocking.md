# IP Blocking

## Overview

Uses a configurable list of IPv4 and IPv6 masks to assign peer "classes".
Check are preformed before allocating too many big resources.
Immediately close connection for the most rejected class.
Can add new entries at run-time that are not saved and expire after a globally configured period.
Each class may have a limit on total connections for that class. Exceeding that amount results in short message and closure of connection.
Multiple connections from the same IP can result in temporary change in class (to 0).

Class 0: block. no connections permitted. (0 total allowed)
Class 1: normal connection. limited to N connections total in class
Class 10: reserved connections. limit comes from a different pool
Class 100: administrator connections. used by admins to access the system. no effective limit.

