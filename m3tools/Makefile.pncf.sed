#
#.........................................................................
# Version "$Id: Makefile.pncf 231 2015-10-08 20:45:24Z coats $"
# EDSS/Models-3 M3TOOLS
#    (C) 1992-2002 MCNC and Carlie J. Coats, Jr.,
#    (C) 2003-2004 by Baron Advanced Meteorological Systems,
#    (C) 2005-2014 Carlie J. Coats, Jr., and
#    (C) 2014-2015 UNC Institute for the Environment
# Distributed under the GNU GENERAL PUBLIC LICENSE version 2
# See file "GPL.txt" for conditions of use.
#.........................................................................
#  Environment Variables:
#       BIN     machine/OS/compiler/mode type. Shows up as suffix
#               for "Makeinclude.${BIN}" to determine compilation
#               flags, and in ${OBJDIR} and $(INSTALL) to determine
#               binary directories
#       INSTALL installation-directory root, used for "make install":
#               "libioapi.a" and the tool executables will be installed
#               in $(INSTALL)/${BIN}
#            
#.........................................................................
#  Directories:
#       ${BASEDIR}  is the root directory for the I/O API library source,
#                   the M3Tools and M3Test source,the  HTML documentation,
#                   and the (machine/compiler/flag-specific) binary
#                   object/library/executable directories.
#       $(SRCDIR)   is the source directory for the M3TOOLS
#       $(IODIR)    is the source directory for the I/O API library
#       ${OBJDIR}   is the current machine/compiler/flag-specific
#                   build-directory
#       $(F90DIR)   is the current machine/compiler/flag-specific
#                   build-directory for F90-based programs (SGI & Sun)
#.........................................................................
#
#       ---------------     Definitions:   -------------------------

.SUFFIXES: .m4 .c .F .f .f90 .F90

BASEDIR = ${HOME}/ioapi-3.2
SRCDIR  = ${BASEDIR}/m3tools
IODIR   = ${BASEDIR}/ioapi
OBJDIR  = ${BASEDIR}/${BIN}
INSTDIR = BININSTALL

# Architecture dependent stuff
# Assumes FC is an f90

MAKEINCLUDE

FFLAGS =  -I$(IODIR) -DIOAPICPL $(DEFINEFLAGS) $(FOPTFLAGS) $(ARCHFLAGS)

LDFLAGS = -I$(IODIR) -DIOAPICPL $(DEFINEFLAGS) $(ARCHFLAGS)

#  Incompatibility between netCDF versions before / after v4.1.1:
#  For netCDF v4 and later, you may also need the extra libraries
#  given by netCDF commands
#
#          nc-config --libs
#          nf-config --libs
#
#LIBS = -L${OBJDIR} -lioapi -lnetcdf -lnetcdff $(PVMLIBS) $(OMPLIBS) $(ARCHLIB) $(ARCHLIBS)
#LIBS = -L${OBJDIR} -lioapi `nf-config --libs` `nc-config --libs`  $(PVMLIBS) $(OMPLIBS) $(ARCHLIB) $(ARCHLIBS)
#
# PnetCDF builds also require  -lpnetcdf

LIBS = -L${OBJDIR} -lioapi $(NCFLIBS) $(OMPLIBS) $(ARCHLIB) $(ARCHLIBS)

VPATH = ${OBJDIR}



fSRC = \
agmask.f        agmax.f         airnow2m3.f     airs2m3.f       cdiffstep.f     \
diffstep.f      kfxtract.f      m3agmask.f      m3agmax.f       m3combo.f       \
m3cple.f        m3diff.f        m3edhdr.f       m3hdr.f         m3interp.f      \
m3merge.f       m3pair.f        m3stat.f        m3xtract.f      mtxblend.f      \
mtxbuild.f      mtxcple.f       presterp.f      projtool.f      selmrg2d.f      \
statb.f         statbdry.f      statc.f         statcust.f      statg.f         \
statgrid.f      stati.f         statiddat.f     statm.f         stats.f         \
statspars.f     statstep.f

f90SRC = \
bcwndw.f90      camxtom3.f90    datshift.f90    factor.f90      fakestep.f90    \
fills.f90       greg2jul.f90    gridprobe.f90   gregdate.f90    insertgrid.f90  \
jul2greg.f90    juldate.f90     juldiff.f90     julshift.f90    latlon.f90      \
m3fake.f90      m3pair.f90      m3probe.f90     m3totxt.f90     m3tproc.f900    \
m3tshift.f90    m3wndw.f90      mtxcalc.f90     pairstep.f90    presz.f90       \
timeshift.f90   vertot.f90      vertimeproc.f90 vertintegral.f90                \
wrfgriddesc.f90 wrftom3.f90

OBJ = $(fSRC:.f=.o) $(FSRC:.F=.o) $(f90SRC:.f=.o)


EXE = \
airs2m3         bcwndw          camxtom3        datshift        dayagg          \
factor          greg2jul        gregdate        gridprobe       insertgrid      \
jul2greg        juldate         juldiff         julshift        kfxtract        \
latlon          m3agmax         m3agmask        m3cple          m3combo         \
m3diff          m3edhdr         m3fake          m3hdr           m3interp        \
m3merge         m3pair          m3probe         m3stat          m3totxt         \
m3tproc         m3tshift        m3wndw          m3xtract        mtxblend        \
mtxbuild        mtxcalc         mtxcple         presterp        presz           \
projtool        selmrg2d        timeshift       vertot          vertimeproc     \
vertintegral    wrfgriddesc     wrftom3



#      ----------------------   TOP-LEVEL TARGETS:   ------------------

