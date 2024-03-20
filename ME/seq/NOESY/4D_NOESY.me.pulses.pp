prosol relations=<ME>

# include <Avance.incl>
# include <Grad.incl>

# define NOESY
# define DIMS 4

# if defined(H_SHAPED)
; Selective excitation pulse for H -> N:
;sp54:wvm: e400b(cnst51 ppm; TR)
"spoff54 = bf1*(cnst52/1000000) - o1"
"spoal54 = 0"
"cnst54 = 0.57" ; Evolution time quotient in FB-E configuration.

;   Selective flipback pulse for H -> N:
;sp55:wvm: e400b(cnst51 ppm)
"spoff55 = bf1*(cnst52/1000000) - o1"
"spoal55 = 1"
"cnst55 = 0" ; Evolution time quotient in FB-E configuration.

;   Selective refocussing pulse for H:
;sp56:wvm: reburp(cnst50 ppm)
"spoff56 = bf1*(cnst52/1000000) - o1"
"spoal56 = 0.5"
"cnst56 = 1"

;   Second pair of pulses for use in backtransfer:
; Selective excitation pulse for H -> N:
;sp57:wvm: e400b(cnst51 ppm; TR)
"spoff57= bf1*(cnst52/1000000) - o1"
"spoal57 = 0"
"cnst57 = 0.57"

;   Selective flipback pulse for H -> N:
;sp58:wvm: e400b(cnst51 ppm)
"spoff58 = bf1*(cnst52/1000000) - o1"
"spoal58 = 1"
"cnst58 = 0"



; Selective excitation pulse for H -> C:
;sp44:wvm: e400b(cnst41 ppm; TR)
"spoff44 = bf1*(cnst42/1000000) - o1"
"spoal44 = 0"
"cnst44 = 0.57" ; Evolution time quotient in FB-E configuration.

;   Selective flipback pulse for H -> C:
;sp45:wvm: e400b(cnst41 ppm)
"spoff45 = bf1*(cnst42/1000000) - o1"
"spoal45 = 1"
"cnst45 = 0" ; Evolution time quotient in FB-E configuration.

;   Selective refocussing pulse for H:
;sp46:wvm: reburp(cnst40 ppm)
"spoff46 = bf1*(cnst42/1000000) - o1"
"spoal46 = 0.5"
"cnst46 = 0"

;   Second pair of pulses for use in backtransfer:
; Selective excitation pulse for H -> C:
;sp47:wvm: e400b(cnst41 ppm; TR)
"spoff47= bf1*(cnst42/1000000) - o1"
"spoal47 = 0"
"cnst47 = 0.57"

;   Selective flipback pulse for H -> C:
;sp48:wvm: e400b(cnst41 ppm)
"spoff48 = bf1*(cnst42/1000000) - o1"
"spoal48 = 1"
"cnst48 = 0"

#   if 0
    (p54:sp54 ph0) (p55:sp55 ph0) (p56:sp56 ph0) (p57:sp57 ph0) (p58:sp58 ph0)
    (p44:sp44) (p45:sp45) (p46:sp46) (p47:sp47) (p48:sp48)
#   endif

# endif

# include <ME/includes/init.incl>

"d0 += 0s*(cnst40 + cnst41 + cnst42)"

define delay mixTime
;d10: NOESY mixing time [40-400 ms]
"mixTime = d10 - pGRAD - dGRAD" ; Corrected for gradient.

1 ze

# include <ME/includes/start.incl>

; NOESY mixing:
# ifdef MIX_LOCKED
  (
    refalign (mixTime):fH
    lalign (50m 4u BLKGRAD):fH
    ralign (2m UNBLKGRAD):fH
  )
# else
    mixTime
# endif

  GRAD(gpNOESY)

# include <ME/includes/end.incl>
exit

# include <ME/includes/phasecycles.incl>

; Receiver phase:
phRec = PROXIMAL_PH31 + DISTAL_PH31

;gpzNOESY: gradient after NOESY: -7%.
;gpnamNOESY: SMSQ10.100