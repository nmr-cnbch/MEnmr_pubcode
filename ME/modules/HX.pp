# ifndef INIT_DONE

/*Don't use gradients by default:*/
# if !defined(DISTAL_GRAD) && !defined(DISTAL_NO_GRAD) && !defined(DISTAL_GS)
#   define DISTAL_NO_GRAD
# endif

# ifdef GRAD
#   define D_SHORT_GRADIENT(gpn) pGDistalS:gpn dGDistalS
# else
  "pGDistalS = 0"
  "dGDistalS = 0"
#   define D_SHORT_GRADIENT(gpn)
# endif

# ifdef GRAD
#   define D_LONG_GRADIENT(gpn) pGDistalL:gpn dGDistalL
# else
  "pGDistalL = 0"
  "dGDistalL = 0"
#   define D_LONG_GRADIENT(gpn)
# endif

# if defined(DISTAL_H_EVOLVED) || defined(DISTAL_X_EVOLVED)
#   define DISTAL_EVOLVED
# endif

# ifndef DISTAL_EVOLVED
#   define DISTAL_H_CT
#   define DISTAL_X_CT
# endif

# ifdef DISTAL_NO_GRAD
#   define DISTAL_T1_GRAD1
#   define DISTAL_T1_GRAD2
#   define DISTAL_XY_G (0u):fH
    "pGDistalS = 0"
    "dGDistalS = 0"
;# elif defined(DISTAL_GS)
;#   define DISTAL_T1_GRAD1 D_SHORT_GRADIENT(gpDistalH)
;#   define DISTAL_T1_GRAD2 D_SHORT_GRADIENT(gpDistalH2)
;#   define DISTAL_XY_G (T2aGRAD GRAD_EA(gpDistalX)):fDX
# elif !defined(DISTAL_EVOLVED)
#   define DISTAL_T1_GRAD1 D_SHORT_GRADIENT(gpDistal1)
#   define DISTAL_T1_GRAD2 D_SHORT_GRADIENT(gpDistal1)
#   define DISTAL_XY_G (0u):fH
# else
#   define DISTAL_T1_GRAD1 D_SHORT_GRADIENT(gpDistal2)
#   define DISTAL_T1_GRAD2 D_SHORT_GRADIENT(gpDistal2)
#   define DISTAL_XY_G (0u):fH
# endif

# if defined(H_SHAPED) && !defined(DISTAL_H_REFOCUSSING)
#   define DISTAL_H_REFOCUSSING
# endif

/*Configure H decoupling during X evolution:*/
# ifdef DISTAL_X_TROSY
#   define DISTAL_XY_H (0u):fH
# elif defined(DISTAL_H_REFOCUSSING)
    define delay dDHrefoc
    "dDHrefoc = (timeDHX - eHX_refocussing)/2"
#   define DISTAL_XY_H (dDHrefoc H_refocussing(ph0)):fH
# else
#   define DISTAL_XY_H (timeDHX DECOUPLE_H_TROSY_ON):fH
# endif

/*Configure evolution of other J couplings to X:*/
# if defined(DISTAL_A) && defined(DISTAL_X_EVOLVED)
#   define DISTAL_XY_A (T2aA A_inversion(ph0)):fDA
# else
#   define DISTAL_XY_A
# endif

# if defined(DISTAL_Y) && !defined(DISTAL_X_CT)
#   define DISTAL_XY_Y (T2aY Y_inversion(ph0)):fDY
# elif !defined(DISTAL_Y_EVOLVED)
#   define DISTAL_XY_Y (dDXY*0.5):fDY   /*Left delay in a symmetric, non-evolved echo.*/
# else
#   define DISTAL_XY_Y (0u):fH
# endif

; Timings:
; Compensate for the staggered X pulse in SCT evolution:
define delay dDHXpost
"dDHXpost = pX_inversion"

; Portion of J evolution time available for H evolution:
define delay dDHX
;# ifdef DISTAL_TROSY
;    "dDHX = 0"
# if defined(DISTAL_H_CT) && !defined(DISTAL_EVOLVED)
    "dDHX = timeDHX - eH_refocussing - 2*eH_excitation"; - 2*pGDistalS - 2*dGDistalS"
# elif defined(DISTAL_H_CT) && defined(DISTAL_EVOLVED)
    "dDHX = timeDHX - eH_refocussing - 2*eH_excitation - 2*pGDistalS - 2*dGDistalS"
# else /*SCT without TROSY*/
    "dDHX = timeDHX - 2*eH_excitation - 2*pGDistalS - 2*dGDistalS - dDHXpost"
# endif

# ifdef DISTAL_H_EVOLVED
    define delay T1a
    define delay T1b
    define delay T1c
#   define distalT1a T1a
#   define distalT1c T1c
# else
#   define distalT1a dDHX*0.5
#   define distalT1c dDHX*0.5
# endif

; Timings for X echo:
define delay dDXY
# ifdef DISTAL_X_CT
    "dDXY = timeXY - 2*eX_excitation"
# else
    define delay dDXYpost
    "dDXYpost = pY_inversion"
    "dDXY = timeXY - 2*pY_inversion - 2*eX_excitation"  ; Corrected for the inversion and its compensation.
# endif

# ifdef DISTAL_N_EVOLVED
#   define distalT2b T2b
#   define distalT2c T2c
# else
#   define distalT2b 0u
#   define distalT2c dDXY*0.5
# endif

# ifdef HSHIFT
;   Calculate time-dependant phase shift for TPPI shifting of offset in T1 (H):
    "cnst62 = -((bf1*cnst61) - (o1*1000000))"
    "cnst63 = -(cnst62*inf1/1000000)*360"
