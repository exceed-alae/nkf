CC = cc
CFLAGS = -O
# CFLAGS = -O3
SHAR = shar 
# SHAR = shar -T
PERL = perl
RM = rm -rf
VERSION = 201

nkf : nkf.c config.h utf8tbl.o
	$(CC) $(CFLAGS) -o nkf nkf.c utf8tbl.o

utf8tbl.o : utf8tbl.c config.h
	$(CC) $(CFLAGS) -c utf8tbl.c

clean:
	-$(RM) nkf.o nkf nkf.in nkf.out nkf$(VERSION) *~ *.bad utf8tbl.o
	cd NKF.mod; make clean
test:	nkf
	$(PERL) test.pl

perl:
	( cd NKF.mod ; \
	$(PERL) Makefile.PL  ; \
	make ; \
	make test )

shar:
	-mkdir nkf$(VERSION)
	-mkdir nkf$(VERSION)/NKF.mod
	for file in  `cat MANIFEST`;  \
	do  \
	    nkf -j -m0 $$file > nkf$(VERSION)/$$file ; \
	done 
	echo "#!/bin/sh" >nkf$(VERSION).shar
	echo "mkdir nkf$(VERSION)" >>nkf$(VERSION).shar
	echo "mkdir nkf$(VERSION)/NKF.mod" >>nkf$(VERSION).shar
	echo "cd nkf$(VERSION)" >>nkf$(VERSION).shar
	( cd nkf$(VERSION) ; $(SHAR)  `cat ../MANIFEST` ) >> nkf$(VERSION).shar
	-$(RM) nkf$(VERSION)
