; © 2017 Michał Jakub Górka <michal.jakub.gorka@fuw.edu.pl> All rights reserved.
; Do not use without explicit permission.

prosol relations=<triple>

# include <Avance.incl>
# include <Grad.incl>

# include <2D_config.incl>
# include <rapid_pulses.incl>

  define list<delay> vd_list=<$VDLIST>
  "l1 = 0"	; Counter for keeping track of vdlist.
  "in1 = inf2"

  aqseq 312
  define delay dR1
  "dR1 = 0"

# include <proximal_2D.incl>

1 ze
  10u st0 ; Set buffer 0 active.

# include <preparation.incl>

"dR1 = vd_list - p16 - d16"
# ifdef PRESAT
    "dR1 -= 4u"
# endif

; Inversion recovery:
  H_refocussing(ph0)
  p16:gp21
  d16
  dR1 SAT_ON
  4u SAT_OFF

# include <proximal_2D.incl>

# ifdef EA_SPLIT_GO
  if "l0 %2 == 1"
    {
      goscnp ph31 ph30
    }
  else
    {
      goscnp ph31 ph30:r
    }
# else
  goscnp ph31 ph30
# endif

  4u st vdlist.incl SET_ON do:f2 do:f3
  lo to pointStart times nbl

  4u ippall
  lo to scanStart times ns

  d11 mc #0 to 2
    F1QF()
    MC2D2
exit

ph0 = 0
ph1 = 1
ph2 = 2
ph3 = 3

# define IMPORT_PHASES
# include <proximal_2D.incl>

; Receiver phase:
ph31 = PROXIMAL_PH31