Vectorized solution to finding *first* element in a row meeting criterion

WPS/Proc R solution

github (do not copy and paste from readme.md us the .sas file)
https://tinyurl.com/y8mqtt98
https://github.com/rogerjdeangelis/utl_vectorized_solution_to_finding_first_element_in_a_row_meeting_criterion

https://tinyurl.com/yacj7kxv
https://communities.sas.com/t5/SAS-IML-Software-and-Matrix/Vectorized-solution-to-finding-first-element-in-a-row-meeting/m-p/464858

INPUT
=====
                             | WANT |
 WORK.HAVE total obs=3       |      |
                             |      |  column index for *first* occurance < .1 in each row
     V1      V2      V3      |      |  0 if no element < .1
                             |      |
    0.20    0.30    0.05     |  3   |  V3 first col less than .1
    0.01    0.01    0.01     |  1   |  V1 first col less than .1
    0.20    0.30    0.50     |  0   |  no columns so return 0


EXAMPLE OUTPUT

   WORK.WANT total obs=3

   Obs    WANT

    1       3
    2       1
    3       0


PROCESS ( Working code)
=======================

  zroOne<-(have<.1)*1;   * binary matrix;

  * find the first 1 and use rowMax to set value to 0;
  want<-max.col(zroOne,"first")*rowMaxs(zroOne);


OUTPUT
======

options validvarname=upcase;
libname sd1 "d:/sd1";
data sd1.have;
 input v1 v2 v3;
cards4;
0.20 0.30 0.05
0.01 0.01 0.01
0.20 0.30 0.50
;;;;
run;quit;

*          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

%utl_submit_wps64('
libname sd1 "d:/sd1";
options set=R_HOME "C:/Program Files/R/R-3.3.2";
libname wrk  sas7bdat "%sysfunc(pathname(work))";
proc r;
submit;
source("C:/Program Files/R/R-3.3.2/etc/Rprofile.site", echo=T);
library(matrixStats);
library(haven);
have<-as.matrix(read_sas("d:/sd1/have.sas7bdat"));
have;
zroOne<-(have<.1)*1;
want<-max.col(zroOne,"first")*rowMaxs(zroOne);
want;
endsubmit;
import r=want data=wrk.want;
run;quit;
');

proc print data=want;
run;quit;


