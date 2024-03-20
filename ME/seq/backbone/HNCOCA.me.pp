prosol relations=<me>

# include <Avance.incl>
# include <Grad.incl>

# define DIMS 4

define delay T2max
"T2max = max(in2*(td2/2 - 1), 0)"

/*Select options for distal and proximal blocks:*/
# define XH
# define HX
# define DISTAL_N
# define DISTAL_Y_CO
# define DISTAL_A_CA
# define PROXIMAL_NH
# define PROXIMAL_Y_CO
# define PROXIMAL_A_CA

; Variable definitions for the distal (H->N) and proximal (N->H) blocks:
# include <ME/includes/init.incl>

define delay dCOCA
define delay T2a
define delay T2b
define delay T2c
define delay timeCOCA
"timeCOCA = d33"

1 ze

; Relaxation and distal block Hz -> NzHz -> COzNz:
# include <ME/includes/start.incl>

  "T2a = timeCOCA/2 - p22"	; Compensate for length of N inversion pulse.
  "if (T2max <= timeCOCA) {T2b = 0;} else {T2b = T2*(1 - timeCOCA/T2max)/2;}"
  "if (T2max <= timeCOCA) {T2c = (timeCOCA - T2)/2;} else {T2c = timeCOCA*(1 - T2/T2max)/2;}"

; COzNz -> COzNzCAz:
  (CO_excitation(phFree1)):fCO
  timeCOCA*0.5
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_refocussing(ph0)):fCO
  timeCOCA*0.5
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_flipback(ph0)):fCO

  4u fq=cnstCA:fCA
  GRAD(gpFree1)

; CAzCOzNz, CA evolution (T1):

  (CA_excitation(phFree1)):fCA
  T1*0.5
  (center (CO_CA_inversion(ph0)):fCO (N_inversion(ph0)):fN)
  T1*0.5
  (CA_refocussing(ph0)):fCA
  (CO_CA_inversion(ph0)):fCO  ; BSP compensation.
  (CA_flipback(ph0)):fCA

  4u fq=cnstCO:fCO
  GRAD(gpFree2)

; COzCAzNz -> COzNz with CO evolution (T2):
  (CO_excitation(phFree2)):fCO
  (lalign (T2*0.5 N_inversion(ph0)):fN (T2a CA_CO_inversion(ph0)):fCA)
  T2b
  (CO_refocussing(ph0)):fCO
  T2c
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_flipback(ph0)):fCO

  GRAD(gpFree3)

; Proximal block COzNz -> NzHz-> H and acquisition:
# include <ME/includes/end.incl>
	  F1PH(calph(phFree1,+90), caldel(T1, +in1))
    F2PH(calph(phFree2,+90), caldel(T2, +in2))
exit

# include <ME/includes/phasecycles.incl>

phFree1 = 0 0 0 0 2 2 2 2
phFree2 = 0 0 0 0 0 0 0 0 2 2 2 2 2 2 2 2

; Receiver phase:
phRec = PROXIMAL_PH31 + DISTAL_PH31 + phFree1

;gpzFree1: gradient after CO echo: 21%.
;gpzFree1: gradient after CO echo: 13%.
;gpzFree1: gradient after CO echo: 7%.

;gpnamFree1: SMSQ10.100
;gpnamFree2: SMSQ10.100
;gpnamFree3: SMSQ10.100

