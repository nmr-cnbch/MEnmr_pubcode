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
# define DISTAL_Y_CA
# define DISTAL_A_CO
# define PROXIMAL_NH
# define PROXIMAL_Y_CA
# define PROXIMAL_A_CO

; Variable definitions for the distal (H->N) and proximal (X->N) blocks:
# include <ME/includes/init.incl>

define delay dCACO
define delay T2a
define delay T2b
define delay T2c
define delay timeCACO
"timeCACO = d32"

1 ze

; Relaxation and distal block Hz -> NzHz -> CAzNz:
# include <ME/includes/start.incl>

  "T2a = timeCACO/2 - p22"	; Compensate for length of N inversion pulse.
  "if (T2max <= timeCACO) {T2b = 0;} else {T2b = T2*(1 - timeCACO/T2max)/2;}"
  "if (T2max <= timeCACO) {T2c = (timeCACO - T2)/2;} else {T2c = timeCACO*(1 - T2/T2max)/2;}"

  DECOUPLE_HD_ON

; CAzNz -> CAzNzCOz:
  (CA_excitation(phFree1)):fCA
  timeCACO*0.5
  (CO_CA_inversion(ph0)):fCO  ; BSP compensation.
  (CA_refocussing(ph0)):fC
  timeCACO*0.5
  (CO_CA_inversion(ph0)):fCO  ; BSP compensation.
  (CA_flipback(ph0)):fCA

  DECOUPLE_HD_OFF
  4u fq=cnstCO:fCO
  GRAD(gpFree1)

; COzNzCAz, CO evolution (T1):

  (CO_excitation(phFree1)):fCO
  T1*0.5
  (center (CA_CO_inversion(ph0)):fCA (N_inversion(ph0)):fN)
  T1*0.5
  (CO_refocussing(ph0)):fCO
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CA_flipback(ph0)):fCO

  4u fq=cnstCA:fCA
  GRAD(gpFree2)

  DECOUPLE_HD_ON

; CAzNzCOz -> CAzNz with CO evolution (T2):
  (CA_excitation(phFree2)):fCA
  (lalign (T2*0.5 N_inversion(ph0)):fN (T2a CO_CA_inversion(ph0)):fCO)
  T2b
  (CA_refocussing(ph0)):fCA
  T2c
  (CO_CA_inversion(ph0)):fCO  ; BSP compensation.
  (CA_flipback(ph0)):fCA

  DECOUPLE_HD_OFF
  GRAD(gpFree3)

; Proximal block CAzNz -> NzHz-> H and acquisition:
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