all: $(EXE)

clean:
	cd ${OBJDIR}; rm $(EXE) $(OBJ)

install: $(INSTDIR)
	echo "Installing M3TOOLS in ${INSTDIR}"
	cd ${OBJDIR}; cp $(EXE) $(INSTDIR)

rmexe:
	cd ${OBJDIR}; rm $(EXE)

relink:
	make BIN=${BIN} -i rmexe ; make all

bins:
	make BIN=Linux2_x86_64sun
	make BIN=Linux2_x86_64g95
	make BIN=Linux2_x86_64gfort
	make BIN=Linux2_x86_64ifort
	make BIN=Linux2_x86_64sundbg
	make BIN=Linux2_x86_64ifortdbg

binclean:
	make -i BIN=Linux2_x86_64sun     clean
	make -i BIN=Linux2_x86_64g95     clean
	make -i BIN=Linux2_x86_64gfort   clean
	make -i BIN=Linux2_x86_64ifort   clean
	make -i BIN=Linux2_x86_64sundbg  clean
	make -i BIN=Linux2_x86_64ifortdbg  clean


binrelink:
	make BIN=Linux2_x86_64sun      relink
	make BIN=Linux2_x86_64g95      relink
	make BIN=Linux2_x86_64gfort    relink
	make BIN=Linux2_x86_64ifort    relink
	make BIN=Linux2_x86_64sundbg   relink
	make BIN=Linux2_x86_64ifortdbg relink

flags:
	echo "BIN=${BIN}"
	echo "FFLAGS=$(FFLAGS)"
	echo "LDFLAGS=$(LDFLAGS)"
	echo "LIBS=$(LIBS)"
	echo "ARCHFLAGS=$(ARCHFLAGS)"
	echo "ARCHLIB=$(ARCHLIB)"
	echo "ARCHLIBS=$(ARCHLIBS)"
	echo "OMPFLAGS=$(OMPFLAGS)"
	echo "OMPLIBS=$(OMPLIBS)"
	echo "FOPTFLAGS=$(FOPTFLAGS)"
	echo "COPTFLAGS=$(COPTFLAGS)"
	echo "PARFLAGS=$(PARFLAGS)"
	echo "PVM_ROOT=$(PVM_ROOT)"
	echo "PVMLIBS=$(PVMLIBS)"


#      -----------------------   RULES:   -------------------------

%.o : %.mod        #  Disable "gmake"s obnoxious implicit Modula-2 rule !!

.F.o:
	cd ${OBJDIR}; $(FC) $(FPPFLAGS) $(FFLAGS) -c $(SRCDIR)/$<

.f.o:
	cd ${OBJDIR}; $(FC) $(FFLAGS) -c $(SRCDIR)/$<

.f90.o:
	cd ${OBJDIR}; $(FC) $(FFLAGS) -c $(SRCDIR)/$<

#  ---------------------------  Dependencies:  --------------------


gridprobe.o     : modgctp.mod
insertgrid.o    : modgctp.mod
latlon.o        : modgctp.mod
m3cple.o        : modgctp.mod
m3interp.o      : modgctp.mod
mtxbuild.o      : modatts3.mod
mtxcalc.o       : modatts3.mod modgctp.mod
mtxcple.o       : modatts3.mod
projtool.o      : modgctp.mod
wrfgriddesc.o   : modwrfio.mod
wrftom3.o       : modwrfio.mod


#  ---------------------------  $(EXE) Program builds:  -----------------


airs2m3:  airs2m3.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

bcwndw: bcwndw.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

camxtom3:  camxtom3.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

datshift:  datshift.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

dayagg: dayagg.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

factor:  factor.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

greg2jul: greg2jul.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

gregdate: gregdate.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

gridprobe: gridprobe.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

insertgrid:  insertgrid.o
	cd ${OBJDIR}; ${FC} ${LFLAGS} $^ ${LIBS} -o $@

jul2greg:  jul2greg.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

juldate:  juldate.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

juldiff:  juldiff.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

julshift:  julshift.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

kfxtract: kfxtract.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

latlon:  latlon.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3agmask:  m3agmask.o agmask.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3agmax:  m3agmax.o agmax.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3combo: m3combo.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3cple: m3cple.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3diff:  m3diff.o diffstep.o cdiffstep.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3edhdr:  m3edhdr.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3fake: m3fake.o fakestep.o fills.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3hdr:  m3hdr.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3interp: m3interp.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3merge: m3merge.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3pair:  m3pair.o pairstep.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3probe: m3probe.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3stat: m3stat.o statbdry.o statcust.o statgrid.o statiddat.o statspars.o \
        statb.o  statc.o statg.o stati.o statm.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3totxt:  m3totxt.o
	cd ${OBJDIR}; ${FC} ${LFLAGS} $^ ${LIBS} -o $@

m3tproc:  m3tproc.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3tshift:  m3tshift.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3wndw: m3wndw.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m3xtract:  m3xtract.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

m4cple: m4cple.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

mtxblend: mtxblend.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

mtxbuild: mtxbuild.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

mtxcalc: mtxcalc.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

mtxcple: mtxcple.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

presterp: presterp.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

presz:  presz.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

projtool: projtool.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

selmrg2d:  selmrg2d.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

sfcmet:  sfcmet.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

timeshift: timeshift.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

vertimeproc:  vertimeproc.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

vertintegral:  vertintegral.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

vertot:  vertot.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

wrfgriddesc:  wrfgriddesc.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@

wrftom3:  wrftom3.o
	cd ${OBJDIR}; $(FC) ${LFLAGS} $^ ${LIBS} -o $@
