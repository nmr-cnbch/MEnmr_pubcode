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
# define RECYCLING

# if defined(DS)
    "cnst3 = -1"  ; Scans done.
    "cnst4 = ds"
    "ds = 0"
# endif /*DS*/

# include <proximal_2D.incl>

1 ze

# include <preparation.incl>

# include <proximal_2D.incl>

# ifdef DS
;   Perform DS dummy scans for every d1 from list (apart from first):
    if "((cnst3)%(ns*td2 + cnst4)) < cnst4"
    {
      goto 3  ; Perform dummy scans.
    }
    goto 4  ; Standard scan.

; Only Sorensen version for now:
3 aq CPD_ON
    goto 2
# endif /*DS*/

4 0u
# ifdef EA_SPLIT_GO
  if "l0 %2 == 1"
    {
      go=2 ph31 CPD_ON_GO
    }
  else
    {
      go=2 ph31 ph30:r CPD_ON_GO
    }
# else
    go=2 ph31 CPD_ON_GO
# endif

  d11 mc #0 to 2
    F1QF(calclc(l1, 1))
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