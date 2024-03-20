prosol relations=<me>

# include <Avance.incl>
# include <Grad.incl>

# include <ME/config.incl>

"in1 = 0"

# if defined(H_SHAPED)
; Selective excitation pulse for H -> N:
;sp54:wvm: e400b(cnst51 ppm; TR)
"spoff54 = bf1*(cnst52/1000000) - o1"
"spoal54 = 1"
"cnst54 = 0.57" ; Evolution time quotient in FB-E configuration.

;   Selective flipback pulse for H -> N:
;sp55:wvm: e400b(cnst51 ppm)
"spoff55 = bf1*(cnst52/1000000) - o1"
"spoal55 = 1"
"cnst55 = 0.57" ; Evolution time quotient in FB-E configuration.

;   Selective refocussing pulse for H:
;sp56:wvm: Q3(cnst50 ppm)
"spoff56 = bf1*(cnst52/1000000) - o1"
"spoal56 = 0.5"
"cnst56 = 0"

;   Second pair of pulses for use in backtransfer:
; Selective excitation pulse for H -> N:
;sp57:wvm: e400b(cnst51 ppm; TR)
"spoff57= bf1*(cnst52/1000000) - o1"
"spoal57 = 0"
"cnst57 = 0.57"

;   Selective flipback pulse for H -> N:
;sp58:wvm: e400b(cnst51 ppm)refocussing
"spoff58 = bf1*(cnst52/1000000) - o1"
"spoal58 = 1"
"cnst58 = 0.57"



; Selective excitation pulse for H -> C:
;sp44:wvm: e400b(cnst41 ppm; TR)
"spoff44 = bf1*(cnst42/1000000) - o1"
"spoal44 = 1"
"cnst44 = 0.57" ; Evolution time quotient in FB-E configuration.

;   Selective flipback pulse for H -> C:
;sp45:wvm: e400b(cnst41 ppm)
"spoff45 = bf1*(cnst42/1000000) - o1"
"spoal45 = 1"
"cnst45 = 0.57" ; Evolution time quotient in FB-E configuration.

;   Selective refocussing pulse for H:
;sp46:wvm: Q3(cnst40 ppm)
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
"cnst48 = 0.57"

#   if 0
    (p54:sp54 ph0) (p55:sp55 ph0) (p56:sp56 ph0) (p57:sp57 ph0) (p58:sp58 ph0)
    (p44:sp44) (p45:sp45) (p46:sp46) (p47:sp47) (p48:sp48)
#   endif

# endif

# include <ME/modules/proximal_2D.incl>

1 ze

# include <ME/includes/preparation.incl>

# include <ME/modules/proximal_2D.incl>

# include <ME/includes/acq.incl>

  d11 mc #0 to 2
exit

ph0 = 0
ph1 = 1
ph2 = 2
ph3 = 3
ph30 = 0

# define IMPORT_PHASES
# include <ME/modules/proximal_2D.incl>

; Receiver phase:
phRec = PROXIMAL_PH31