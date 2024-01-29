# ifndef INIT_DONE

; Set up chemical shift evolution times:
define delay TProximal
"TProximal = 0"

;define delay TproximalPre
define delay TproximalPost
define delay dHX  ; H echo.
define delay dHX2_1  ; Second H echo - before acquisition.
define delay dHX2_2  ; Second H echo - before acquisition.

; Compensate J evolution delays for gradients and evolution during pulses:
"dHX = timeHX/2 - pGProximalS - dGProximalS - eHX_WATERGATE/2 - eHX_excitation"
"dHX2_1 = timeHX/2 - pGRAD - dGRAD - eHX_WATERGATE/2 - eHX_excitation"
"dHX2_2 = timeHX/2 - pGRAD - dGRAD - eHX_WATERGATE/2 - ME_de"

; Compensate for inversion pulses during X SQ evolution:
  "TproximalPost = larger(pHX_inversion, pY_inversion)"

/*Determine whether solvent should be +z or -z after last excitation pulse:*/
# if defined(WG)
/*  WATERGATE pulse won't rotate solvent -> solvent to z:*/
#   define phPROXIMAL_SOLVENT ph2
# else
/*  Leave solvent along -z after first INEPT:*/
#   define phPROXIMAL_SOLVENT ph0
# endif

# ifdef PROXIMAL_GS
#   define GRAD_PROXIMAL_GS(gpnGS,gpn) GRAD_EA(gpnGS)
#   define GRAD_PROXIMAL(gpnGS,gpn) GRAD(gpnGS)
# elif defined(PROXIMAL_GRAD)
#   define GRAD_PROXIMAL_GS(gpnGS,gpn) GRAD(gpn)
#   define GRAD_PROXIMAL(gpnGS,gpn) GRAD(gpn)
# else
#   define GRAD_PROXIMAL_GS
# endif /*PROXIMAL_GS*/

; Phase of last H excitation pulse:
# ifdef GS
#   define phGS ph3
# else
#   define phGS ph2
# endif

"acqt0 = 0"
baseopt_echo
; *****************************************************************************
# elif defined(INIT_DONE) && !defined(ME_PULSES)

; *****************************************************************************
# elif defined(ME_PULSES) && !defined(IMPORT_PHASES)


# ifndef PROXIMAL_X_START
; Hz -> HzXz:
  (HX_excitation(ph0)):fH
  PROXIMAL_GRAD_SHORT(gpProximal1)
  dHX
  (center (HX_inversion(ph1)):fH (X_inversion(ph0)):fX)
  dHX
  PROXIMAL_GRAD_SHORT(gpProximal1)
  (HX_flipback(ph1)):fH
  H2O_FLIPBACK(ph0)
# endif /*X_START*/

  PROXIMAL_GRAD_LONG(gpProximal4)

; HzNz -> HzNy + HzNx with N evolution (T1):
  (X_excitation(phProximal1)):fX
  RDGRAD_ON
  TProximal*0.5
  RDGRAD_OFF
  (center (HX_inversion(ph0)):fH (Y_inversion(ph0)):fY)
  RDGRAD_ON_NEG
  TProximal*0.5
  RDGRAD_OFF
;  TproximalPre
  GRAD_PROXIMAL(gpProximalX,gpProximal2)
  (X_refocussing(ph0)):fX
  GRAD_PROXIMAL(gpProximalX2,gpProximal2)
  RDGRAD_COMP
  TproximalPost
  (X_flipback(phProximal3)):fX

  PROXIMAL_GRAD_LONG(gpProximal5)

; HzXz -> Ht:
  H2O_FLIPBACK(phGS + phPROXIMAL_SOLVENT)
  (HX_excitation(phGS)):fH
  GRAD_PROXIMAL_GS(gpProximalH,gpProximal3)
  dHX2_1
  (center (HX_WATERGATE(ph0)):fH (X_refocussing(ph0)):fX)
  GRAD_PROXIMAL_GS(gpProximalH2,gpProximal3)
  dHX2_2 CPD_POW BLKGRAD

# ifndef GS
# define PROXIMAL_MC1 F1PH(calph(phProximal3, +90), caldel(TProximal, +in1))
# define PROXIMAL_MC2 F2PH(calph(phProximal3, +90), caldel(TProximal, +in2))
# define PROXIMAL_MC3 F3PH(calph(phProximal3, +90), caldel(TProximal, +in3))
# define PROXIMAL_MC4 F4PH(calph(phProximal3, +90), caldel(TProximal, +in4))
# else
# define PROXIMAL_MC1 F1EA(calgrad(EA), caldel(TProximal, +in1) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC2 F2EA(calgrad(EA), caldel(TProximal, +in2) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC3 F3EA(calgrad(EA), caldel(TProximal, +in3) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC4 F4EA(calgrad(EA), caldel(TProximal, +in4) & calph(phProximal1, +180) & calph(phRec, +180))
# endif

; *****************************************************************************
# elif defined(IMPORT_PHASES)

; X excitation:
# if !defined(DISTAL_PHASES_2)
    phProximal1 = 0 2 
#   define PROXIMAL_PHASES_2
# elif !defined(DISTAL_PHASES_4)
    phProximal1 = 0 0 2 2 
#   define PROXIMAL_PHASES_4
# else
    phProximal1 = 0 0 0 0 2 2 2 2
#   define PROXIMAL_PHASES_8
# endif

; X flipback:
# if !defined(DISTAL_PHASES_4) && !defined(PROXIMAL_PHASES_4)
    phProximal3 = 0 0 2 2
# elif !defined(DISTAL_PHASES_8) && ! defined(PROXIMAL_PHASES_8)
    phProximal3 = 0 0 0 0 2 2 2 2
# elif !defined(DISTAL_PHASES_16) && ! defined(PROXIMAL_PHASES_16)
    phProximal3 = 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2
# else
    phProximal3 = 0
# endif

# define PROXIMAL_PH31 phProximal1 + phProximal3

;gpnamProximal1: SMSQ10.100
;gpnamProximal2: SMSQ10.100
;gpnamProximal3: SMSQ10.100
;gpnamProximal4: SMSQ10.100
;gpnamProximal5: SMSQ10.100
;gpnamProximalX: SMSQ10.100
;gpnamProximalX2: SMSQ10.100
;gpnamProximalH: SMSQ10.100
;gpnamProximalH2: SMSQ10.100

;gpzProximal1: Gradient in Hz -> HzXz echo: 1%.

;gpzProximal2: Short gradient in X evolution echo: 5%.
;gpzProximal3: Short gradient in HzXz -> Ht (WATERGATE) echo: 21%.

;gpzProximal4: Gradient after Hz -> HzXz echo: 3%.
;gpzProximal5: Gradient after X evolution echo : 11%.

;gpzProximalX: First coherence selection gradient (on N/C): 80%.
;gpzProximalX2: Second coherence selection gradient (on N/C): 0%.

# ifndef PROXIMAL_C
;gpzProximalH: Third coherence selection gradient (on H): 1%.
;gpzProximalH2: Forth coherence selection gradient (on H): 9.1%.
# else
;gpzProximalH: Third coherence selection gradient (on H): 1%.
;gpzProximalH2: Forth coherence selection gradient (on H): 21.1%.
# endif

# endif /*INIT_DONE*/