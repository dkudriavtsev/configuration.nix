{ config, pkgs, ... }: {
	home = {
		file = {
			bin = {
				source = ./bin;
				target = ".local/bin";
				recursive = true;
			};
		};
        packages = with pkgs; [
          solargraph
        ];
		sessionVariables = {
			EDITOR = "nvim";
			VISUAL = "nvim";
		};
	};

	xdg = {
		enable = true;
		userDirs.enable = true;
	};

	services = {
		fluidsynth.enable = true;
		lorri.enable = true;
	};

	fonts.fontconfig.enable = true;

	gtk = {
		font = {
			package = pkgs.source-sans-pro;
			name = "Source Sans Pro 11";
		};
		theme.name = "Adwaita-dark";
	};

	qt = {
		enable = true;
		platformTheme = "gnome";
	};

	programs = {
		obs-studio = {
			enable = true;
			plugins = with pkgs; [ obs-v4l2sink obs-gstreamer obs-xdg-portal ];
		};

		zsh = {
			enable = true;
			enableAutosuggestions = true;
			enableCompletion = true;
			# enableVteIntegration = true;
			autocd = true;
			dotDir = ".config/zsh";

			envExtra = ''
				export PATH=$HOME/bin:$HOME/.local/bin:$PATH
				export CDPATH=.:$HOME:$CDPATH

				export DEFAULT_USER=$(whoami)
				export GPG_TTY=$(tty)
			'';

			history = {
				extended = true;
				path = "${config.xdg.dataHome}/zsh/zsh_history";
				save = 100000;
				size = 100000;
			};

			initExtra = ''
				setopt GLOB_DOTS

				for i in util autopushd escesc; do
					source ${./zsh/snippets}/$i.zsh
				done

				eval $(thefuck --alias)
			'';

			dirHashes = {
				w = "$HOME/work";
			};

			sessionVariables = {
				EDITOR = "nvim";
				VISUAL = "nvim";
				NIX_AUTO_RUN = 1;
				MOZ_USE_XINPUT2 = 1;
			};

			shellAliases = {
				ls = "exa";
				open = "xdg-open";
				":e" = "vim";
				":w" = "sync";
				":q" = "exit";
				":wq" = "sync; exit";
				nbs = "time sudo nixos-rebuild switch --show-trace";
				nbsu = "time sudo nixos-rebuild switch --upgrade --show-trace";
				secn = "sudo -e /etc/nixos/configuration.nix";
				sehc = "sudo -e /etc/nixos/hardware-configuration.nix";
				sehn = "sudo -e /etc/nixos/home.nix";
			};

			prezto = {
				enable = true;
				extraModules = [ "attr" "stat" "zpty" ];
				extraFunctions = [ "zargs" "zmv" ];
				pmodules = [
					"environment"
					"terminal"
					"editor"
					"history"
					"directory"
					"spectrum"
					"helper"
					"utility"
					"completion"
					"prompt"
					"autosuggestions"
					"archive"
					"directory"
					"git"
					"history-substring-search"
					"pacman"
					"rails"
					"ruby"
					"ssh"
					"syntax-highlighting"
					"tmux"
					"wakeonlan"
				];
				autosuggestions.color = "fg=blue";
				editor.dotExpansion = true;
				prompt.theme = "agnoster";
				syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "line" "root" ];
				terminal = {
					autoTitle = true;
					multiplexerTitleFormat = "%s";
				};
				tmux = {
					autoStartLocal = true;
					autoStartRemote = true;
					defaultSessionName = "theseus";
				};
				utility.safeOps = false;
			};
		};

		tmux = {
			enable = true;
			aggressiveResize = true;
			clock24 = true;
			escapeTime = 50;
			historyLimit = 300000;
			newSession = true;
			sensibleOnTop = true;
			plugins = with pkgs.tmuxPlugins; [
				sensible yank
				{
					plugin = resurrect;
					extraConfig = ''
						set -g @resurrect-strategy-nvim 'session'
						set -g @resurrect-processes 'ssh telnet mosh-client nvim dmesg'
						set -g @resurrect-capture-pane-contents 'on'
					'';
				}
				{
					plugin = continuum;
					extraConfig = ''
						set -g @continuum-restore on
						set -g @continuum-save-interval '10' # minutes
					'';
				}
			];
			terminal = "xterm-256color";

			extraConfig = ''
				setw -g alternate-screen on
				set-option -ga terminal-overrides ",xterm-termite:Tc,xterm-256color:Tc"
				set-option -ga status-style fg=black,bg=blue
				set-option -ga clock-mode-colour white
				bind-key -n C-j detach
				set -g mouse on
			'';
		};

		dircolors = {
			enable = true;
			enableZshIntegration = true;

			extraConfig = (builtins.readFile ./dircolors);
		};

		direnv = {
			enable = true;
			enableZshIntegration = true;
			enableNixDirenvIntegration = true;
		};

		ssh = {
			enable = true;
			compression = true;
			controlMaster = "auto";
			controlPersist = "30m";
			forwardAgent = true;
			matchBlocks = {
				"theseus-remote" = {
					user = "anna";
					hostname = "ddns.dk0.us";
					port = 2225;
				};

				"github" = {
					user = "git";
					hostname = "github.com";
				};

				"gitlab" = {
					user = "git";
					hostname = "gitlab.com";
					identityFile = "~/.ssh/id_rsa";
				};

				"leonardo" = {
					user = "anna";
					hostname = "leonardo.dk0.us";
				};

				"neo" = {
					user = "anna";
					hostname = "neo.dk0.us";
				};

				"iris" = {
					user = "anna";
					hostname = "iris.dk0.us";
				};

				"talos" = {
					user = "anna";
					hostname = "talos.dk0.us";
				};

				"hephaestus" = {
					user = "pi";
					hostname = "hephaestus.ad.dk0.us";
				};

				"ews" = {
					user = "anna10";
					hostname = "linux.ews.illinois.edu";
				};

				"uiweb" = {
					user = "anna10";
					hostname = "anna10.web.illinois.edu";
				};

				"ghd" = {
					user = "git";
					hostname = "github-dev.cs.illinois.edu";
					identityFile = "/home/anna/.ssh/id_ghd";
				};
			};
		};

		neovim = {
			enable = true;
			extraConfig = ''
				filetype plugin indent on

				set autoread
				set backspace=indent,eol,start
				set clipboard+=unnamed
				set formatoptions+=j

				set hlsearch
				set ignorecase
				set incsearch

				set mouse=a
				set ttimeoutlen=50
				set smartcase

				set number
				set background=dark
				set cursorline
				set ruler

				set title
				set noshowmode
				set showcmd
				set hidden
				set laststatus=2

				set splitbelow
				set splitright

				set scrolloff=3
				set sidescrolloff=5
				set wrap

				set autoindent
				set copyindent
				set tabstop=4
				set shiftwidth=4
				set noexpandtab

				set undofile
				set undolevels=1000
				set undoreload=10000

				syntax on

				let  $NVIM_TUI_ENABLE_CURSOR_SHAPE=0

				command! W :w
				command! Q :q


				set termguicolors
				colorscheme base16-google-dark
				set background=dark

				"when entering a terminal enter in insert mode
				autocmd BufWinEnter,WinEnter term://* startinsert

				"airline
				let g:airline_powerline_fonts = 1
				let g:airline#extensions#tabline#enabled = 1
				let g:airline_detect_paste=1

				"NERDTree
				nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
				"let g:nerdtree_tabs_open_on_console_startup = 1

				"Syntastic
				let g:syntastic_error_symbol = 'E'
				let g:syntastic_warning_symbol = "W"
				augroup mySyntastic
				au!
				au FileType tex let b:syntastic_mode = "passive"
				augroup END

				" ----- xolox/vim-easytags settings -----
				" Where to look for tags files
				set tags=./tags;,~/.vimtags
				" Sensible defaults
				let g:easytags_events = ['BufReadPost', 'BufWritePost']
				let g:easytags_async = 1
				let g:easytags_dynamic_files = 2
				let g:easytags_resolve_links = 1
				let g:easytags_suppress_ctags_warning = 1

				" ----- majutsushi/tagbar settings -----
				" Open/close tagbar with \b
				nmap <silent> <leader>b :TagbarToggle<CR>
				" Uncomment to open tagbar automatically whenever possible
				"autocmd BufEnter * nested :call tagbar#autoopen(0)

				" ----- airblade/vim-gitgutter settings -----
				" Required after having changed the colorscheme
				hi clear SignColumn
				"In vim-airline, only display "hunks" if the diff is non-zero
				let g:airline#extensions#hunks#non_zero_only = 1
				
				
				" ----- Raimondi/delimitMate settings -----
				let delimitMate_expand_cr = 1
				augroup mydelimitMate
				au!
				au FileType markdown let b:delimitMate_nesting_quotes = ["`"]
				au FileType tex let b:delimitMate_quotes = ""
				au FileType tex let b:delimitMate_matchpairs = "(:),[:],{:},`:'"
				au FileType python let b:delimitMate_nesting_quotes = ['"', "'"]
				augroup END"'"'"]"'"`

				set guifont=Source\ Code\ Pro\ 15.5

				"[NeoMake]
				" When reading a buffer (after 1s), and when writing (no delay).
				" call neomake#configure#automake('rw', 1000)

				" LSP
				lua <<EOF
				  require'lspconfig'.solargraph.setup{}
EOF

				"[Deoplete]
				let g:deoplete#enable_at_startup = 1
				"dont require the same file type
				let g:deoplete#buffer#require_same_filetype = 0
				"<TAB> completion.
				inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
				"dont litter your windows
				autocmd CompleteDone * pclose

				"[ctrlp.vim]
				let g:ctrlp_working_path_mode = 'ra'
				"ignore whats in git ignore
				let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']
				let g:ctrlp_path_sort = 1
				"this is to prioritize matches sanely such as exact first
				let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

				"[rainbow]
				let g:rainbow_active = 1

				" ripgrep
				if executable('rg')
				let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
				set grepprg=rg\ --vimgrep
				command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
				endif
			'';
			plugins = with pkgs.vimPlugins; [
				base16-vim vim-gitgutter

				# completions/neomake
				deoplete-nvim neco-vim nvim-lspconfig neomake neoinclude-vim neco-syntax
				deoplete-emoji deoplete-github deoplete-zsh deoplete-lsp

				vim-autoformat colorizer rainbow vim-airline vim-airline-themes

				# languages
				syntastic vim-polyglot vim-nix dart-vim-plugin

				# misc
				nerdtree vim-nerdtree-tabs tabular
				vim-commentary vim-dispatch vim-fugitive vim-rhubarb
				vim-sensible vim-sleuth vim-speeddating

				vim-sneak vim-surround delimitMate vim-easytags vim-startify bclose-vim
				ctrlp-py-matcher fzf-vim
				tmux-complete-vim vim-misc tagbar a-vim

				# session saving
				vim-obsession vim-prosession
			];
			viAlias = true;
			vimAlias = true;
			vimdiffAlias = true;
		};
	};
}
