# ifndef INIT_DONE

; Set up chemical shift evolution time:
define delay TProximal
"TProximal = 0"

define delay TproximalPost	; 
define delay dHX  ; H -> HXz period.
define delay dHX2_1  ; Second H period - before acquisition.
define delay dHX2_2  ; Second H period - before acquisition.

; Compensate J evolution delays for gradients and evolution during pulses:
"dHX = timeHX/2 - pGProximalL - dGProximalL - eHX_excitation"
"dHX2_1 = timeHX/2 - pGRAD - dGRAD - eHX_WATERGATE/2 - eHX_excitation"
"dHX2_2 = timeHX/2 - pGRAD - dGRAD - eHX_WATERGATE/2 - ME_de"

; Compensate for inversion pulses during X SQ evolution:
  "TproximalPost = larger(pHX_inversion, pY_inversion)"

/*For FB - determine whether solvent should be +z or -z after last H excitation pulse:*/
# if defined(WG)
/*  WATERGATE pulse won't invert solvent -> solvent to z:*/
#   define phPROXIMAL_SOLVENT ph2
# else
/*  If there is inversion in the second INEPT leave solvent along -z after first INEPT:*/
#   define phPROXIMAL_SOLVENT ph0
# endif

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
  PROXIMAL_GRAD_LONG(gpProximal1)
  dHX
  (center (HX_refocussing(ph1)):fH (X_inversion(ph0)):fX)
  dHX
  PROXIMAL_GRAD_LONG(gpProximal1)
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
#   define PROXIMAL_MC1 F1PH(calph(phProximal3, +90), caldel(TProximal, +in1))
#   define PROXIMAL_MC2 F2PH(calph(phProximal3, +90), caldel(TProximal, +in2))
#   define PROXIMAL_MC3 F3PH(calph(phProximal3, +90), caldel(TProximal, +in3))
#   define PROXIMAL_MC4 F4PH(calph(phProximal3, +90), caldel(TProximal, +in4))
# else
#   define PROXIMAL_MC1 F1EA(calgrad(EA), caldel(TProximal, +in1) & calph(phProximal1, +180) & calph(phRec, +180))
#   define PROXIMAL_MC2 F2EA(calgrad(EA), caldel(TProximal, +in2) & calph(phProximal1, +180) & calph(phRec, +180))
#   define PROXIMAL_MC3 F3EA(calgrad(EA), caldel(TProximal, +in3) & calph(phProximal1, +180) & calph(phRec, +180))
#   define PROXIMAL_MC4 F4EA(calgrad(EA), caldel(TProximal, +in4) & calph(phProximal1, +180) & calph(phRec, +180))
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