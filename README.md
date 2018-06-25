# utl_splitting_a_yearly_sas_dataset_into_12_monthly_stata_datasets
Splitting a yearly wps dataset into 12 monthly stata datasets.  Keywords: sas sql join merge big data analytics macros oracle teradata mysql sas communities stackoverflow statistics artificial inteligence AI Python R Java Javascript WPS Matlab SPSS Scala Perl C C# Excel MS Access JSON graphics maps NLP natural language processing machine learning igraph DOSUBL DOW loop stackoverflow SAS community.

    Splitting a yearly wps dataset into 12 monthly stata datasets

    see github
    https://tinyurl.com/ycr65ty3
    https://github.com/rogerjdeangelis/utl_splitting_a_yearly_sas_dataset_into_12_monthly_stata_datasets

    see
    https://mail.google.com/mail/u/0/#inbox/16431960a7029d2e


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

