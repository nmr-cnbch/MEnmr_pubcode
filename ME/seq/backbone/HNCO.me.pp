prosol relations=<me>

# include <Avance.incl>
# include <Grad.incl>

# define DIMS 3

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

1 ze

; Relaxation and distal block Hz -> NzHz -> COzNz:
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

; Proximal block COzNz -> NzHz-> H and acquisition:
# include <ME/includes/end.incl>
	  F1PH(calph(phFree1,+90), caldel(T1, +in1))
exit

# include <ME/includes/phasecycles.incl>

phFree1 = 0 0 0 0 2 2 2 2

; Receiver phase:
phRec = PROXIMAL_PH31 + DISTAL_PH31 + phFree1

;gpzFree1: gradient after CO echo: 21%.

;gpnamFree1: SMSQ10.100

