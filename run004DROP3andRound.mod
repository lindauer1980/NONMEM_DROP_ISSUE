;; 1. Based on: 
;; 2. Description: DROP 3 variables with rounded variables in input
;; x1. Author: alindauer
$PROBLEM    DROP 3 variables
$INPUT ID,AMT,TIME,DV,LNDV,EVID,ADDL,II,SS,TSLD,PLAC,FLGW,FLGTAP,FLGXXX,
       FORM,AGEG,AGEG2,WT,HT,AGE=DROP,SEX,EGFR=DROP,LBW,BMI,BSA,IND,XY1,XY2,
       XY3=DROP,XY4,FLG1,FLG2,FLG3,STUDY,COUNTRY,XYZ,FLGID,FLGDV,XYZCODE

;-------------------------------------------------------------------------
$DATA      dummyData_Rounded.csv IGNORE=@
            IGNORE=(FLGXXX.EQ.1,TIME.LT.0,ID.EQ.4300120,FLGDV.EQ.1,
            PLAC.EQ.1,FLG3.EQ.1,FLGW.EQ.1,FLGTAP.EQ.1,FLGID.EQ.0)
$SUBROUTINE ADVAN2
$PK

;------------------------------------------------------------------------
TVCL  = THETA(3) ;Clearance (L/hr)
TVVC  = THETA(4) ;Volume (L)
TVKA  = THETA(5) ;Ka (1/hr) 
TVF1  = THETA(6) ; relative bioavailability

;------------------------------------------------------------------------
CL    = TVCL*EXP(ETA(1))*((WT/70)**0.75)
V     = TVVC*EXP(ETA(2))*(WT/70)
S2    = V
K     = CL/V
KA    = TVKA*EXP(ETA(3)) 
F1    = TVF1

;DVDN=DV/DOSE
;--------------------------------------------------------------------------
$ERROR 
propRUV = THETA(1)
addRUV  = THETA(2)

IPRED = F    
IRES  = DV-IPRED

W     = SQRT(addRUV**2 + propRUV**2 * IPRED**2)
Y     = IPRED+ERR(1)*W    
DEL   = 0    
IF(W.EQ.0) DEL  = 1
IWRES = IRES/(W+DEL)

;-----------------------------------------------------------------------------
$THETA  (0.001,0.26) ; propRUV
$THETA  (0.001,0.43) ; addRUV
$THETA  (0.001,2) ; CL; L/hr
$THETA  (0.01,40) ; V; L
$THETA  (0.01,2) ; Ka; 1/hr
$THETA  1 FIX ; F
$OMEGA  0.08  ;     IIV_CL
 0.04  ;      IIV_V
 0.05  ;     IIV_KA
$SIGMA  1  FIX
$ESTIMATION SIG=3 PRINT=1 MAXEVAL=9999 NOABORT POSTHOC METHOD=COND
INTERACTION NOOBT NOTBT
$COVARIANCE PRINT=E MATRIX=R
$TABLE ID TIME TSLD AMT STUDY EVID PRED IPRED IWRES IRES CWRES
NOPRINT ONEHEADER FORMAT=SF11.3 FILE=sdtab002

