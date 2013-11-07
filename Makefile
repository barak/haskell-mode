VERSION = $(shell git describe --tags --match 'v[0-9]*' --abbrev=0 | sed 's/_/\./g;s/^v//')
GIT_VERSION = $(shell git describe --tags --match 'v[0-9]*' --dirty | sed 's/_/\./g;s/^v//')

EMACS = emacs
EFLAGS =
BATCH = $(EMACS) $(EFLAGS) --batch -Q -L .

ELFILES = \
	haskell-c.el \
	haskell-cabal.el \
	haskell-decl-scan.el \
	haskell-doc.el \
	haskell-font-lock.el \
	haskell-ghci.el \
	haskell-hugs.el \
	haskell-indent.el \
	haskell-indentation.el \
	haskell-checkers.el \
	haskell-mode.el \
	haskell-simple-indent.el \
	haskell-sort-imports.el \
	haskell-align-imports.el \
	haskell-move-nested.el \
	haskell-navigate-imports.el \
	haskell-interactive-mode.el \
	haskell-package.el \
	haskell-process.el \
	haskell-menu.el \
	haskell-session.el \
	haskell-string.el \
	haskell-show.el \
	ghc-core.el \
	inf-haskell.el

ELCFILES = $(ELFILES:.el=.elc)
AUTOLOADS = haskell-site-file.el
DIST_FILES = $(ELFILES) $(ELCFILES) $(AUTOLOADS) haskell-mode-pkg.el.in logo.svg Makefile README.md NEWS
DIST_FILES_EX = examples/init.el examples/fontlock.hs examples/indent.hs
DIST_TGZ = haskell-mode-$(GIT_VERSION).tar.gz

PKG_DIST_FILES = $(ELFILES) logo.svg
PKG_TAR = haskell-mode-$(VERSION).tar

%.elc: %.el
	@$(BATCH) -f batch-byte-compile $<

.PHONY: all compile info dist clean

all: compile $(AUTOLOADS)

compile: $(ELCFILES)

clean:
	$(RM) $(ELCFILES) $(AUTOLOADS) $(TGZ)

info: # No Texinfo file, sorry.

# Generate snapshot distribution
dist: $(DIST_TGZ)

# Generate ELPA-compatible package
package: $(PKG_TAR)
elpa: $(PKG_TAR)

$(PKG_TAR): $(PKG_DIST_FILES) haskell-mode-pkg.el.in
	rm -rf haskell-mode-$(VERSION)
	mkdir haskell-mode-$(VERSION)
	cp $(PKG_DIST_FILES) haskell-mode-$(VERSION)/
	sed -e 's/@VERSION@/$(VERSION)/g' < haskell-mode-pkg.el.in > haskell-mode-$(VERSION)/haskell-mode-pkg.el
	sed -e 's/@GIT_VERSION@/$(GIT_VERSION)/g;s/@VERSION@/$(VERSION)/g' < haskell-mode.el > haskell-mode-$(VERSION)/haskell-mode.el #NO_DIST
	tar cvf $@ haskell-mode-$(VERSION)
	rm -rf haskell-mode-$(VERSION)
	@echo
	@echo "Created ELPA compatible distribution package '$@' from $(GIT_VERSION)"

$(AUTOLOADS): $(ELFILES) haskell-mode.elc
	[ -f $@ ] || echo '' >$@
	$(BATCH) --eval '(setq generated-autoload-file "'`pwd`'/$@")' -f batch-update-autoloads "."

# embed version number into .elc file
haskell-mode.elc: haskell-mode.el
	sed -e 's/@GIT_VERSION@/$(GIT_VERSION)/g;s/@VERSION@/$(VERSION)/g' < haskell-mode.el > haskell-mode.tmp.el #NO_DIST
	@$(BATCH) -f batch-byte-compile haskell-mode.tmp.el #NO_DIST
	mv haskell-mode.tmp.elc haskell-mode.elc #NO_DIST
	$(RM) haskell-mode.tmp.el #NO_DIST

$(DIST_TGZ): $(DIST_FILES)
	rm -rf haskell-mode-$(GIT_VERSION)
	mkdir haskell-mode-$(GIT_VERSION)
	cp -p $(DIST_FILES) haskell-mode-$(GIT_VERSION)
	mkdir haskell-mode-$(GIT_VERSION)/examples
	cp -p $(DIST_FILES_EX) haskell-mode-$(GIT_VERSION)/examples

	printf "1s/=.*/= $(VERSION)/\nw\n" | ed -s haskell-mode-$(GIT_VERSION)/Makefile #NO_DIST
	printf "2s/=.*/= $(GIT_VERSION)/\nw\n" | ed -s haskell-mode-$(GIT_VERSION)/Makefile #NO_DIST
	printf "g/NO_DIST/d\nw\n" | ed -s haskell-mode-$(GIT_VERSION)/Makefile #NO_DIST
	printf ',s/@VERSION@/$(VERSION)/\nw\n' | ed -s haskell-mode-$(GIT_VERSION)/haskell-mode.el #NO_DIST

	tar cvzf $@ haskell-mode-$(GIT_VERSION)
	rm -rf haskell-mode-$(GIT_VERSION)
