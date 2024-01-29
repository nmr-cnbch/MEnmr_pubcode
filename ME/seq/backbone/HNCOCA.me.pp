prosol relations=<ME>

# include <Avance.incl>
# include <Grad.incl>

"in1 = inf1"
"in2 = inf2"
"in3 = inf3"
define delay T1
"T1 = 0"
define delay T2
"T2 = 0"
define delay T2max
"T2max = max(in2*(td2/2 - 1), 0)"
define delay TPmax
"TPmax = max(in3*(td3/2 - 1), 0)"

# define XH
# define HX
# define DISTAL_N
# define DISTAL_Y_CO
# define DISTAL_A_CA
# define PROXIMAL_NH
# define PROXIMAL_Y_CO
# define PROXIMAL_A_CA

# include <ME/includes/init.incl>

define delay dCOCA
define delay T2a
define delay T2b
define delay T2c
define delay timeCOCA
"timeCOCA = d33"

1 ze

# include <ME/includes/start.incl>

  "T2a = timeCOCA/2 - p22"	; Compensate for length of N inversion pulse.
  "T2b = T2*(1 - timeCOCA/T2max)/2"
  "if (T2max <= timeCOCA) {T2b = 0;}"
  "T2c = timeCOCA*(1 - T2/T2max)/2"
  "if (T2max <= timeCOCA) {T2c = (timeCOCA - T2)/2;}"

; 2COzNz -> 4COzNzCAz:
  (CO_excitation(phFree1)):fCO
  timeCOCA*0.5
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_refocussing(ph0)):fCO
  timeCOCA*0.5
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_flipback(ph0)):fCO

  4u fq=cnst22:fCA
  GRAD(gpFree1)

; 2CAzCOz, CA evolution (T1):

  (CA_excitation(phFree1)):fCA
  T1*0.5
  (center (CO_CA_inversion(ph0)):fCO (N_inversion(ph0)):fN)
  T1*0.5
  (CA_refocussing(ph0)):fCA
  (CO_CA_inversion(ph0)):fCO  ; BSP compensation.
  (CA_flipback(ph0)):fCA

  4u fq=cnst21:fCO
  GRAD(gpFree2)

; 2COzCAz -> 2COzNz with CO evolution (T2):
  (CO_excitation(phFree2)):fCO
  (lalign (T2*0.5 N_inversion(ph0)):fN (T2a CA_CO_inversion(ph0)):fCA)
  T2b
  (CO_refocussing(ph0)):fCO
  T2c
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_flipback(ph0)):fCO

  GRAD(gpFree3)

# include <ME/includes/end.incl>
  d11 mc #0 to 2
	  F1PH(calph(phFree1,+90), caldel(T1, +in1))
    F2PH(calph(phFree2,+90), caldel(T2, +in2))
    PROXIMAL_MC3
exit

# include <ME/includes/phasecycles.incl>

phFree1 = 0 0 0 0 2 2 2 2
phFree2 = 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2

; Receiver phase:
ph31 = PROXIMAL_PH31 + DISTAL_PH31 + phFree1

;gpzFree1: gradient after CO echo: 21%.
;gpzFree1: gradient after CO echo: 13%.
;gpzFree1: gradient after CO echo: 7%.

;gpnamFree1: SMSQ10.100
;gpnamFree2: SMSQ10.100
;gpnamFree3: SMSQ10.100

