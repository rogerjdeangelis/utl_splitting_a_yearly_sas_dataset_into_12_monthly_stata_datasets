Splitting a yearly wps dataset into 12 monthly stata datasets

see github
https://tinyurl.com/ycr65ty3
https://github.com/rogerjdeangelis/utl_splitting_a_yearly_sas_dataset_into_12_monthly_stata_datasets

see additional enhancements on end
Paul Dorfman <sashole@bellsouth.net>

INPUT
=====

   sashelp.citimon

   SASHELP.CITIMON TOTAL OBS=145

        DATE  CCIUAC  CCIUTC   CONB   CONQ    EEC

     JAN1980   67166  153636  48579  66820  7.40300
     FEB1980   67119  153308  47759  64049  6.96200
     MAR1980   66786  152347  46705  64831  6.84800
     APR1980   65837  150937  45835  63913  5.98600
     MAY1980   65035  149238  46819  64598  5.83700
     JUN1980   64224  147883  46169  63401  5.69300
     JUL1980   63472  146975  44611  63386  5.94400
     AUG1980   63434  147395  44587  62604  5.87500
     SEP1980   63115  147618  44484  63390  5.79400
     OCT1980   62779  147161  44367  62785  6.15100
     NOV1980   62320  146413  45553  61449  6.25600
     DEC1980   61536  147013  47913  67939  7.20500

   EXAMPLE OUTPUT (Status Log and 12 stata datasets)

   WORK.LOG total obs=12

   Obs    MON    RC     STATUS

     1    JAN     0    Completed
     2    FEB     0    Completed
     3    MAR     0    Completed
     4    APR     0    Completed
     5    MAY     0    Completed
     6    JUN     0    Completed
     7    JUL     0    Completed
     8    AUG     0    Completed
     9    SEP     0    Completed
    10    OCT     0    Completed
    11    NOV     0    Completed
    12    DEC     0    Completed


   12 STATA datsets

   STATA.JAN

        DATE  CCIUAC  CCIUTC   CONB   CONQ    EEC

     JAN1980   62779  147161  44367  62785  6.15100
     JAN1981   62320  146413  45553  61449  6.25600
     JAN1982   61536  147013  47913  67939  7.20500
   ...

   STATA.DEC

        DATE  CCIUAC  CCIUTC   CONB   CONQ    EEC

     DEC1980   62779  147161  44367  62785  6.15100
     DEC1981   62320  146413  45553  61449  6.25600
     DEC1982   61536  147013  47913  67939  7.20500
   ...


