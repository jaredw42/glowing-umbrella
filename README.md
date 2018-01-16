# glowing-umbrella

## personal repo for python and MATLAB scripts


### all dat MATLAB:

### todo

#### all GTT
- [x] add logic for different antenna positions
- [ ] date stamp from receiver data
- [x] legend data from rx data
- [ ] define convention for naming files and folders
- [ ] make gt_plotindRx work with all test types
- [ ] plotting/tracking of RTK false fixes
- [ ] dynamic uitable sizing
- [ ] fix plots folder naming issue
- [ ] handle gps week rollover
- [ ] gt_createSheetData
- [ ] add testType variable for plot setting
- [ ] combined RTK Fixed + Float nav plots (for RF On OFF)
- [x] cleanup calc_nav navstats.DGNSS and SPS error names
- [x] cleanup and standardize input dialog (make function)

- [ ] try changing to indexing datasets from
      Gtt(i).startstats.TTSPS to GTT.startstats.TTSPS(i)
      (you could probably then do plot(GTT.startstats.TTSPS(1:end)) and get rid of the loops in the plots )


- getReceiverData
  - [ ] add exception handling for datasets without report.txt file

- [ ] gtt cont nav
  - [ ] calc % of epochs where real err < predicted
  - [x] calc fix pcts and add table to diff mode plot
  - [x] add tables with 1,2,3 sig values to cdf plots
  - [x] color code overhead plot by fix type
  - [x] cdf all fix modes
  - [x] individual receiver plots (err NED plots)
  - [x] better legend logic for individual rx plots

  
- [ ] gtt rf on/off script
  - [x] finish incorrect fix function
  - [ ] add calculation of 'who wins' Max error per cycle
  - [ ] overall fix and diff mode stats
  
 - [ ]  gtt rtk starts script
    - [ ] update titles
    - [x] add time to fix tables
    - [x] gtpctfix

 - [ ] drive test analysis script
 
 - [ ] labsat playback analysis script 
 
 
