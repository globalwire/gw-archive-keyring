#!/usr/bin/make -f

GPG_OPTIONS := --no-options --no-default-keyring --no-auto-check-trustdb --trustdb-name ./trustdb.gpg

build: verify-indices rings/gw-archive-keyring.gpg verify-results gw.list

verify-indices: rings/team.gpg
	gpg ${GPG_OPTIONS} \
		--keyring rings/team.gpg \
		--verify keys/index.asc \
		keys/index

verify-results: rings/team.gpg rings/gw-archive-keyring.gpg
	gpg ${GPG_OPTIONS} \
		--keyring rings/team.gpg \
		--verify rings/gw-archive-keyring.gpg.asc \
		rings/gw-archive-keyring.gpg

rings/gw-archive-keyring.gpg: keys/index
	jetring-build -I $@ keys
	gpg ${GPG_OPTIONS} --no-keyring --import-options import-export --import < $@ > $@.tmp
	mv -f $@.tmp $@

rings/team.gpg: team/index
	jetring-build -I $@ team
	gpg ${GPG_OPTIONS} --no-keyring --import-options import-export --import < $@ > $@.tmp
	mv -f $@.tmp $@

gw.list: gw.list.in
	sed	-e "s/@OS@/$$(lsb_release -is | tr A-Z a-z)/" \
		-e "s/@CN@/$$(lsb_release -cs)/" \
		$< > $@.tmp
	mv -f $@.tmp $@

clean:
	rm -f	rings/gw-archive-keyring.gpg \
		rings/gw-archive-keyring.gpg~ \
		rings/gw-archive-keyring.gpg.lastchangeset \
		rings/gw-archive-keyring.gpg.tmp \
		rings/team.gpg \
		rings/team.gpg~ \
		rings/team.gpg.lastchangeset \
		rings/team.gpg.tmp \
		rings/*.cache \
		trustdb.gpg \
		gw.list \
		gw.list.tmp

install: build
	install -d $(DESTDIR)/usr/share/keyrings/
	cp rings/gw-archive-keyring.gpg $(DESTDIR)/usr/share/keyrings/

deb:
	dpkg-buildpackage -rfakeroot

.PHONY: build clean deb install verify-indices verify-results
