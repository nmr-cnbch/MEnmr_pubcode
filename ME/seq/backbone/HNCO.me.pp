prosol relations=<ME>

# include <Avance.incl>
# include <Grad.incl>

"in1 = inf1"
"in2 = inf2"
define delay T1
"T1 = 0"
define delay TPmax
"TPmax = max(in2*(td2/2 - 1), 0)"

# define XH
# define HX
# define DISTAL_N
# define DISTAL_Y_CO
# define DISTAL_A_CA
# define PROXIMAL_NH
# define PROXIMAL_Y_CO
# define PROXIMAL_A_CA

# include <ME/includes/init.incl>

1 ze

# include <ME/includes/start.incl>

; 2COzNz CO evolution (T1):
  (CO_excitation(phFree1)):fCO
  T1*0.5
  (center (CA_CO_inversion(ph0)):fCA (N_inversion(ph0)):fN)
  T1*0.5
  (CO_refocussing(ph0)):fCO
  (CA_CO_inversion(ph0)):fCA  ; BSP compensation.
  (CO_flipback(ph0)):fCO

GRAD(gpFree1)

# include <ME/includes/end.incl>
  d11 mc #0 to 2
	  F1PH(calph(phFree1,+90), caldel(T1, +in1))
    PROXIMAL_MC2
exit

# include <ME/includes/phasecycles.incl>

phFree1 = 0 0 0 0 2 2 2 2

; Receiver phase:
ph31 = PROXIMAL_PH31 + DISTAL_PH31 + phFree1

;gpzFree1: gradient after CO echo: 21%.

;gpnamFree1: SMSQ10.100

