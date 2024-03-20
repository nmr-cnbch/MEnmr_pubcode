# ifndef INIT_DONE

define delay TP
"TP = 0"

# include <ME/blocks/se.incl>

# define PROXIMAL_XY_G (GRAD_EA(gpProximalX) TPaGRAD):fX

# if defined(H_SHAPED) && !defined(PROXIMAL_H_REFOCUSSING)
#   define PROXIMAL_H_REFOCUSSING
# endif

/*Configure H decoupling during X evolution:*/
# ifdef TROSY
#   define PROXIMAL_XY_H (0u):fH
# elif defined(PROXIMAL_H_REFOCUSSING)
    define delay dXH_refoc
    "dXH_refoc = timeHX*0.5 - eHX_refocussing/2"
#   define PROXIMAL_XY_H (HX_refocussing(ph0) dXH_refoc TP*0.5):fH
# else
#   define PROXIMAL_XY_H (DECOUPLE_H_TROSY_OFF timeHX):fH
# endif

/*Configure evolution of other J couplings to X:*/
# ifdef PROXIMAL_A
#   define PROXIMAL_XY_A (A_inversion(ph0) TPaA):fA
# else
#   define PROXIMAL_XY_A (0u):fH
# endif

# ifdef PROXIMAL_Y
#   define PROXIMAL_XY_Y (Y_inversion(ph0) TPaY):fY
# else
#   define PROXIMAL_XY_Y (0u):fH
# endif

; Timings for X echo:

define delay dXY
# ifdef PROXIMAL_X_CT
    "dXY = timeXY - 2*eX_excitation"
# else
    define delay dXYpre
    "dXYpre = pY_inversion"
    "dXY = timeXY - 2*pY_inversion - 2*eX_excitation"   ; Corrected for the inversion and its compensation.
# endif

define delay TPaY
define delay TPb
define delay TPc
define delay TPaA
define delay TPaGRAD

"acqt0 = 0"
baseopt_echo

; *****************************************************************************
# elif defined(INIT_DONE) && !defined(ME_PULSES)

; Runtime calculations:
# if defined(PROXIMAL_X_CT)
    "TPaY = (dXY + TP)/2"
    "TPb = 0"
    "TPc = dXY/2 - TP/2"
    "TPaA = TP/2"
    "TPaGRAD = 0"
# else
    "TPaY = (dXY + TP)/2"
    "if (TPmax > dXY) {TPb = TP*(1 - dXY/TPmax)/2;} else {TPb = 0;}"
    "if (TPmax > dXY) {TPc = dXY*(1 - TP/TPmax)/2;} else {TPc = dXY/2 - TP/2;}"
    "TPaA = TP/2"
# endif
; Gradient interchanges with first inversion pulse:
  "if (TPaA < (pGRAD + dGRAD)) {TPaGRAD = TP/2 + pA_inversion;} else {TPaGRAD = 0;}"

; *****************************************************************************
# elif defined(ME_PULSES) && !defined(IMPORT_PHASES)

  4u fq=PROXIMAL_fqY(bf ppm):fY
# ifndef PROXIMAL_H_REFOCUSSING
    DECOUPLE_H_ON
# endif
; 2XzYz -> H with evolution (TP):
    (X_fb_UR(phProximal1+phProximal2)):fX
    dXYpre
    TPc
    (X_refocussing(ph0)):fX
    TPb
    (ralign
        PROXIMAL_XY_H
        PROXIMAL_XY_Y
        PROXIMAL_XY_A
        PROXIMAL_XY_G
    )
    
# include <ME/blocks/se.incl>

# define PROXIMAL_MC1 F1EA(calgrad(EA) & calph(phProximal3, +180), caldel(TP, +in1) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC2 F2EA(calgrad(EA) & calph(phProximal3, +180), caldel(TP, +in2) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC3 F3EA(calgrad(EA) & calph(phProximal3, +180), caldel(TP, +in3) & calph(phProximal1, +180) & calph(phRec, +180))
# define PROXIMAL_MC4 F4EA(calgrad(EA) & calph(phProximal3, +180), caldel(TP, +in4) & calph(phProximal1, +180) & calph(phRec, +180))

/****************************************************************************/
# elif defined(IMPORT_PHASES)

# include <ME/blocks/se.incl>

; X excitation:
;# if (PROXIMAL_NUM_COUPLINGS == 1) ; Doesn't work!
# if defined(TROSY)
    phProximal1 = 1 ; Odd number of evolved XY J couplings.
# else
    phProximal1 = 0 ; Even number of evolved XY J couplings.
# endif

; X excitation:
# ifndef DISTAL_PHASES_2
    phProximal2 = 1 3
# elif !defined(DISTAL_PHASES_4)
    phProximal2 = 1 1 3 3
# endif

# if defined(TROSY)
#   define PROXIMAL_PH31 phProximal2 + ph2
# else
#   define PROXIMAL_PH31 phProximal2
# endif

;gpzProximalX: First coherence selection gradient (on N/C): 80%.
# ifndef PROXIMAL_C
;gpzProximalH: Second coherence selection gradient (on H): 1%.
;gpzProximalH2: Third coherence selection gradient (on H): 9.1%.
# else
;gpzProximalH: Second coherence selection gradient (on H): 1%.
;gpzProximalH2: Third coherence selection gradient (on H): 21.1%.
# endif

# endif /*INIT_DONE*/