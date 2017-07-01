# UT2004Stats

A framework for reading and handling log data from Unreal Tournament 2004

## Features

Reads log data from:
  - OLStats 3.09 ([Link](https://www.dr-lex.be/software/olstats.html))
  
Stores data in:
  - Local transient memory
  
Reports data as:
  - HTML

## Screenshots

HTML report with data parsed from an OLStats log and stored in memory

![HTML report with data parsed from an OLStats log and stored in memory](https://christoffer.space/files/ut2004stats_scr1.png)

## TODO

- Report scoring/frag data as plain-text/CSV for batch script usage 
- Add support for persistent data storage
- Read logs form built-in logger (Low priority; OLStats is strictly more verbose)
