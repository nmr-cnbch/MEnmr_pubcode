# if !defined(INIT_DONE)

define delay TProximal
"TProximal = 0"

  define delay deltaX  ; Correction for gradient and pulses in TProximal.
  define delay dHX1
  define delay dHX2

  "deltaX = pHX_refocussing"
  "dHX1 = timeHX - pGRAD - dGRAD - eHX_excitation - deltaX - pX_refocussing"
  "dHX2 = timeHX - pGRAD - dGRAD - ME_de"

  "acqt0 = 0"
  baseopt_echo

; *****************************************************************************
# elif defined(INIT_DONE) && !defined(ME_PULSES)

; *****************************************************************************
# elif defined(ME_PULSES) && !defined(IMPORT_PHASES)

; Hz -> HzCz:
  H2O_FLIPBACK(phProximal1)
  (HX_excitation(phProximal1)):fH
  PROXIMAL_GRAD_LONG(gpProximal1)
  dHX1

; HzCz real-time evolution of C:
  (X_excitation(phProximal3)):fX
  deltaX ; Compensate for H pulse.
  RDGRAD_COMP
  PROXIMAL_GRAD_SHORT(gpProximal2)
  (X_refocussing(phProximal4)):fX

  RDGRAD_ON
  TProximal*0.5
  RDGRAD_OFF
  (HX_WATERGATE(phProximal2)):fH
  RDGRAD_ON_NEG
  TProximal*0.5
  RDGRAD_OFF

  PROXIMAL_GRAD_SHORT(gpProximal2)
  (X_flipback(phProximal5)):fX

; HzCz -> Ht:
  PROXIMAL_GRAD_LONG(gpProximal1)
  dHX2 CPD_POW BLKGRAD

# define PROXIMAL_MC1 F1PH(calph(phProximal5, -90), caldel(TProximal, +in1))
# define PROXIMAL_MC2 F2PH(calph(phProximal5, -90), caldel(TProximal, +in2))
# define PROXIMAL_MC3 F3PH(calph(phProximal5, -90), caldel(TProximal, +in3))
# define PROXIMAL_MC4 F4PH(calph(phProximal5, -90), caldel(TProximal, +in4))

/*****************************************************************************/
# elif defined(IMPORT_PHASES)
phProximal1 = 0  ; H excitation.
phProximal2 = 0  ; H refocussing.

phProximal4 = 0  ; X refocussing.

# if !defined(DISTAL_PHASES_2)
    phProximal3 = 0 2  ; X excitation.
#   define PROXIMAL_PHASES_2
# elif !defined(DISTAL_PHASES_4)
    phProximal3 = 0 0 2 2  ; X excitation.
#   define PROXIMAL_PHASES_4
# else
    phProximal3 = 0 0 0 0 2 2 2 2 ; X excitation.
#   define PROXIMAL_PHASES_8
# endif

# if !defined(DISTAL_PHASES_4) && !defined(PROXIMAL_PHASES_4)
    phProximal5 = 0 0 2 2  ; X flipback.
# elif !defined(DISTAL_PHASES_8) && ! defined(PROXIMAL_PHASES_8)
    phProximal5 = 0 0 0 0 2 2 2 2 ; X flipback.
# elif !defined(DISTAL_PHASES_16) && ! defined(PROXIMAL_PHASES_16)
    phProximal5 = 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2 ; X flipback.
# else
    phProximal5 = 0 0  ; X flipback.
# endif

# define PROXIMAL_PH31 phProximal3 + phProximal5

;FnMODE: States-TPPI
;td1: number of experiments

;for z-only gradients:
;gpzProximal1: Proximal HMQC: gradient in the outer echo (H only): 9%.
;gpzProximal2: Proximal HMQC: gradient in the inner (X and H) echo: 20%.
;gpzProximal3: Proximal HMQC: gradient in the inner (X and H) echo: (-?)31%.

;use gradient files:
;gpnamProximal1: SMSQ10.100
;gpnamProximal2: SMSQ10.100
;gpnamProximal3: SMSQ10.100
# endif