PROCESS
=======

  data log;

    do mon=&_monq;

      call symputx("mon",mon);

      rc=dosubl('
        proc export
              data= sashelp.citimon (obs=12 where=(substr(put(date,monyy.),1,3)="&mon."))
              outfile="d:/dta/&mon..dta"
              replace
              dbms=stata;
        run;quit;
      ');

      if rc=0 then status="Completed";
      else status="Failed";
      output;

    end;

  run;quit;


OUTPUT
======

 EXAMPLE OUTPUT FOR JUST DEC


  STATA.DEC

      DATE  CCIUAC  CCIUTC   CONB   CONQ     EEC

   DEC1980   61536  147013  47913   67939  7.20500
   DEC1981   58081  147622  56774   67073  6.92200
   DEC1982   59555  152490  55895   62322  6.29200
   DEC1983   67557  171978  53483   64502  7.24600
   DEC1984   83901  211606  73336   71467  6.47600
   DEC1985   93012  245055  86273   79579  7.06300
   DEC1986  101548  266807  73809   83474  6.88500
   DEC1987  109506  287154  77111   93762  7.15300
   DEC1988  123392  324792  82601   99867  7.33700
   DEC1989  126288  342770  83493  105490  7.94600
   DEC1990  126259  347466  79912  109997  7.29100
   DEC1991       .       .  63700  112400   .

 *                _              _       _
 _ __ ___   __ _| | _____    __| | __ _| |_ __ _
| '_ ` _ \ / _` | |/ / _ \  / _` |/ _` | __/ _` |
| | | | | | (_| |   <  __/ | (_| | (_| | || (_| |
|_| |_| |_|\__,_|_|\_\___|  \__,_|\__,_|\__\__,_|

;

   just use sashelp.citimon

 *          _       _   _
 ___  ___ | |_   _| |_(_) ___  _ __
/ __|/ _ \| | | | | __| |/ _ \| '_ \
\__ \ (_) | | |_| | |_| | (_) | | | |
|___/\___/|_|\__,_|\__|_|\___/|_| |_|

;

se process

*          _     _          _                  _   _               _
  __ _  __| | __| | ___  __| |  _ __ ___   ___| |_| |__   ___   __| |___
 / _` |/ _` |/ _` |/ _ \/ _` | | '_ ` _ \ / _ \ __| '_ \ / _ \ / _` / __|
| (_| | (_| | (_| |  __/ (_| | | | | | | |  __/ |_| | | | (_) | (_| \__ \
 \__,_|\__,_|\__,_|\___|\__,_| |_| |_| |_|\___|\__|_| |_|\___/ \__,_|___/

;


Paul Dorfman <sashole@bellsouth.net>

Roger,

As you of course know, this can be done in a single pass using as
many hash object instances as there are months available in the data set:

data _null_ ;
  dcl hash hh (ordered:"a") ;
  hh.definekey  ("m") ;
  hh.definedata ("mon", "h") ;
  hh.definedone () ;
  do until (z) ;
    set sashelp.citimon end = z ;
    m = month (date) ;
    mon = put (date, worddate3.) ;
    if hh.find() ne 0 then do ;
      dcl hash h (dataset:"sashelp.citimon(obs=0)", multidata:"y") ;
      h.definekey ("date") ;
      h.definedata (all:"y") ;
      h.definedone () ;
      hh.add() ;
    end ;
    h.add() ;
  end ;
  dcl hiter ihh ("hh") ;
  do while (ihh.next() = 0) ;
    h.output (dataset:mon) ;
  end ;
  stop ;
run ;

The problem with the above is that there must be enough memory
to house hash data roughly equivalent to the entire data set being split.
The program below takes a kind of opposite approach in the sense that
it requires only enough memory to hold the data from the month with the
largest number of records; but trades this efficiency for reading the
data set 12 times. Even though the
latter is somewhat alleviated by using the WHERE clause, the program
is not likely to win any races. However, I've decided to post it for two reasons:

1. It illustrates a curious angle of the dynamic nature of the hash object.
2. I haven't seen it done this way before.

data _null_ ;
  do i = 0 to 11 ;
    d = intnx("mon",0,i) ;
    dcl hash h (dataset:cats("sashelp.citimon(where=(month(date)=",month(d),"))"),multidata:"y") ;
    h.definekey ("date") ;
    h.definedata (all:"y") ;
    h.definedone() ;
    h.output (dataset:put(d,worddate3.)) ;
    h.clear() ;
  end ;
  stop ;
  set sashelp.citimon ;
run ;

Best regards,
Paul Dorfman


Roger DeAngelis <rogerjdeangelis@gmail.com>

This made me think of pacing the 'proc export' to stata inside the hash datastep.
See below

A HASH has the interesting property of closing created datasets when
the hash is closed, not at datastep completion. The code below
creates 12 additional datasets, with the sum of variable CONB.

This may have some interesting possibilities, ie sharing the hash table, or
loading the results of a HASH into and array and peek into the array in
imbedded DOSUBLs.

JANSUM
FEBSUM
...
DECSUM

Example additional output

WORK.JANSUM total obs=1

Obs    DTEMIN    DTEMAX    CONBMLL

 1      7305      11688    73736.5



data _null_ ;
  dcl hash hh (ordered:"a") ;
  hh.definekey  ("m") ;
  hh.definedata ("mon", "h") ;
  hh.definedone () ;
  do until (z) ;
    set sashelp.citimon end = z ;
    m = month (date) ;
    mon = put (date, worddate3.) ;
    if hh.find() ne 0 then do ;
      dcl hash h (dataset:"sashelp.citimon(obs=0)", multidata:"y") ;
      h.definekey ("date") ;
      h.definedata (all:"y") ;
      h.definedone () ;
      hh.add() ;
    end ;
    h.add() ;
  end ;
  dcl hiter ihh ("hh") ;
  do while (ihh.next() = 0) ;
    h.output (dataset:mon) ;
  end ;
  rc=dosubl('
     %array(mons,values=&_mon);
     %do_over (mons,phrase=%str(
         proc sql;
            create
               table ?sum as
            select
               min(date) as dteMin
              ,max(date) as dteMax
              ,median(conb) as conbMll
            from
               ?
            ;quit;
         ))
   ');
  stop ;
run ;









