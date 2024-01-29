# ifndef INIT_DONE

; Set up chemical shift evolution times:
define delay TProximal
"TProximal = 0"

# include <ME/blocks/se.incl>

define delay TproximalPre
define delay TproximalPost
define delay dHX  ; H echo.

; Compensate J evolution delays for gradients and evolution during pulses:
"dHX = timeHX/2 - pGProximalS - dGProximalS - eHX_refocussing/2 - eHX_excitation"

; Compensate X SQ echo if H pulse in the ending pair is longer than the X pulse:
"TproximalPre = larger((pHX_exc_UR - dX_universal), 0)"

; Compensate for inversion pulses during X SQ evolution:
# if (defined(PROXIMAL_NTROSY) || defined(PROXIMAL_ECOSY))
    "TproximalPost = pY_inversion"
# else
    "TproximalPost = larger(pHX_inversion, pY_inversion)"
# endif

; Mutually compensate delays around the N refocussing pulse:
"if (TproximalPre > TproximalPost) {TproximalPre -= TproximalPost; TproximalPost = 0;}"
"if (TproximalPost > TproximalPre) {TproximalPost -= TproximalPre; TproximalPre = 0;}"

/*Determine whether solvent should be +z or -z after first INEPT: */
/* SE and E.COSY don't have any flipback pulses outside initial INEPT.*/
# if ((defined(PROXIMAL_COS_INEPT) && !defined(WG)) || (defined(PROXIMAL_ECOSY) && defined(WG)))
/*  Leave solvent along -z after first INEPT:*/
#   define phPROXIMAL_SOLVENT_HX ph2
# else
#   define phPROXIMAL_SOLVENT_HX ph0
# endif

; Phase of first X pulse in N evolution, adjusted for consistent spectrum phasing:
# if defined(X_ALPHA) || (defined(PROXIMAL_C) && defined(X_BETA))
#   define phTROSY ph1
# else
#   define phTROSY ph3
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
#   if ((defined(PROXIMAL_C) && defined(X_ALPHA)) || defined(X_BETA) || defined(PROXIMAL_HSQC))
      (HX_flipback(ph3)):fH ; CHalpha or NHbeta.
#   else /*C_BETA || N_ALPHA*/
      (HX_flipback(ph1)):fH ; CHbeta or NHalpha.
#   endif
  H2O_FLIPBACK(ph2 + phPROXIMAL_SOLVENT_HX) ; H2O to z by default.
# endif /*NOT X_START*/

  PROXIMAL_GRAD_LONG(gpProximal4)

; HzNz -> HzNy + HzNx with N evolution (T1):
  (X_excitation(phTROSY+phProximal1)):fX
  RDGRAD_ON
  TProximal*0.5
  RDGRAD_OFF
# if defined(PROXIMAL_NTROSY) || defined(PROXIMAL_ECOSY)
    (Y_inversion(ph0)):fY
# else
    (center (HX_inversion(ph0)):fH (Y_inversion(ph0)):fY) ; H2O to -z
# endif
  pGRAD:gpProximalX*EA
  dGRAD
  RDGRAD_ON_NEG
  TProximal*0.5
  RDGRAD_OFF
  TproximalPre
  (X_refocussing(phProximal2)):fX
  pGRAD:gpProximalX2*EA    ; Optional.
  dGRAD
  RDGRAD_COMP ; Compensate for the minimum time of two RDGRADs
  TproximalPost

;   COS-INEPT/Nietlispach TROSY:
# include <ME/blocks/se.incl>

# define PROXIMAL_MC1 F1EA(calgrad(EA) & calph(phProximal3, +180), caldel(TProximal, +in1) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC2 F2EA(calgrad(EA) & calph(phProximal3, +180), caldel(TProximal, +in2) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC3 F3EA(calgrad(EA) & calph(phProximal3, +180), caldel(TProximal, +in3) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC4 F4EA(calgrad(EA) & calph(phProximal3, +180), caldel(TProximal, +in4) & calph(phProximal1, +180) & calph(phRec, +180))

; *****************************************************************************
# elif defined(IMPORT_PHASES)

# include <ME/blocks/se.incl>

; Phase of first X pulse in X evolution (for TPPI in T1):
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

; X refocussing:
# if !defined(DISTAL_PHASES_4) && !defined(PROXIMAL_PHASES_4)
    phProximal2 = 0 0 2 2
# elif !defined(DISTAL_PHASES_8) && !defined(PROXIMAL_PHASES_8)
    phProximal2 = 0 0 0 0 2 2 2 2
# elif !defined(DISTAL_PHASES_16) && !defined(PROXIMAL_PHASES_16)
    phProximal2 = 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2
# else
    phProximal2 = 0
# endif

; Receiver phase for consistent spectrum phasing:
# if !defined(PROXIMAL_C) && defined(X_ALPHA)
    phProximal5 = 2
# elif defined(PROXIMAL_HSQC)
    phProximal5 = 3
# else
    phProximal5 = 0
# endif

# define PROXIMAL_PH31 phProximal5 + phProximal1

;gpnamProximal1: SMSQ10.100
;gpnamProximal4: SMSQ10.100
;gpnamProximalX: SMSQ10.100
;gpnamProximalX2: SMSQ10.100
;gpnamProximalH: SMSQ10.100
;gpnamProximalH2: SMSQ10.100

;gpzProximal1: Gradient in Hz -> HzXz echo: 1%.

;gpzProximal4: Gradient after Hz -> HzXz echo: 3%.

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