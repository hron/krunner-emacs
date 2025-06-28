pack:
	mkdir -p dist/
	tar czf dist/krunner-emacs-0.0.1.tar.gz --xform s:^.*/:: install.sh uninstall.sh krunner_emacs.desktop krunner_emacs.el
