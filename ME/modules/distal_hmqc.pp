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

define delay T1a
define delay T1b
define delay T1c

"T1a = 0"
"T1b = 0"
"T1c = 0"

define delay deltaDHpre  ; Correction for H chemical shift evolution due to pulses in outer echo.
define delay deltaDHpost

"deltaDHpre = pDHX_refoc"

define delay deltaDX  ; Correction for gradient and pulses in T1.
"deltaDX = pDHX_refoc"

# ifdef DISTAL_GRAD
#   define D_SHORT_GRADIENT(gpn) pGDistalS:gpn dGDistalS
# else
  "pGDistalS = 0"
  "dGDistalS = 0"
#   define D_SHORT_GRADIENT(gpn)
# endif

"deltaDHpre = 0"
"deltaDHpost = 2*eDHX_excitation"

define delay dDHX    ; Delay for HX J coupling back-evolution (single H only).
"dDHX = timeDHX - 2*eDHX_excitation"   ; Two pulses and the delay compensating for the evolution.

; *****************************************************************************
# elif defined(INIT_DONE) && !defined(ME_PULSES)

  "T1a = T1/2"
  "T1b = 0"
  "T1c = dDHX - T1/2"

; Hz -> HzCz
  H2O_FLIPBACK(phDistal1)
  (DHX_excitation(phDistal1)):fH
  deltaDHpre    ; Compensate for the delay deltaDX in X echo.
  T1a
  (center (DX_refocussing(ph0)):fDX (DHX_refocussing(ph0)):fH) ; For hard pulses brings solvent to -z.
  T1c
  deltaDHpost   ; Compensate for evolution in excitation/flipback pulses.

; HzCz real-time evolution of C:
  (DX_excitation(phDistal3)):fDX
  D_SHORT_GRADIENT(gpDistal2)
  deltaDX ; Compensate for DHX_refocussing.
  (DX_refocussing(phDistal4)):fDX
  T2*0.5

  (DHX_refocussing(phDistal2)):fH
  D_SHORT_GRADIENT(gpDistal2)

  T2*0.5
  (DX_flipback(phDistal5)):fDX

; HzCz -> Ht:
  dDHX
  (DHX_flipback(ph0)):fH
  H2O_FLIPBACK(ph0)


# ifdef HSHIFT
#   define DISTAL_MC1 F1PH(calph(phDistal1, 90), caldel(T1, +in1) & calph(phDistal1, cnst63))
# else
#   define DISTAL_MC1 F1PH(calph(phDistal1, 90), caldel(T1, +in1))
# endif

# define DISTAL_MC2 F2PH(calph(phDistal3, -90), caldel(T2, +in2))

; *****************************************************************************
# elif defined(ME_PULSES) && !defined(IMPORT_PHASES)

/*****************************************************************************/
# elif defined(IMPORT_PHASES)

phDistal1 = 2  ; H excitation.
phDistal2 = 0  ; H refocussing.

# define DISTAL_PHASES_2
# define DISTAL_PHASES_8

phDistal3 = 0 2  ; X excitation.
phDistal4 = 0    ; X refocussing.

# if defined(DISTAL_PHASES_4)
    phDistal5 = 0 0 2 2  ; X flipback.
# elif defined(DISTAL_PHASES_8)
    phDistal5 = 0 0 0 0 2 2 2 2 ; X flipback.
# else
    phDistal5 = 0 0  ; X flipback.
# endif

# define DISTAL_PH31 phDistal3 + phDistal5

;for z-only gradients:
;gpzDistal1: Distal HMQC: gradient in the outer echo (H): 17%.
;gpzDistal2: Distal HMQC: gradient in the inner (X and H) echo: 5%.
;gpzDistal3: Distal HMQC: second gradient in the inner (X and H) echo: 2.7%.
;gpzDistal4: Distal HMQC: second gradient in the outer (H) echo: 7.1%.

;use gradient files:
;gpnamDistal1: SMSQ10.100
;gpnamDistal2: SMSQ10.100
;gpnamDistal3: SMSQ10.100
;gpnamDistal4: SMSQ10.100
# endif