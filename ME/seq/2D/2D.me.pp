prosol relations=<me>

# include <Avance.incl>
# include <Grad.incl>

# define DIMS 2

; Variable definitions for the 2D block:
# include <ME/includes/init.incl>

1 ze

; Relaxation delay:
# include <ME/includes/start.incl>

; 2D (proximal) block:
# include <ME/includes/end.incl>
exit

# include <ME/includes/phasecycles.incl>

; Receiver phase:
phRec = PROXIMAL_PH31