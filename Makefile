add:
	cp ~/.config/nvim/init.vim ./config/nvim/
	cp ~/.config/nvim/coc-settings.json ./config/nvim/
	cp ~/.config/fontconfig/fonts.conf ./config/fontconfig/
	cp ~/.aria2/aria2.conf ./aria2/aria2.conf
	sed -ri "s#rpc-secret=\w+#rpc-secret=#g" aria2/aria2.conf
	cp ~/.zshrc ./zshrc
