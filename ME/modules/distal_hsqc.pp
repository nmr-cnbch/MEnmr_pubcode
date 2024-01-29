/*
  -DHSHIFT: time-dependant phase shift for TPPI shifting of offset in T1 (H).
*/

# ifndef INIT_DONE

define delay T1
"T1 = 0"
define delay T2
"T2 = 0"
define delay T1max
"T1max = max(in1*(td1/2 - 1), 0)"

# ifdef HSHIFT
; Calculate time-dependant phase shift for TPPI shifting of offset in T1 (H):
    "cnst62 = -((bf1*cnst61) - (o1*1000000))"
    "cnst63 = -(cnst62*inf1/1000000)*360"
    print "dimensions: cnst61"
# endif /*HSHIFT*/

; Set up delays:

define delay TdistalPost
; Compensate for inversion pulses during X SQ evolution:
"TdistalPost = larger(pHX_inversion, pY_inversion)"

define delay dDHX
define delay timeDHX2
"
 dDHX = timeDHX/2 - pGDistalS - dGDistalS - eDHX_refocussing/2 - eDHX_excitation"
"timeDHX2 = timeDHX - 2*eDHX_excitation"

define delay T1a
define delay T1b
define delay T1c

"T1a = 0"
"T1b = 0"
"T1c = 0"
"T1a = timeDHX2/2 + T1/2"

; *****************************************************************************
# elif defined(INIT_DONE) && !defined(ME_PULSES)

  "if (T1max > timeDHX2) {T1b = T1*(1 - timeDHX2/T1max)/2;} else {T1b = 0;}"
  "if (T1max > timeDHX2) {T1c = timeDHX2*(1 - T1/T1max)/2;} else {T1c = timeDHX2/2 - T1/2;}"

# ifndef DISTAL_X_START
; Hz -> HzXz:
  (HX_excitation(ph0)):fH
  DISTAL_GRAD_SHORT(gpDistal1)
  dDHX
  (center (HX_inversion(ph1)):fH (X_inversion(ph0)):fX)
  dDHX
  DISTAL_GRAD_SHORT(gpDistal1)
  (HX_flipback(ph1)):fH
  H2O_FLIPBACK(ph2) ; H2O to +z.
# endif /*X_START*/

  DISTAL_GRAD_LONG(gpDistal2)

; HzNz -> HzNy + HzNx with N evolution (T1):
  (X_excitation(phDistal1)):fX
  RDGRAD_ON
  T2*0.5
  RDGRAD_OFF
  (center (HX_inversion(ph0)):fH (Y_inversion(ph0)):fY) ; H2O to -z.
  RDGRAD_ON_NEG
  T2*0.5
  RDGRAD_OFF
  DISTAL_GRAD_SHORT(gpDistal3)
  (X_refocussing(phDistal2)):fX
  DISTAL_GRAD_SHORT(gpDistal3)
  RDGRAD_COMP
  TdistalPost
  (X_flipback(phDistal3)):fX

  DISTAL_GRAD_LONG(gpDistal4)

; HzXz -> Ht:
  H2O_FLIPBACK(ph0)
  (HX_excitation(ph0)):fH
  T1a
  (X_inversion(ph0)):fX
  DISTAL_GRAD_SHORT(gpDistal5)
  T1b
  (HX_refocussing(ph0)):fH
  DISTAL_GRAD_SHORT(gpDistal5)
  T1c
  (HX_flipback(phDistal4)):fH
  H2O_FLIPBACK(phDistal4)

# ifdef HSHIFT
#   define DISTAL_MC1 F1PH(calph(phDistal4, 90), caldel(T1, +in1) & calph(phDistal4, cnst63))
# else
#   define DISTAL_MC1 F1PH(calph(phDistal4, 90), caldel(T1, +in1))
# endif

# define DISTAL_MC2 F2PH(calph(phDistal3, -90), caldel(T2, +in2))

; *****************************************************************************
# elif defined(ME_PULSES) && !defined(IMPORT_PHASES)

/*****************************************************************************/
# elif defined(IMPORT_PHASES)

# define DISTAL_PHASES_2
# define DISTAL_PHASES_8

phDistal1 = 0 2  ; X excitation.
phDistal2 = 0  ; X refocussing.

; X flipback:
# if defined(DISTAL_PHASES_4)
    phDistal3 = 0 0 2 2  ; X flipback
# elif defined(DISTAL_PHASES_8)
    phDistal3 = 0 0 0 0 2 2 2 2
# else
    phDistal3 = 0
# endif

phDistal4 = 1    ; H flipback.

# define DISTAL_PH31 phDistal1 + phDistal3

;for z-only gradients:
;gpzDistal1: Distal HSQC: short gradient in the Hz -> HzNz echo: 5%.
;gpzDistal2: Distal HSQC: gradient after the Hz -> HzNz echo: 17%.
;gpzDistal3: Distal HSQC: short gradient in the N echo: 3.1%.
;gpzDistal4: Distal HSQC: gradient after the N echo: 13%.
;gpzDistal5: Distal HSQC: short gradient in the HzNz -> Hz echo: 2.1%.

;use gradient files:
;gpnamDistal1: SMSQ10.100
;gpnamDistal2: SMSQ10.100
;gpnamDistal3: SMSQ10.100
;gpnamDistal4: SMSQ10.100
;gpnamDistal5: SMSQ10.100
# endif