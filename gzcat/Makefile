puff: puff.c puff.h
	diet -Os gcc -nostdlib -Os -fomit-frame-pointer -DSLOW -DTEST -o puff puff.c
	@sstrip puff
	@ls -l --color puff
	@if [ "`./puff  < r.gz | md5sum`" = "948659135181da512e6c37dd759d142d  -" ]; then echo "TEST OK"; fi

test: puff
	puff zeros.raw

clean:
	rm -f puff puff.o
