prosol relations=<me>

# include <Avance.incl>
# include <Grad.incl>

# define NOESY
# define DIMS 4

; Variable definitions and calculations for the proximal and distal 2Ds:
# include <ME/includes/init.incl>

define delay mixTime
;d10: NOESY mixing time [40-400 ms]
"mixTime = d10 - pGRAD - dGRAD" ; Corrected for gradient.

1 ze

; Distal 2D:
# include <ME/includes/start.incl>

; NOESY mixing:
# ifdef MIX_LOCKED
  (
    refalign (mixTime):fH
    lalign (1m 4u BLKGRAD):fH
    ralign (2m UNBLKGRAD):fH
  )
# else
    mixTime
# endif

  GRAD(gpNOESY)

; Proximal 2D and acquisition:
# include <ME/includes/end.incl>
exit

# include <ME/includes/phasecycles.incl>

; Receiver phase:
phRec = PROXIMAL_PH31 + DISTAL_PH31

;gpzNOESY: gradient after NOESY: -7%.
;gpnamNOESY: SMSQ10.100