prosol relations=<me>

# include <Avance.incl>
# include <Grad.incl>

# define DIMS 3

/*Select options for distal and proximal blocks:*/
# define XH
# define HX
# define DISTAL_N
# define DISTAL_Y_CA
# define DISTAL_A_CO
# define PROXIMAL_NH
# define PROXIMAL_Y_CA
# define PROXIMAL_A_CO

; Variable definitions for the distal (H->N) and proximal (N->H) blocks:
# include <ME/includes/init.incl>

1 ze

; Relaxation and distal block Hz -> NzHz -> CAzNz:
# include <ME/includes/start.incl>

; 2CAzNz CA evolution (T1):
  (CA_excitation(phFree1)):fCA
  T1*0.5
  (center (CO_CA_inversion(ph0)):fCO (N_inversion(ph0)):fN)
  T1*0.5
  (CA_refocussing(ph0)):fCA
  (CO_CA_inversion(ph0)):fCO  ; BSP compensation.
  (CA_flipback(ph0)):fCA

GRAD(gpFree1)

; Proximal block CAzNz -> NzHz-> H and acquisition:
# include <ME/includes/end.incl>
	  F1PH(calph(phFree1,+90), caldel(T1, +in1))
exit

# include <ME/includes/phasecycles.incl>

phFree1 = 0 0 0 0 2 2 2 2

; Receiver phase:
phRec = PROXIMAL_PH31 + DISTAL_PH31 + phFree1

;gpzFree1: gradient after CA echo: 21%.

;gpnamFree1: SMSQ10.100