# endif /*HSHIFT*/

define delay T1a
define delay T1b
define delay T1c
define delay T2aY
define delay T2aA

"T1a = 0"
"T1b = 0"
"T1c = 0"
"T2aA = 0"
"T2aY = 0"

; *****************************************************************************
# elif defined(INIT_DONE) && !defined(ME_PULSES) &&  !defined(IMPORT_PHASES)

; Run-time calculations:
# ifdef DISTAL_H_EVOLVED
#   ifdef DISTAL_H_TROSY
      "T1a = T1"
      "T1b = 0"
      "T1c = 0"
#   elif defined(DISTAL_H_CT)
      "T1a = (dDHX + T1)/2"
      "T1b = 0"
      "T1c = (dDHX - T1)/2"
#   else /*SCT*/
      "T1a = (dDHX + T1)/2"
      "if (tmax1 <= dDHX) {T1b = 0;} else {T1b = T1*(1 - dDHX/tmax1)/2;}"
      "if (tmax1 <= dDHX) {T1c = dDHX*(1 - T1/tmax1)/2;} else {T1c = (dDHX - T1)/2;}"
#   endif
# endif
# if defined(DISTAL_X_EVOLVED)
#   if defined(DISTAL_X_CT)
    "T2aY = (dDXY + T2)/2"
    "T2b = 0"
    "T2c = dDXY/2 - T2/2"
    "T2aA = T2/2"
#   else
    "T2aY = (dDXY + T2)/2"
    "if (T2max > dDXY) {T2b = T2*(1 - dDXY/T2max)/2;} else {T2b = 0;}"
    "if (T2max > dDXY) {T2c = dDXY*(1 - T2/T2max)/2;} else {T2c = dDXY/2 - T2/2;}"
    "T2aA = T2/2"
#   endif
# endif

; *****************************************************************************
;# elif defined(ME_PULSES) && !defined(IMPORT_PHASES)

/*No X inversion in case of TROSY:*/
# ifdef DISTAL_H_TROSY
#   define X_INVERSION_TROSY(ph) (0u):fDX
# else
#   define X_INVERSION_TROSY(ph) (X_inversion(ph)):fDX
# endif

; Hz -> HzXz:
# ifdef DISTAL_H_EVOLVED
    H2O_FLIPBACK(ph0)
# endif
  (HX_excitation(ph0)):fH
# if defined(DISTAL_H_CT) || defined(DISTAL_H_TROSY)
    DISTAL_T1_GRAD1
    distalT1a
    (center (HX_refocussing(ph0)):fH X_INVERSION_TROSY(ph0))
    distalT1c
    DISTAL_T1_GRAD2
# else /*SCT*/
    DISTAL_T1_GRAD1
    distalT1a
    X_INVERSION_TROSY(ph0)
    T1b
    (H_refocussing(ph0)):fH
    distalT1c
    dDHXpost
    DISTAL_T1_GRAD2
# endif
  (HX_flipback(phDistal1)):fH
# ifndef DISTAL_H_EVOLVED
    H2O_FLIPBACK(ph2+phDistal1)
# else
    H2O_FLIPBACK(ph0)
# endif

  4u fq=DISTAL_fqY(bf ppm):fDY
  D_LONG_GRADIENT(gpDistal3)

; 2HzXz -> 2XzYz:
  (X_excitation(phDistal3)):fDX
  (lalign
    DISTAL_XY_Y
    DISTAL_XY_H
    DISTAL_XY_G
    DISTAL_XY_A
  )
  distalT2b

# ifdef DISTAL_X_CT
    (center (Y_inversion(ph0)):fDY  (X_refocussing(ph0)):fDX)
# else
    (X_refocussing(ph0)):fDX
    dDXYpost    ; Compensate for length of Y pulse.
# endif
  distalT2c
  (X_flipback(phDistal4)):fDX

# ifndef DISTAL_H_REFOCUSSING
  DECOUPLE_H_OFF
# endif
  D_LONG_GRADIENT(gpDistal4)

# ifdef HSHIFT
#   define DISTAL_MC1 F1PH(calph(phDistal1, 90), caldel(T1, +in1) & calph(phDistal1, cnst63))
# else
#   define DISTAL_MC1 F1PH(calph(phDistal1, 90), caldel(T1, +in1))
# endif

# define DISTAL_MC2 F2PH(calph(phDistal4, -90), caldel(T2, +in2))

; *****************************************************************************
# elif defined(IMPORT_PHASES)

; H flipback:
phDistal1 = 1

# define DISTAL_PHASES_2

; X excitation:
phDistal3 = 0 2

; X flipback:
;# if (DISTAL_NUM_COUPLINGS == 1) || (DISTAL_NUM_COUPLINGS == 3); Doesn't work!
# if defined(DISTAL_X_TROSY)
    phDistal4 = 1 ; Odd number of evolved XY J couplings.
# else
    phDistal4 = 0 ; Even number of evolved XY J couplings.
# endif

# define DISTAL_PH31 phDistal3

;for z-only gradients:
;gpzDistal1: DHX: gradient in Hz -> 2HzXz echo (no evolution): 1%.
;gpzDistal2: DHX: short gradient in Hz -> 2HzXz echo (no evolution): 2.7%.
;gpzDistal3: DHX: gradient after Hz -> 2HzXz echo: 3%.
;gpzDistal4: DHX: gradient after 2XzHz -> 2XzYz echo: 5%.

;use gradient files:
;gpnamDistal1: SMSQ10.100
;gpnamDistal2: SMSQ10.100
;gpnamDistal3: SMSQ10.100
;gpnamDistal4: SMSQ10.100

# endif /*INIT_DONE*/