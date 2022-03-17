add:
	cp ~/.config/nvim/init.vim ./nvim/
	cp ~/.config/nvim/coc-settings.json ./nvim/
	cp ~/.config/fontconfig/fonts.conf ./fontconfig/
	cp ~/.aria2/aria2.conf ./aria2/aria2.conf
	sed -ri "s#rpc-secret=\w+#rpc-secret=#g" aria2/aria2.conf
