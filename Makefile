all:

install:
	mkdir -p $(DESTDIR)/usr/share/icons
	cp --no-preserve=mode,ownership -r \
		ePapirus \
		Papirus \
		Papirus-Light \
		Papirus-Dark \
		$(DESTDIR)/usr/share/icons

post-install:
	-gtk-update-icon-cache -q $(DESTDIR)/usr/share/icons/ePapirus
	-gtk-update-icon-cache -q $(DESTDIR)/usr/share/icons/Papirus
	-gtk-update-icon-cache -q $(DESTDIR)/usr/share/icons/Papirus-Dark
	-gtk-update-icon-cache -q $(DESTDIR)/usr/share/icons/Papirus-Light

uninstall:
	-rm -rf $(DESTDIR)/usr/share/icons/ePapirus
	-rm -rf $(DESTDIR)/usr/share/icons/Papirus
	-rm -rf $(DESTDIR)/usr/share/icons/Papirus-Dark
	-rm -rf $(DESTDIR)/usr/share/icons/Papirus-Light

_get_version:
	$(eval VERSION := $(shell git show -s --format=%cd --date=format:%Y%m%d HEAD))
	@echo $(VERSION)

push:
	git push origin

release: _get_version push
	git tag -f $(VERSION)
	git push origin --tags

undo_release: _get_version
	-git tag -d $(VERSION)
	-git push --delete origin $(VERSION)

tests:
	# Printing all broken symlinks
	@find . -xtype l -not -path './tools/work/*' -print

update_authors:
	editor Papirus/AUTHORS
	cp -f Papirus/AUTHORS ePapirus/AUTHORS
	cp -f Papirus/AUTHORS Papirus-Dark/AUTHORS
	cp -f Papirus/AUTHORS Papirus-Light/AUTHORS


.PHONY: all install uninstall _get_version push release undo_release tests update_authors
