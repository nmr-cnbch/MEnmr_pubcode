prosol relations=<ME>

# include <Avance.incl>
# include <Grad.incl>

# include <ME/includes/init.incl>

"in1 = inf1"
"in2 = inf2"
"in3 = inf3"

define delay mixTime
;d10: NOESY mixing time [40-400 ms]
"mixTime = d10 - pGRAD - dGRAD" ; Corrected for gradient.


1 ze

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

# include <ME/includes/end.incl>

  d11 mc #0 to 2
    DISTAL_MC1
    DISTAL_MC2
    PROXIMAL_MC3
exit

# include <ME/includes/phasecycles.incl>

; Receiver phase:
ph31 = PROXIMAL_PH31 + DISTAL_PH31

;gpzNOESY: gradient after NOESY: -7%.
;gpnamNOESY: SMSQ10.100