% sectionなどを指定した行数の天地中央に置く(まだα版)
% 設定済みの版面と本文サイズ
% A5/12Q
% footnote改変中
\iffalse
[fomersize]=フォントサイズの割り当てをjbookのものに戻します．
notombow=用紙の四隅に仕上がりを示す罫線（トンボ）を印字させません．*初期値は印字
mentuke=トンボの罫幅を0にします．面付け位置をたもったままにすることが目的
openright=章を奇数ページにします．
openany=章を偶数ページからでも起こせるようにします．
leqno=数式番号を左端に置きます．
fleqn=独立数式を本文左右中央ではなく左端の決まった位置から始めます．
gtsf=基本的なパーツが\sffamily+\gtfamilyになります．
A4size=PDF用の\specialを埋め込みます．
config=簡易設定用のファイルを読み込みます．
simply=簡易設定用のファイルを読み込みます．
min10=和文tfmにmin10.tfmをロードします．デフォルトはjis.tfm
a5 = 判型をA5判にし，normalsizeを13Qにします．
a5/12Q=判型をA5判にし，normalsizeを12Qにします．
a5/13.5Q=判型をA5判にし，normalsizeを13.5Qにします．
b5=判型をB5判にし，normalsizeを13Qにします．
b5/13.5Q=判型をB5判にし，normalsizeを13.5Qにします．
b5/12Q=判型をB5判にし，normalsizeを12Qにします．
b5var/13Q=判型をB5判にし，normalsizeを13Qにします．
b5var/13.5Q=判型をB5変形にします．
b5var/12Q=判型をB5変形にします．

\ExecuteOptions{a5,twoside,cmscale,onecolumn,final,openright}
\fi

\NeedsTeXFormat{pLaTeX2e}
\ProvidesClass{kyouritu}[2009/12/08]


% \maketitleの\publisherで引数なしの場合に印字されます．
\def\@publisher{共立出版株式会社}

% min10.tfm由来(jis系tfmも含んだ)の和文フォントサイズを補正しています．
% pTeXではcmフォントに大きさを合わせるために，和文サイズを
% 約0.961倍程度に縮小して出力します．
% そのため，\fontsizeコマンドで13Qを出力させたくても13*0.961=12.493Qという
% 中途半端な大きさになってしまいます．
% ここでこれを補正して13Qと指定すれば実サイズで13Qが出力されるように
% しています．1.0392676はその拡大率で，以後これを\@jqscaleとして定義します．
\def\@jqscale{1.0392676}

\let\s@vpt\@vpt
\let\s@ivpt\@vipt
\let\s@viipt\@viipt
\let\s@viiipt\@viiipt
\let\s@ixpt\@ixpt
\let\s@xpt\@xpt
\let\s@xipt\@xipt
\let\s@xiipt\@xiipt
\let\s@xivpt\@xivpt
\let\s@xviipt\@xviipt
\let\s@xxpt\@xxpt
\let\s@xxvpt\@xxvpt

%% 文字サイズと行送り用の変数の宣言です．
\newdimen\@@tiny
\newdimen\@@scriptsize
\newdimen\@@footnotesize
\newdimen\@@small
\newdimen\@@normalsize
\newdimen\@@large
\newdimen\@@Large
\newdimen\@@LARGE
\newdimen\@@huge
\newdimen\@@Huge
\newdimen\@@HUGE
\newdimen\@@tiny@@baseline
\newdimen\@@scriptsize@@baseline
\newdimen\@@footnotesize@@baseline
\newdimen\@@small@@baseline
\newdimen\@@normalsize@@baseline
\newdimen\@@large@@baseline
\newdimen\@@Large@@baseline
\newdimen\@@LARGE@@baseline
\newdimen\@@huge@@baseline
\newdimen\@@Huge@@baseline
\newdimen\@@HUGE@@baseline

% \DeclarePaperFormatで使う目的で作った引数をチェックするマクロで，
% 引数が数値だけなのかか，単位つきかを判断します．
% 与えられた文字列に数字以外が含まれているかをカテゴリーコードで判断を
% 行っているので変数は使えません．
\newif\ifunit@cnt@
\unit@cnt@false
\def\@unit@check#1{%	\ifunit@cnt@が切り替わる
%			num+unit -> \unit@cnt@false
%			num      -> \unit@cnt@true
	\@tfor\@@unit@@check :=#1\do{%
		\ifcat\@@unit@@check1\unit@cnt@true
			\else \unit@cnt@false
		\fi}}%
%%\@unit@check{123}
%%%\ifunit@cnt@
%%%aaaa
%%%\else
%%%bbbb
%%%\fi
% このマクロでクラスオプションの名称，用紙サイズ，判面を設定します．
% 判面左右は文字の倍数もしくは寸法，天地はそれぞれ行数 ，もしくは寸法で
% 指定します．文字数や行数の場合は`zw'や`\baselineskip'は指定しないで，単位なしの数値のみで指定します．
% 寸法の場合は，mmやptをつけて指定しますが，数値指定が基本です．
\def\DeclarePaperFormat#1#2#3#4#5{%
% #1=<dsoption> #2=\paperwidth #3=\paperheight #4=\textwidth #5=\textheight
%\DeclareOption{#1}{%
\def\curentpageformat{#1}
	\paperwidth=#2\relax%
	\paperheight=#3\relax%
\@unit@check{#4}%
\ifunit@cnt@%
	\textwidth\@@normalsize
	\multiply\textwidth #4\relax
\else
\textwidth#4\relax
\fi
\@unit@check{#5}%
\ifunit@cnt@%
	\textheight=#5\@@normalsize@@baseline
	\advance\textheight-\@@normalsize@@baseline
		\if@keepfline@@
			\topskip=\@@normalsize@@baseline
		\else
			\setbox0\hbox{\char\euc"A1A1}%
			\topskip=\ht0\relax
			\topskip=\@jqscale\topskip
		\fi
	\advance\textheight by\topskip
\else
\textheight=#5\relax
\fi
%}%
}

% \DeclareFontSizeBaselinenなるコマンドを新設して標準的なLaTeXのサイズコマンド
% を比較的容易に変更できるようにしています．
% 併せて，新規のサイズコマンドを新設できるようにしています．
% (標準的なLaTeXサイズコマンドの変更の場合，このマクロでは決して本質的な変更を行っているわけではないことに注意が必要です．このマクロでは単に数値の保存を行っているだけです．)
% 引数で既成のサイズコマンドを指定し#1で文字サイズ，#2でbaselineskipを設定します．
% 新規のサイズコマンドの場合，#1を（定義可能な）適当な名称で設定可能です．
% simplesetting.styというファイルで最低限必要な体裁情報を設定できるようにして
% いますが，LaTeX標準のサイズコマンドの設定はプリアンブルなどでの変更はできません．本来ならば\documentclass[b5]などと指定した場合，b5サイズに連動させて行間を調整したり修正したりすべきでしょうが，\DeclarePaperFormatで設定した内容と特に連動はさせていません．
\def\show@size#1{%
\dimen@=\csname @@#1\endcsname\relax
\@tempdima\dimen@
\dimen@ 0.3514\dimen@\relax
\dimen@ 4\dimen@\relax
\edef\pt@Q{\strip@pt\dimen@}
\typeout{#1 = \pt@Q Q / \the\@tempdima}
}

\gdef\DeclareFontSizeBaseline#1#2#3{\@ifundefined{@@#1}{%
\expandafter\def\csname #1\endcsname{%
\@nomath{#1}%
    \ifx\protect\@typeset@protect
%     \def\@@@currsize{\csname #1\endcsname}%
%      \let\@currsize\@@@currsize
     \expandafter\def\expandafter\@currsize\expandafter{\csname #1\endcsname}%
    \fi
\fontsize{#2}{#3}\selectfont
}}{%
\csname @@#1\endcsname=#2\relax%
\csname @@#1@@baseline\endcsname=#3\relax%
\show@size{#1}}}



% \bfsなる書体切り替えコマンドを新設しています．
% この\bfsは各パーツの\bfseries に置き換えるように定義してます．
% クラスオプション[gtsf]でこれは\sffamily+\gtfamilyに置き換わります．
% 例： \documentclass[gtsf,tombow]{ttcalss}
% これにより，見出しやキャプションなど主要なパーツは\sffamily+\gtfamily
% になります．
%	この場合は，\renewcommand{\sfdefault}{phv}としてhelveticaを使った
%	方が見栄えが良いかもしれません．
% \bf や\textbfでは従来通り\rmfamily/\bfseries+\gtfamilyです．
% この点について当初\bf と\textbfでも\sffamily+\gtfamilyの組合せにしようと
% 思いましたがとりあえず止めにしています．
% \sffamilyに\gtfamilyを連動させていますので，
% 本文中でこの組合せにしたい場合は\sf, \textsfとします．
% 
%\DeclareRobustCommand*{\bfs}{\kanjifamily\gtdefault\romanfamily\sfdefault\selectfont}
\DeclareRobustCommand*{\bfs}{\kanjifamily\gtdefault\rmfamily\bfseries}
% \renewcommand{\sfdefault}{phv}

% 各パーツにフォントとサイズをセットします．
 \newcommand{\KBcaptionfont}{\reset@font\small}
 \newcommand{\KBpagenumfont}{\reset@font\small}
 \newcommand{\KBheaderfont}{\reset@font\small}
 \newcommand{\KBmarginparfont}{\reset@font\footnotesize}
%%% 見出し
%% 命名規則変更 KB+parts+font
 \newcommand{\KBpartfont}{\reset@font\huge\bfs}
 \newcommand{\KBpartnumfont}{\reset@font\huge\bfs}
 \newcommand{\KBchapterfont}{\reset@font\huge\bfs}
 \newcommand{\KBchapternumfont}{\reset@font\huge\bfs}
 \newcommand{\KBindextitlefont}{\reset@font\huge\bfs}%
 \newcommand{\KBsectionfont}{\reset@font\Large\bfs}
 \newcommand{\KBsectionnumfont}{\reset@font\Large\bfs}
 \newcommand{\KBsubsectionfont}{\reset@font\large\bfs}
 \newcommand{\KBsubsectionnumfont}{\reset@font\large\bfs}
 \newcommand{\KBsubsubsectionfont}{\reset@font\normalsize\bfs}
 \newcommand{\KBsubsubsectionnumfont}{\reset@font\normalsize\bfs}
 \newcommand{\KBparagraphfont}{\reset@font\normalsize\bfs}
 \newcommand{\KBparagraphnumfont}{\reset@font\normalsize\bfs}
 \newcommand{\KBsubparagraphfont}{\reset@font\normalsize\bfs}
% 目次
 \newcommand{\KBtocpartfont}{\reset@font\Large\bfs}
 \newcommand{\KBtocnumpartfont}{\reset@font\Large\bfs}
 \newcommand{\KBtocchapterfont}{\reset@font\large\bfs}
 \newcommand{\KBtocnumchapterfont}{\reset@font\large\bfs}
 \newcommand{\KBtocsectionfont}{\reset@font\rmfamily\normalcolor}
 \newcommand{\KBtocsubsectionfont}{\reset@font\rmfamily\normalcolor}
 \newcommand{\KBtocsubsubsectionfont}{\reset@font\rmfamily\normalcolor}
 \newcommand{\KBtocnumsectionfont}{\reset@font\rmfamily\normalcolor}
 \newcommand{\KBtocnumsubsectionfont}{\reset@font\rmfamily\normalcolor}
 \newcommand{\KBTocNumsubsubSectionFont}{\reset@font\rmfamily\normalcolor}
 \newcommand{\KBtocnumsubsubsectionFont}{\reset@font\rmfamily\normalcolor}

% \selectfontに\parindentと\(x)kanjiskipの設定，および数式の添字に対するサイズ補正を追加しています．
% 文字サイズが変更されても，文字の大きさに応じて各パラメータが追従します．
% 数式の添字の大きさの補正は，親文字が11Q以下の場合は
% \scriptfontは0.9倍，\scriptscriptfontは0.85倍にし，
% 20Q以上の場合は0.83倍，0.67倍にします．
\let\save@defaultscriptratio\defaultscriptratio
\let\save@defaultscriptscriptratio\defaultscriptscriptratio


\def\default@tiny@scriptratio{.9}
\def\default@tiny@scriptscriptratio{.85}
\def\default@Huge@scriptratio{0.83}
\def\default@Huge@scriptscriptratio{0.67}
\def\script@script@tiny@limit{11Q}
\def\script@script@Huge@limit{20Q}

\def\@set@indent@update@{%
\ifdim\parindent>\z@\parindent=1zw\fi
\kanjiskip=0zw plus .1zw minus .01zw%
\ifdim\xkanjiskip>\z@\xkanjiskip0.2zw plus 0.1zw minus 0.06zw\fi
 \ifdim\f@size\p@ <\script@script@tiny@limit
    \def\defaultscriptratio{\default@tiny@scriptratio}%
    \def\defaultscriptscriptratio{\default@tiny@scriptscriptratio}%
 \else
 \ifdim\f@size\p@ >\script@script@Huge@limit
    \def\defaultscriptratio{\default@Huge@scriptratio}%
    \def\defaultscriptscriptratio{\default@Huge@scriptscriptratio}%
\else
 \let\defaultscriptratio\save@defaultscriptratio
 \let\defaultscriptscriptratio\save@defaultscriptscriptratio
\fi
\fi%
}
\DeclareRobustCommand\selectfont{%
  \let\tmp@error@fontshape\error@fontshape
  \let\error@fontshape\error@kfontshape
  \edef\tmp@item{{\k@encoding}}%
  \expandafter\expandafter\expandafter
  \inlist@\expandafter\tmp@item\expandafter{\kyenc@list}%
  \ifin@
    \let\cy@encoding\k@encoding
    \edef\ct@encoding{\csname t@enc@\k@encoding\endcsname}%
  \else
    \expandafter\expandafter\expandafter
    \inlist@\expandafter\tmp@item\expandafter{\ktenc@list}%
    \ifin@
      \let\ct@encoding\k@encoding
      \edef\cy@encoding{\csname y@enc@\k@encoding\endcsname}%
    \else
      \@latex@error{KANJI Encoding scheme `\k@encoding' unknown}\@eha
    \fi
  \fi
  \let\font\tfont
  \let\k@encoding\ct@encoding
  \xdef\font@name{\csname\curr@kfontshape/\f@size\endcsname}%
  \pickup@font
  \font@name
  \let\font\jfont
  \let\k@encoding\cy@encoding
  \xdef\font@name{\csname\curr@kfontshape/\f@size\endcsname}%
  \pickup@font
  \font@name
  \expandafter\def\expandafter\k@encoding\tmp@item
  \kenc@update
  \let\error@fontshape\tmp@error@fontshape
  \if@knjcmd \@knjcmdfalse
    \expandafter\ifx
    \csname rel@\k@encoding/\k@family/\k@series/\k@shape\endcsname\relax
      \expandafter\ifx
         \csname rel@\k@encoding/\k@family/\k@series/all\endcsname\relax
      \else
         \csname rel@\k@encoding/\k@family/\k@series/all\endcsname
      \fi
    \else
       \csname rel@\k@encoding/\k@family/\k@series/\k@shape\endcsname
    \fi
  \fi
  \let\font\afont
  \xdef\font@name{\csname\curr@fontshape/\f@size\endcsname}%
  \pickup@font
  \font@name
  \enc@update
  \ifx\f@linespread\baselinestretch \else
    \set@fontsize\baselinestretch\f@size\f@baselineskip
  \fi
  \size@update\@set@indent@update@}

% pTeXの\inhibitglueのbug由来で起こる強制改行後約物不揃いに対するTeX FAQで
% 公開されたjsシリーズ用のZ.R氏のパッチ．jsシリーズとほぼ同じプロセスを
% 使っているので本クラスファイルでも適用させてます．
% ## 強制改行後の処理を\ignorespacesでなく\futureletで空白トークンを
% ## 読み飛ばしてから\@inhibitglue．
\def\@gnewline #1{%
  \ifvmode
    \@nolnerr
  \else
    \unskip \reserved@e {\reserved@f#1}\nobreak \hfil \break \null
    \expandafter\js@afternewline
  \fi}
\def\js@afternewline{%
  \protect\js@afternl@a}
\def\js@afternl@a{%
  \futurelet\@let@tokan\js@afternl@b}
\def\js@afternl@b{%
  \ifx\@let@token\@sptoken
    \expandafter\js@afternl@a
  \else
    \expandafter\@inhibitglue
  \fi}


% 各条件分岐の宣言です．
\newif\if@fomersize\@fomersizetrue
\newif\if@Koguchi\@Koguchifalse
\newif\if@BfSf\@BfSffalse
\newif\if@JisTFM\@JisTFMtrue
\newif\if@PsJfont\@PsJfontfalse
\newif\ifS@ection\S@ectionfalse
\newif\ifsubS@ection\subS@ectionfalse
\newif\ifsubsubS@ection\subsubS@ectionfalse
\newif\ifAFour\AFourfalse
%\newif\if@@simply@\@@simply@false
\newif\if@@config@\@@config@false
\newif\if@keepfline@@\@keepfline@@false
% \@keepfline@@true
% どの見出しレベルの\@dottedtoclineが実行されたかを
% 判断して目次の文字サイズをセットします．
\newcommand{\@TocSectionSlectFont}{%
\ifS@ection
  \KBtocsectionfont
\else
   \ifsubS@ection
     \KBtocsubsectionfont
   \else
     \ifsubsubS@ection
       \KBtocsubsubsectionfont
     \else
         \reset@font\rmfamily \normalcolor
     \fi
    \fi
\fi
}
% 同じです．これは目次で引かれるページ番号
\newcommand{\@TocSectionNumSlectFont}{%
\ifS@ection%
  \KBtocnumsectionfont%
\else%
   \ifsubS@ection%
     \KBtocnumsubsectionfont%
   \else%
     \ifsubsubS@ection%
      \KBtocnumsubsubsectionFont%
     \else%
        \reset@font\rmfamily \normalcolor%
      \fi%
     \fi%
\fi%
}

% 禁則penaltyの補正です．
\prebreakpenalty\jis"2147=10000
\postbreakpenalty\jis"2148=10000
\prebreakpenalty\jis"2149=10000
% このあたりはjbookのままです．
% ただbannerfontは趣味でスラントにしました．
\newif\if@landscape \@landscapefalse
\newcommand{\@ptsize}{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagetrue
\newif\if@openright
\newif\if@mainmatter \@mainmattertrue
\hour\time \divide\hour by 60\relax
\@tempcnta\hour \multiply\@tempcnta 60\relax
\minute\time \advance\minute-\@tempcnta
\newif\if@stysize \@stysizefalse
\newif\if@enablejfam \@enablejfamtrue
\font\@bannerfont=cmsl8
\DeclareOption{tombow}{%
  \tombowtrue \tombowdatetrue
  \setlength{\@tombowwidth}{.1\p@}%
  \@bannertoken{p\LaTeXe:\space%
     \jobname\space:\space\number\year/\number\month/\number\day
      (\number\hour:\number\minute)}
  \maketombowbox}
\DeclareOption{notombow}{%
  \tombowfalse \tombowdatefalse
}

\DeclareOption{tombo}{%
  \tombowtrue \tombowdatefalse
  \setlength{\@tombowwidth}{.1\p@}%
  \maketombowbox}
\DeclareOption{mentuke}{%
  \tombowtrue
  \setlength{\@tombowwidth}{\z@}%
  \@bannertoken{\@empty}
  \maketombowbox}
\DeclareOption{tate}{%
  \AtBeginDocument{\tate\message{《縦組モード》}% 縦組モードは動作未確認.
                   \adjustbaseline}%
}
% optionのcmscale, gtsfなどを追加しています．
% gtsfは\bsfをボールドからサンセリフにします．
% [cmscale]はscale修正したcmfontをloadします（初期値），
% [simply][config]はsimplesetting.styの読み込みを行うオプションです．

% 各仕上がりサイズに応じて版面や文字サイズなどを個別に指定します．
% 版面は仕上がりサイズとの比率で設定しようかと考えましたが絶対値を指定されると
% 面倒なので，やや冗長ではありますが，このようにしたほうが指定も楽になるので
% このようにしました．
% 想定している仕上がりサイズは現在A5正寸，B5正寸，B5変形(210mm×182mm)の三つです．
% \DeclareFontSizeBaseline{#1}{#2}{#3}
% #1 <sizecommand>
% #2 <文字サイズ>
% #3 <行間(baselineskip)>
% b5，b5変形，a5判でのデフォルト設定
% \DeclarePaperFormat{#1}{#2}{#3}{#4}{#5}
% #1 <クラスオプションで指定する文字列>
% #2 <用紙サイズの左右>
% #3 <用紙サイズの天地>
% #4 <判面左右（文字数の倍数の場合単位なし）>
% #5 <判面天地（行数の倍数の場合単位なし）>
\DeclareOption{a5}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}
\DeclareOption{a5/12Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{9Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{10Q}{14H}
	\DeclareFontSizeBaseline{small}{11Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{12Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}
\DeclareOption{a5/12.5Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{12.5Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}
\DeclareOption{a5/13Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}
\DeclareOption{a5/13.5Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13.5Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}
\DeclareOption{a5/14Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{14Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}
\DeclareOption{b5}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{20H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{b5}{182mm}{257mm}{43}{40}
}
\DeclareOption{b5/12Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{b5}{182mm}{257mm}{43}{39}
}
\DeclareOption{b5/13Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{b5}{182mm}{257mm}{43}{39}
}
\DeclareOption{b5/13.5Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13.5Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{b5}{182mm}{257mm}{43}{39}
}
\DeclareOption{b5/14Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{14Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{b5}{182mm}{257mm}{43}{39}
}
\DeclareOption{b5ver/13Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
\DeclarePaperFormat{b5var}{182mm}{210mm}{43}{40}
}
\DeclareOption{b5ver/13.5Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13.5Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
\DeclarePaperFormat{b5var}{182mm}{210mm}{43}{40}
}
\DeclareOption{b5ver/14Q}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{14Q}{21H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
\DeclarePaperFormat{b5var}{182mm}{210mm}{43}{40}
}
\DeclareOption{a5/10pt}{%
	\DeclareFontSizeBaseline{tiny}{\s@vpt pt}{6pt}
	\DeclareFontSizeBaseline{scriptsize}{\s@viipt pt}{8pt}
	\DeclareFontSizeBaseline{footnotesize}{\s@viiipt pt}{9.5pt}
	\DeclareFontSizeBaseline{small}{\@ixpt pt}{11pt}
	\DeclareFontSizeBaseline{normalsize}{\s@xpt pt}{15pt}
	\DeclareFontSizeBaseline{large}{\s@xiipt pt}{17pt}
	\DeclareFontSizeBaseline{Large}{\s@xivpt pt}{21pt}
	\DeclareFontSizeBaseline{LARGE}{\s@xviipt pt}{25pt}
	\DeclareFontSizeBaseline{huge}{\s@xxpt pt}{28pt}
	\DeclareFontSizeBaseline{Huge}{\s@xxvpt pt}{33pt}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a5}{148mm}{210mm}{34}{31}
}

\DeclareOption{episode}{%
	\DeclareFontSizeBaseline{tiny}{7Q}{9H}
	\DeclareFontSizeBaseline{scriptsize}{10Q}{12H}
	\DeclareFontSizeBaseline{footnotesize}{11Q}{14H}
	\DeclareFontSizeBaseline{small}{12Q}{16H}
	\DeclareFontSizeBaseline{normalsize}{13Q}{20H}
	\DeclareFontSizeBaseline{large}{14Q}{20H}
	\DeclareFontSizeBaseline{Large}{15Q}{21H}
	\DeclareFontSizeBaseline{LARGE}{16Q}{24H}
	\DeclareFontSizeBaseline{huge}{20Q}{29H}
	\DeclareFontSizeBaseline{Huge}{25Q}{31H}
	\DeclareFontSizeBaseline{HUGE}{45Q}{61H}
	\DeclareFontSizeBaseline{tabfont}{12Q}{14H}
	\DeclarePaperFormat{a4}{210mm}{297mm}{52}{50}
}
\DeclareOption{oneside}{\@twosidefalse}
\DeclareOption{twoside}{\@twosidetrue}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{twocolumn}{\@twocolumntrue}
\DeclareOption{titlepage}{\@titlepagetrue}
\DeclareOption{notitlepage}{\@titlepagefalse}
\DeclareOption{openright}{\@openrighttrue}
\DeclareOption{openany}{\@openrightfalse}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
%%\DeclareOption{cmscale}{\input{cmscale3.sty}}
\DeclareOption{gtsf}{\@BfSftrue}
\DeclareOption{fomersize}{\@fomersizefalse}
\DeclareOption{A4size}{\AFourtrue}%% 用紙サイズをA4にします．(A4sizeの名称は紛らわしいかも)
%\DeclareOption{simply}{\@@config@true}%% 設定ファイルを読み込む．
\DeclareOption{config}{\@@config@true}%% 設定ファイルを読み込む．
\DeclareOption{keepfline}{\@keepfline@@true}
% 上はページの第一行目に背の高い文字が来ても極力一行目が下にずれないための処置です．ただし，大きな文字を使った\sectionなどでも天をはみ出してしまう副作用があるのでデフォルトはfalseにしてます．せっかく設定したのでオプション扱いで残します．
\DeclareOption{openbib}{%
  \AtEndOfPackage{%
   \renewcommand\@openbib@code{%
      \advance\leftmargin\bibindent
      \itemindent -\bibindent
      \listparindent \itemindent
      \parsep \z@
      }%
   \renewcommand\newblock{\par}}}
\DeclareOption{disablejfam}{\@enablejfamfalse}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{min10}{\@JisTFMfalse}
% 過去のバージョンとの互換性を保つため[multijfont]は残しています．
\DeclareOption{multijfont}{\@PsJfonttrue}
\DeclareOption{cid}{\@PsJfonttrue}

\ExecuteOptions{a5/13Q,tombow,twoside,onecolumn,final,openright}
\ProcessOptions\relax
\typeout{<<<<\the\textwidth,\the\textheight,\the\paperwidth,\the\paperheight}

\begingroup
\nfss@catcodes
%% OMXの指定間違いを修正
%% 和文とCMフォントとのバランス調整 Beta版
%% 
%% OT1/cmr/m/n/10とOMX/cmex/m/n/10 を初期化
\DeclarePreloadSizes{OT1}{cmr}{m}{n}{10}
\DeclarePreloadSizes{OMX}{cmex}{m}{n}{10}
%ot1cmr.fd
%\DeclareFontFamily{OT1}{cmr}{\hyphenchar\font45 }
\DeclareFontShape{OT1}{cmr}{m}{n}%
	{<-12> s* [1.056000]cmr10
	<12-17> s*  [1.056000]cmr12%
	<17-> s*  [1.056000]cmr17}{}%
\DeclareFontShape{OT1}{cmr}{m}{sl}%
	{<-> s* [1.056000]cmsl10}{}
\DeclareFontShape{OT1}{cmr}{m}{it}%
	{<-> s* [1.056000]cmti10}{}
\DeclareFontShape{OT1}{cmr}{m}{sc}%
	{<-> s* [1.056000]cmcsc10}{}%
\DeclareFontShape{OT1}{cmr}{m}{ui}%
	{<-> s* [1.056000]cmu10}{}%
\DeclareFontShape{OT1}{cmr}{b}{n}{%
	<-> s* [1.056000]cmb10}{}%
\DeclareFontShape{OT1}{cmr}{bx}{n}{%
	<-12> s* [1.056000]cmbx10%
	<12-> s*  [1.12]cmbx12}{}
\DeclareFontShape{OT1}{cmr}{bx}{sl}%
	{<-> s* [1.056000]cmbxsl10}{}
\DeclareFontShape{OT1}{cmr}{bx}{it}
	{<-> s* [1.056000]cmbxti10}{}
\DeclareFontShape{OT1}{cmr}{bx}{ui}
	{<-> s* [1.056000]ssub*cmr/m/ui}{}
%omscmsy.fd
%\DeclareFontFamily{OMS}{cmsy}{\skewchar\font48 }
\DeclareFontShape{OMS}{cmsy}{m}{n}{%
   <-6> s* [1.056000]cmsy5%
   <6-7> s* [1.056000]cmsy6%
   <7-8> s* [1.056000]cmsy7%
   <8-9> s* [1.056000]cmsy8%
   <9-10> s* [1.056000]cmsy9%
   <10-> s* [1.056000]cmsy10}{}
\DeclareFontShape{OMS}{cmsy}{b}{n}{%
   <-6> s* [1.056000]cmbsy5%
   <6-7> s* [1.056000]cmbsy6%
   <7-8> s* [1.056000]cmbsy7%
   <8-9> s* [1.056000]cmbsy8%
   <9-10> s* [1.056000]cmbsy9%
   <10-> s* [1.056000]cmbsy10}{}
%omxcmex.fd
\DeclareFontFamily{OMX}{cmex}{}{}
%\DeclareFontShape{OMX}{cmex}{m}{n}{<->sfixed*[1.056000]cmex10}{}
\DeclareFontShape{OMX}{cmex}{m}{n}{<->s*[1.056000]cmex10}{}
%ucmr.fd
%\DeclareFontFamily{U}{cmr}{\hyphenchar\font45 }
\DeclareFontShape{U}{cmr}{m}{n}{%
	<-> s* [1.056000]cmr10}{}%
\DeclareFontShape{U}{cmr}{m}{sl}{%
	<-> s* [1.056000]cmsl10}{}
\DeclareFontShape{U}{cmr}{m}{it}{%
	<-> s* [1.056000]cmti10}{}
\DeclareFontShape{U}{cmr}{m}{sc}{%
	<-> s* [1.056000]cmcsc10}{}
\DeclareFontShape{U}{cmr}{m}{ui}{%
	<-> s* [1.056000]cmu10}{}
\DeclareFontShape{U}{cmr}{b}{n}{%
	<-> s* [1.056000]cmb10}{}
\DeclareFontShape{U}{cmr}{bx}{n}{%
	<-12> s* [1.056000]cmbx10%
	<12-> s* [1.056000]cmbx12}{}
\DeclareFontShape{U}{cmr}{bx}{sl}{%
	<-> s* [1.056000]cmbxsl10}{}
\DeclareFontShape{U}{cmr}{bx}{it}{%
	<-> s* [1.056000]cmbxti10}{}
\DeclareFontShape{U}{cmr}{bx}{ui}{%
	<->ssub*[1.056000]cmr/m/ui}{}
%ot1cmss.fd
\DeclareFontShape{OT1}{cmss}{m}{n}{%
	<-> s* [1.056000]cmss10}{}
\DeclareFontShape{OT1}{cmss}{m}{it}{%
	<->sub*cmss/m/sl}{}
\DeclareFontShape{OT1}{cmss}{m}{sl}{%
	<-> s* [1.056000]cmssi10}{}
\DeclareFontShape{OT1}{cmss}{m}{sc}{%
	<->sub*cmr/m/sc}{}
\DeclareFontShape{OT1}{cmss}{m}{ui}{%
	<->sub*cmr/m/ui}{}
\DeclareFontShape{OT1}{cmss}{sbc}{n}{%
	<-6> s* [1.056000]cmssdc5%
	<6-7> s* [1.056000]cmssdc6%
	<7-8> s* [1.056000]cmssdc7%
	<8-9> s* [1.056000]cmssdc8%
	<8-10> s* [1.056000]cmssdc10}{}
\DeclareFontShape{OT1}{cmss}{bx}{n}{%
	<-6> s* [1.056000]cmssbx5%
	<6-7> s* [1.056000]cmssbx6%
	<7-8> s* [1.056000]cmssbx7%
	<8-9> s* [1.056000]cmssbx8%
	<9-> s* [1.056000]cmssbx10}{}
\DeclareFontShape{OT1}{cmss}{bx}{ui}{%
	<->sub*cmr/bx/ui}{}
%ot1cmtt.fd
\DeclareFontShape{OT1}{cmtt}{m}{n}{%
	<-> s* [1.056000]cmtt10}{}
\DeclareFontShape{OT1}{cmtt}{m}{it}{%
	<-> s* [1.056000]cmitt10}{}
\DeclareFontShape{OT1}{cmtt}{m}{sl}{%
	<-> s* [1.056000]cmsltt10}{}
\DeclareFontShape{OT1}{cmtt}{m}{sc}{%
	<-> s* [1.056000]cmtcsc10}{}
%\ProvidesFile{omlcmm.fd}[1998/03/27 v2.5g Standard LaTeX font definitions]
%\DeclareFontFamily{OML}{cmm}{\skewchar\font127 }
\DeclareFontShape{OML}{cmm}{m}{it}%
     {%
    <-6> s*  [1.056000]cmmi5%
    <6-7> s*  [1.056000]cmmi6%
    <7-8> s*  [1.056000]cmmi7%
    <8-9> s*  [1.056000]cmmi8%
    <9-10> s*  [1.056000]cmmi9%
    <10-12> s*  [1.056000]cmmi10%
    <12-> s*  [1.056000]cmmi12%
      }{}
\DeclareFontShape{OML}{cmm}{b}{it}{%
    <-6> s*  [1.056000]cmmib5%
    <6-7> s*  [1.056000]cmmib6%
    <7-8> s*  [1.056000]cmmib8%
    <8-9> s*  [1.056000]cmmib9%
    <9-10> s*  [1.056000]cmmib9%
    <10-> s*  [1.056000]cmmib10%
}{}
\DeclareFontShape{OML}{cmm}{bx}{it}%
   {<->ssub*cmm/b/it}{}
%%%%%%%%%%%%%%%%%%%%%%%
\endgroup

% \@@marginparwidthというのが\marginparwidthに代入されますが，同時に
% \marginparwidthの手動指定のフラグになってます．この値が0pt以上になっていると
% それが\marginparwidthの長さになります．初期値は0ptにして，
% 変更はsimplesetting.styで行います．
% simplesetting.sty側でも0pt（もしくは無指定）にしていると\marginparwidthは
% \evensidemarginの長さの0.8倍になるようにしました．
\newdimen\@@marginparwidth
\@@marginparwidth\z@

%LaTeX2.09時代のフォント指定の定義です．
\DeclareOldFontCommand{\mc}{\normalfont\mcfamily}{\mathmc}
\DeclareOldFontCommand{\gt}{\normalfont\gtfamily}{\mathgt}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*{\cal}{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*{\mit}{\@fontswitch\relax\mathnormal}

% 基本体裁簡易設定用のパラメータです．
% [config]絡みの条件分岐の宣言です．
\newif\if@KB@ten@@ \@KB@ten@@false
\newif\if@KB@hasira@@ \@KB@hasira@@false
\newif\if@KB@nonble@@ \@KB@nonble@@false
\if@@config@
% simplesetting.styで基本体裁を設定するときのパラメータを代入するマクロです．
% 日本語を使ってとっつきやすくしてます．
	\def\本文サイズ#1{\setlength{\@@normalsize}{#1}\def\Char@screenout{#1}}
	\def\行送り#1{\setlength{\@@normalsize@@baseline}{#1}\def\BS@screenout{#1}}
	\def\左右#1{\gdef\KBtext@@width@@{#1}\def\TW@screenout{#1}}
	\def\天地#1{\gdef\KBtext@@height@@{#1}\def\TH@screenout{#1}}
	\def\小口#1{\@Koguchitrue\gdef\@Koguchi{#1}\def\Side@screenout{#1}}
	\def\天#1{\@KB@ten@@true\gdef\@Top@Margin@@{#1}\def\TM@screenout{#1}}
	\def\柱#1#2{\@KB@hasira@@true\gdef\@Header@@{\fontsize{#1}{#1}\selectfont#2}\def\Head@screenout{#1}}
	\def\ノンブル#1#2{\@KB@nonble@@true\gdef\Nomble@@{\fontsize{#1}{#1}\selectfont#2}\def\Pnum@screenout{#1}}
% simplesetting.styを読み込み，その後設定された情報を各パラメータにセットします．
% \if@keepfline@@は前述のページ先頭第一行目に背の高い文字がきたときのための措置ですが，原則falseです．
	\input{simplesetting.sty}
	\setlength\textwidth{\@@normalsize}
	\multiply\textwidth \KBtext@@width@@
	\setlength\textheight{\@@normalsize@@baseline}
	\multiply\textheight \KBtext@@height@@
	\advance\textheight by-\@@normalsize@@baseline
	\if@keepfline@@
		\topskip\@@normalsize@@baseline
	\else
		\setbox\z@\hbox{\fontsize{\@@normalsize}{\z@}\selectfont\char\euc"A1A1}%
		\setlength\topskip{\ht\z@}
		\setlength\topskip{\@jqscale\topskip}
	\fi
	\advance\textheight by\topskip
\if@KB@nonble@@
	\renewcommand{\KBpagenumfont}{\reset@font\Nomble@@}
\fi
\if@KB@hasira@@
	\renewcommand{\KBheaderfont}{\reset@font\@Header@@}
\fi

% 本質ではありませんが，コンパイルの終了間際にsimpltysetting.styで記述した
% 内容を吐き出すようにしてみました．あくまで確認用です．
\def\@screen@out@msg{未設定}
\def\option@screen@out@side{\@screen@out@msg}
\def\option@screen@out@head{\@screen@out@msg}
\def\option@screen@out@Nonble{\@screen@out@msg}
\def\option@screen@out@top{\@screen@out@msg}

\if@Koguchi
	\def\option@screen@out@side{\Side@screenout}
\fi
\if@KB@hasira@@
	\def\option@screen@out@head{\Head@screenout}
\fi
\if@KB@ten@@
	\def\option@screen@out@top{\TM@screenout}
\fi
\if@KB@nonble@@
	\def\option@screen@out@Nonble{\Pnum@screenout}
\fi
%\AtEndDocument{%
%\def\@@font@size@info@@#1{#1\setbox0=\hbox{あ}\@tempdima=\wd0
%\typeout{fontsizeinfo ---- \string#1 = \the\@tempdima}%
%}
%\@@font@size@info@@{\tiny}
%\@@font@size@info@@{\scriptsize}
%\@@font@size@info@@{\footnotesize}
%\@@font@size@info@@{\small}
%\@@font@size@info@@{\normalsize}
%\@@font@size@info@@{\large}
%\@@font@size@info@@{\Large}
%\@@font@size@info@@{\LARGE}
%\@@font@size@info@@{\huge}
%\@@font@size@info@@{\Huge}
%\@@font@size@info@@{\HUGE}
%\typeout{^^J本文サイズ ----> \Char@screenout^^J行送り --------> \BS@screenout^^J左右 ----------> \TW@screenout 倍^^J天地 ----------> \TH@screenout 行^^J小口 ----------> \option@screen@out@side^^J天 ------------> \option@screen@out@top^^J柱 ------------> \option@screen@out@head^^Jノンブル ------> \option@screen@out@Nonble^^J}
%}
\fi

% \sffamilyとttfamilyで従属和文をゴシックにするようにしています．
% jsbookに準拠です．
\DeclareRobustCommand\sffamily
        {\not@math@alphabet\sffamily\mathsf
         \romanfamily\sfdefault\kanjifamily\gtdefault\selectfont}
\DeclareRobustCommand\ttfamily
        {\not@math@alphabet\ttfamily\mathtt
         \romanfamily\ttdefault\kanjifamily\gtdefault\selectfont}
\if@BfSf
     \DeclareRobustCommand*{\bfs}
        {\not@math@alphabet\bfs\relax
	\kanjifamily\gtdefault\romanfamily\sfdefault\selectfont}
% \bfsはデフォルトでは\rmfamily\bfseries+\gtfamilyにしていますが，
% クラスオプションgtsfを指定すると\sffamily+\gtfamily になります．
% ここで\sffamilyを再定義して和文ゴシックと連動させるようにしています．
%-------
% *下の行をアクティブにすれば，\bfsに関わらず\bfseries以下\bf，\textbfで\sffamily+\gtfamilyになります．
% その場合で注意が必要なのは数式で，数式中で\textbfを用いると\sffamilyなり，\bfを
% 使うとboldが出力されます．(つまり数式中でboldを使いたい場合は\bfが必要です)
% ただし，本来数式中では\mathbfや\mathsfなどのコマンドを使うべきではあります．
%     \DeclareRobustCommand\bfseries
%        {\not@math@alphabet\bfseries\mathbf
%        \kanjifamily\gtdefault\romanfamily\sfdefault\selectfont}
\fi

% オリジナルの定義を保存した後，設定した文字サイズと
% それぞれの行送りを\strip@ptし，文字サイズ数値として定義します．
% これにより，\@xpt=10ptなどといったローマ数字でポイントを表す
% 表記は形骸化します．
\if@fomersize
 \edef\@vpt{\strip@pt\@@tiny}
 \edef\@viipt{\strip@pt\@@scriptsize}
 \edef\@viiipt{\strip@pt\@@footnotesize}
 \edef\@ixpt{\strip@pt\@@small}
 \edef\@xpt{\strip@pt\@@normalsize}
 \edef\@xipt{\strip@pt\@@large}
 \edef\@xiipt{\strip@pt\@@Large}
 \edef\@xivpt{\strip@pt\@@LARGE}
 \edef\@xviipt{\strip@pt\@@huge}
 \edef\@xxpt{\strip@pt\@@Huge}
 \edef\@xxvpt{\strip@pt\@@HUGE}
\fi
\edef\@tiny@@base@@line{\strip@pt\@@tiny@@baseline}
\edef\@scriptsize@@base@@line{\strip@pt\@@scriptsize@@baseline}
\edef\@footnotesize@@base@@line{\strip@pt\@@footnotesize@@baseline}
\edef\@small@@base@@line{\strip@pt\@@small@@baseline}
\edef\@normalsize@@base@@line{\strip@pt\@@normalsize@@baseline}
\edef\@large@@base@@line{\strip@pt\@@large@@baseline}
\edef\@Large@@base@@line{\strip@pt\@@Large@@baseline}
\edef\@LARGE@@base@@line{\strip@pt\@@LARGE@@baseline}
\edef\@huge@@base@@line{\strip@pt\@@huge@@baseline}
\edef\@Huge@@base@@line{\strip@pt\@@Huge@@baseline}
\edef\@HUGE@@base@@line{\strip@pt\@@HUGE@@baseline}


% 数式の添字の指定です．\sMathSizesというマクロで親文字に対しての縮小値を計算して，\DeclareMathSizesに渡します．なので引数には縮小率を指定します．
\def\sMathSizes#1#2#3#4{\dimen@ #2\p@
\@tempdima #3\dimen@
\@tempdimb #4\dimen@
\expandafter\edef\csname sc#1\endcsname{\strip@pt\@tempdima}
\expandafter\edef\csname scsc#1\endcsname{\strip@pt\@tempdimb}
\DeclareMathSizes{#1}{#2}{\csname sc#1\endcsname}{\csname scsc#1\endcsname}
}
% まずは既存定義の再設定
 \sMathSizes{\s@vpt}{\s@vpt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\s@ivpt}{\s@ivpt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\s@viipt}{\s@viipt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\s@viiipt}{\s@viiipt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\s@ixpt}{\s@ixpt}{.7}{.5}
 \sMathSizes{\s@xpt}{\s@xpt}{.7}{.5}
 \sMathSizes{\s@xipt}{\s@xipt}{.7}{.5}
 \sMathSizes{\s@xiipt}{\s@xiipt}{.7}{.5}
 \sMathSizes{\s@xivpt}{\s@xivpt}{.7}{.5}
 \sMathSizes{\s@xviipt}{\s@xviipt}{.7}{.5}
 \sMathSizes{\s@xxpt}{\s@xxpt}
	{\default@Huge@scriptratio}{\default@Huge@scriptscriptratio}

% ここで\@@normalsizeなどへの設定
 \sMathSizes{\@vpt}{\@vpt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\@viipt}{\@viipt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\@viiipt}{\@viiipt}
	{\default@tiny@scriptratio}{\default@tiny@scriptscriptratio}
 \sMathSizes{\@ixpt}{\@ixpt}
	{.7}{.5}
 \sMathSizes{\@xpt}{\@xpt}
	{.7}{.5}
 \sMathSizes{\@xipt}{\@xipt}
	{.7}{.5}
 \sMathSizes{\@xiipt}{\@xiipt}
	{.7}{.5}
 \sMathSizes{\@xivpt}{\@xivpt}
	{.7}{.5}
 \sMathSizes{\@xviipt}{\@xviipt}
	{.7}{.5}
 \sMathSizes{\@xxpt}{\@xxpt}
	{\default@Huge@scriptratio}{\default@Huge@scriptscriptratio}

% 使用するjtfmをjis系にします．
% 現在では使うことは極めて稀であろうとは思いますが
% クラスオプションmin10で旧来のmin10.tfmが使えます．
%%%%%%%%%%%%%%%%%%%%%%%%%%%
\if@JisTFM
\def\JfontTfmM{jis}\def\JfontTfmG{jisg}
\def\JfontTfmMsl{Ryumin-Light-s}\def\JfontTfmGsl{GothicBBB-Medium-s}
\def\JfontTfmMsl{jis}\def\JfontTfmGsl{jisg}
\typeout{%
--------------^^J%
JFM=jistfm.tfm^^J%
--------------}
\else
\def\JfontTfmM{min10}\def\JfontTfmG{goth10}
\def\JfontTfmMsl{min10}\def\JfontTfmGsl{goth10}
\typeout{%
-------------^^J
JFM=min10.tfm^^J%
-------------}
\fi
\DeclareKanjiFamily{JY1}{mrml}{}
\DeclareKanjiFamily{JT1}{mrml}{}
\DeclareFontShape{JY1}{mrml}{m}{n}{<-> s *  [\@jqscale] \JfontTfmM}{}
%\DeclareFontShape{JY1}{mrml}{m}{sl}{<-> s * [\@jqscale] \JfontTfmMsl}{}
\DeclareFontShape{JY1}{mrml}{bx}{n}{<-> s *  [\@jqscale] \JfontTfmG}{}
%\DeclareFontShape{JY1}{mrml}{bx}{sl}{<-> s * [\@jqscale] \JfontTfmGsl}{}
\DeclareFontShape{JT1}{mrml}{m}{n}{<-> s *  [\@jqscale] tmin10}{}
\DeclareFontShape{JT1}{mrml}{bx}{n}{<-> s *  [\@jqscale] tgoth10}{}

\DeclareKanjiFamily{JY1}{mgbm}{}
\DeclareKanjiFamily{JT1}{mgbm}{}
\DeclareFontShape{JY1}{mgbm}{m}{n}{<-> s *  [\@jqscale] \JfontTfmG}{}
\DeclareFontShape{JY1}{mgbm}{bx}{n}{<-> s *  [\@jqscale] \JfontTfmG}{}
%\DeclareFontShape{JY1}{mgbm}{m}{sl}{<-> s * [\@jqscale] \JfontTfmGsl}{}
%\DeclareFontShape{JY1}{mgbm}{bx}{sl}{<-> s * [\@jqscale] \JfontTfmGsl}{}
\DeclareFontShape{JT1}{mgbm}{m}{n}{<-> s *  [\@jqscale] tgoth10}{}
\DeclareFontShape{JT1}{mgbm}{bx}{n}{<-> s *  [\@jqscale] tgoth10}{}

\renewcommand{\mcdefault}{mrml}
\renewcommand{\gtdefault}{mgbm}
% New-CIDによる多書体用の設定を読み込みます．
% クラスオプションcidで読まれます．
% ^*実際の運用には各tfm, vfファイル，それに応じて設定されたdvips用のmapファイルが必要です．
\if@PsJfont
\input cid.sty
\fi



%\DeclareMathSizes{\@xpt}{\@xpt}{6}{5}


%\def\xDeclareMathSizes#1#2#3#4{%
%   \let\@tempa\@empty
%   \@tfor\@tempb:={#1}{#2}{#3}{#4}\do{%
%      \@defaultunits\dimen@\@tempb pt\relax\@nnil
%      \edef\@tempa{\@tempa{\strip@pt\dimen@}}}%
%   \expandafter\DeclareMathSizes\@tempa}

%\scriptscale\dimen@

%\xDeclareMathSizes{\@viipt}{\@viipt}{\@viipt}{\@viipt}
%\xDeclareMathSizes{\@viiipt}{\@viiipt}{\@scriptscale}{\@scriptscale}
%\DeclareMathSizes{\@ixpt}{{\@ixpt}{}{}
%\DeclareMathSizes{\@xpt}{\@xpt}{}{}
%\DeclareMathSizes{\@xipt}{\@xipt}{}{}
%\DeclareMathSizes{\@xiipt}{{\@xiipt}{}{}
%\DeclareMathSizes{\@xivpt}{\@xivpt}{}{}
%\DeclareMathSizes{\@xviipt}{{\@xviipt}{}{}
%\DeclareMathSizes{\@xxpt}{\@xxpt}{}{}

% 各サイズコマンドの設定です．
% たとえば\normalsizeの場合，\@xptと\@normalsize@@base@@lineは事前に
% \strip@ptされたものをここで使います．
\DeclareRobustCommand{\normalsize}{%
\@setfontsize\normalsize\@xpt{\@normalsize@@base@@line}%
\abovedisplayskip 10\p@ \@plus2\p@ \@minus5\p@%
\abovedisplayshortskip \z@ \@plus3\p@%
\belowdisplayshortskip 6\p@ \@plus3\p@ \@minus3\p@%
\belowdisplayskip \abovedisplayskip%
%%%%%
\let\@listi\@listI
}

\normalfont\normalsize
\setbox0\hbox{\char\euc"A1A1}%
\setlength\Cht{\ht0}
\setlength\Cdp{\dp0}
\setlength\Cwd{\wd0}
\setlength\Cvs{\baselineskip}
\setlength\Chs{\wd0}
\setlength\parindent{1\Cwd}
\kanjiskip=0zw plus .1zw minus .01zw
\xkanjiskip0.2zw plus 0.1zw minus 0.06zw
\DeclareRobustCommand{\small}{%
  \@setfontsize\small\@ixpt{\@small@@base@@line}%
\abovedisplayskip 8.5\p@ \@plus3\p@ \@minus4\p@
\abovedisplayshortskip \z@ \@plus2\p@
\belowdisplayshortskip 4\p@ \@plus2\p@ \@minus2\p@
\def\@listi{\leftmargin\leftmargini\labelwidth\leftmargini\advance\labelwidth-\labelsep\topsep.5\baselineskip\parsep\z@\itemsep\parsep}%
\belowdisplayskip \abovedisplayskip}

\DeclareRobustCommand{\footnotesize}{%
\@setfontsize\footnotesize\@viiipt{\@footnotesize@@base@@line}%
\abovedisplayskip 6\p@ \@plus2\p@ \@minus4\p@
\abovedisplayshortskip \z@ \@plus\p@
\belowdisplayshortskip 3\p@ \@plus\p@ \@minus2\p@
\def\@listi{\leftmargin\leftmargini\labelwidth\leftmargini\advance\labelwidth-\labelsep\topsep.5\baselineskip\parsep\z@\itemsep\parsep}%
\belowdisplayskip \abovedisplayskip}
\DeclareRobustCommand{\scriptsize}{\@setfontsize\scriptsize\@viipt\@scriptsize@@base@@line}
\DeclareRobustCommand{\tiny}{\@setfontsize\tiny\@vpt\@tiny@@base@@line}
\DeclareRobustCommand{\large}{\@setfontsize\large\@xipt{\@large@@base@@line}}
\DeclareRobustCommand{\Large}{\@setfontsize\Large\@xiipt{\@Large@@base@@line}}
\DeclareRobustCommand{\LARGE}{\@setfontsize\LARGE\@xivpt{\@LARGE@@base@@line}}
\DeclareRobustCommand{\huge}{\@setfontsize\huge\@xviipt{\@huge@@base@@line}}
\DeclareRobustCommand{\Huge}{\@setfontsize\Huge\@xxpt{\@Huge@@base@@line}}
\DeclareRobustCommand{\HUGE}{\@setfontsize\HUGE\@xxvpt{\@HUGE@@base@@line}}

% \headheightの高さを算出します．
% ノンブルと柱で違う文字サイズが設定されることもあるので，
% 大きいほうの高さを\headheightとして設定します．
\setbox\z@\hbox{\KBheaderfont\char\euc"A1A1}%
\setbox\tw@\hbox{\KBpagenumfont1}%
\ifdim\ht\z@>\ht\tw@\@tempdima\ht\z@\else\@tempdima\ht\tw@\fi
\headheight\@tempdima
\headsep4mm
% (たとえば\displatystyle\fracなど)ページの第一行目に背の高い文字が来ても行が出来るだけ下にずれないための処置です．そのままでは判面天地位置がおかしくなるので，\headsepで補正しつつ，\topmarginの算出方法を変えました．<- 試験的に設定しましたが，\sectionなどでも版面を天方向に飛び出してしまうので止めています．せっかくなのでクラスオプション[keepfline]で\@keepfline@@trueが有効になる設定は残しています．
\if@keepfline@@
	\setlength\topskip{\baselineskip}
	\advance\headsep by-\topskip
	\advance\headsep by\Cht
\else
	\setlength\topskip{\Cht}
\fi
%%%
\setlength\footskip{.35in}
\setlength\maxdepth{.5\topskip}
\setlength\marginparsep{.5zw}

%%%%%%%%%%%%%%%
% \@@evensidemarginは\marginparwidthを決めるための保存用です．
% \marginparwidthは\marginparsepを引いた\evensidemarginの0.8倍にしてます．
% \小口の指定がある場合も\marginparsepを引いた0.8倍です．
\newdimen\@@evensidemargin
\setlength\columnsep{2zw}
\columnseprule\z@
\setlength\oddsidemargin{\paperwidth}\advance\oddsidemargin-\textwidth
\setlength\evensidemargin{.5\oddsidemargin}
\setlength\oddsidemargin{\evensidemargin}
\setlength\@@evensidemargin{\evensidemargin}
\setlength{\topmargin}{\paperheight}
\advance\topmargin by-\textheight
\setlength{\topmargin}{.5\topmargin}
\advance\topmargin by-\headsep
\advance\topmargin by-\headheight
%\advance\topmargin by-\topskip
%\advance\topmargin by\Cht
\advance\topmargin-1in
\advance\oddsidemargin-1in
\advance\evensidemargin-1in

%%%%%
\setlength\footnotesep{6.65\p@}
%\setlength{\skip\footins}{9\p@ \@plus 4\p@ \@minus 2\p@}
\setlength{\skip\footins}{12\p@ \@plus 4\p@ \@minus 2\p@}
\setlength\floatsep    {12pt \@plus0pt \@minus2pt}%  209版 ky_a5.sty 準拠
\setlength\textfloatsep{15.5pt \@plus0pt \@minus2pt}% 209版 ky_a5.sty 準拠
\setlength\intextsep   {11pt \@plus0pt \@minus2pt}% 209版 ky_.sty 準拠
\setlength\dblfloatsep    {12\p@ \@plus 2\p@ \@minus 2\p@}
\setlength\dbltextfloatsep{20\p@ \@plus 2\p@ \@minus 4\p@}
\setlength\@fptop{0\p@ \@plus 1fil}
\setlength\@fpsep{8\p@ \@plus 2fil}
\setlength\@fpbot{0\p@ \@plus 1fil}
\setlength\@dblfptop{0\p@ \@plus 1fil}
\setlength\@dblfpsep{8\p@ \@plus 2fil}
\setlength\@dblfpbot{0\p@ \@plus 1fil}
%\setlength\partopsep{2\p@ \@plus 1\p@ \@minus 1\p@}
\setlength\partopsep{\z@}%% ここを.5\baselineskipなどとするとlist系の直前で空行の有り無しでアキをコントロールできます．

% 一番外側のlistだけ本文とのアキを.5\baselineskip空けます．二段目以降のlistは親のlistに対してアキは設けません．
\def\@listi{\leftmargin\leftmargini\labelwidth\leftmargini\advance\labelwidth-\labelsep\parsep\z@\topsep.5\normalbaselineskip\itemsep\z@}
\let\@listI\@listi
\@listi
\def\@listii{\leftmargin\leftmarginii\labelwidth\leftmarginii\advance\labelwidth-\labelsep\topsep\z@\parsep\z@\itemsep\parsep}
\def\@listiii{\leftmargin\leftmarginiii
   \labelwidth\leftmarginiii \advance\labelwidth-\labelsep\topsep\z@\parsep\z@
   \partopsep\z@\itemsep\topsep}
\def\@listiv {\leftmargin\leftmarginiv
              \labelwidth\leftmarginiv
              \advance\labelwidth-\labelsep}
\def\@listv  {\leftmargin\leftmarginv
              \labelwidth\leftmarginv
              \advance\labelwidth-\labelsep}
\def\@listvi {\leftmargin\leftmarginvi
              \labelwidth\leftmarginvi
              \advance\labelwidth-\labelsep}
\lineskip1\p@
\setlength\normallineskip{1\p@}
\setlength\lineskiplimit{1\p@}
\setlength\normallineskiplimit{1\p@}
%%%
\renewcommand{\baselinestretch}{}
\setlength\parskip{\z@}
\setlength\parindent{1\Cwd}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\setcounter{bottomnumber}{1}
\setcounter{totalnumber}{3}
\setcounter{dbltopnumber}{2}
\renewcommand{\topfraction}{.7}
\renewcommand{\bottomfraction}{.3}
\renewcommand{\textfraction}{.2}
\renewcommand{\floatpagefraction}{.5}
\renewcommand{\dbltopfraction}{.7}
\renewcommand{\dblfloatpagefraction}{.5}

\def\ps@plain{\let\@mkboth\@gobbletwo
   \let\ps@jpl@in\ps@plain
   \def\@oddhead{\KBpagenumfont\hfil\thepage}
   \let\@oddfoot\@empty%
   \def\@evenhead{\KBpagenumfont{\thepage}\hfil}
   \let\@evenfoot\@empty}

\let\ps@jpl@in\ps@plain

\def\ps@headnombre{\let\@mkboth\@gobbletwo
    \let\ps@jpl@in\ps@headnombre
  \def\@evenhead{\KBpagenumfont\thepage\hfil}%
  \def\@oddhead{\hfil\KBpagenumfont\thepage}%
  \let\@oddfoot\@empty\let\@evenfoot\@empty}

%\def\ps@footnombre{\let\@mkboth\@gobbletwo
%    \let\ps@jpl@in\ps@footnombre
%  \def\@evenfoot{\KBpagenumfont\thepage\hfil}%
%  \def\@oddfoot{\hfil\KBpagenumfont\thepage}%
%  \let\@oddhead\@empty\let\@evenhead\@empty}

% 各headerに約物の行頭パターン処理を追加しました．
  \def\ps@footnombre{\let\ps@jpl@in\ps@footnombre
    \let\@evenhead\@empty
    \let\@oddhead\@empty
    \def\@oddfoot{\KBpagenumfont\thepage\hskip1.5zw\KBheaderfont\rightmark\hfil}%
    \def\@evenfoot{\KBheaderfont\hfil{\leftmark}\KBpagenumfont\hskip1.5zw\thepage}%
    \def\@evenfoot{\KBpagenumfont\thepage\hskip1.5zw\KBheaderfont\leftmark\hfill}%
    \def\@oddfoot{\hfill\KBheaderfont{\rightmark}\KBpagenumfont\hskip1.5zw\thepage}%
    \let\@mkboth\markboth
  \def\chaptermark##1{\markboth{%
     \ifnum \c@secnumdepth >\m@ne
         \if@mainmatter
         \@chapapp\thechapter\@chappos\hskip1zw%
         \fi
     \fi
     ##1}{}}%
  \def\sectionmark##1{\markright{%
     \ifnum \c@secnumdepth >\z@ \thesection\hskip1zw\fi
     ##1}}%
  }\if@twoside
  \def\ps@headings{\let\ps@jpl@in\ps@headnombre
    \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\KBpagenumfont\thepage\hskip1.5zw\KBheaderfont\leftmark\hfil}%
    \def\@oddhead{\KBheaderfont\hfil{\rightmark}\KBpagenumfont\hskip1.5zw\thepage}%
    \let\@mkboth\markboth
  \def\chaptermark##1{\markboth{%
     \ifnum \c@secnumdepth >\m@ne
         \if@mainmatter
         \@chapapp\thechapter\@chappos\hskip1zw
         \fi
     \fi
     \protect\@inhibitglue##1}{}}%
  \def\sectionmark##1{\markright{%
     \ifnum \c@secnumdepth >\z@ \thesection\hskip1zw\fi
     \protect\@inhibitglue##1}}%
  }
\else % if not twoside
  \def\ps@headings{\let\ps@jpl@in\ps@headnombre
    \let\@oddfoot\@empty
    \def\@oddhead{\KBpagenumfont\thepage\hskip1.5zw\leftmark\hfil}%
    \let\@mkboth\markboth
\def\chaptermark##1{\markright{%
   \ifnum \c@secnumdepth >\m@ne
         \if@mainmatter
       \@chapapp\thechapter\@chappos\hskip1zw
         \fi
   \fi
   \protect\@inhibitglue##1}}%
  }
\fi
\if@twoside
  \def\ps@bothstyle{\let\ps@jpl@in\ps@footnombre
    \def\@evenhead{\KBheaderfont\leftmark\hfil}% right page
    \def\@evenfoot{\KBheaderfont\thepage\hfil}% right page
    \def\@oddhead{\KBheaderfont\hfil\rightmark}% left page
    \def\@oddfoot{\KBheaderfont\hfil\thepage}% left page
  \let\@mkboth\markboth
\def\chaptermark##1{\markboth{%
     \ifnum \c@secnumdepth >\m@ne
         \if@mainmatter
         \@chapapp\thechapter\@chappos\hskip1zw
         \fi
     \fi
     \protect\@inhibitglue##1}{}}%
  \def\sectionmark##1{\markright{%
     \ifnum \c@secnumdepth >\z@ \thesection\hskip1zw\fi
     \protect\@inhibitglue##1}}%
  }
\else % if one column
  \def\ps@bothstyle{\let\ps@jpl@in\ps@footnombre
    \def\@oddhead{\KBheaderfont\hfil\rightmark}%
    \def\@oddfoot{\KBheaderfont\hfil\thepage}%
    \let\@mkboth\markboth
  \def\chaptermark##1{\markright{%
     \ifnum \c@secnumdepth >\m@ne
         \if@mainmatter
         \@chapapp\thechapter\@chappos\hskip1zw
         \fi
     \fi
     \protect\@inhibitglue##1}}%
  }
\fi
\def\ps@myheadings{\let\ps@jpl@in\ps@plain%
  \let\@oddfoot\@empty\let\@evenfoot\@empty
    \def\@evenhead{\KBpagenumfont\thepage\hskip1.5zw\KBheaderfont\leftmark\hfil}%
    \def\@oddhead{\KBheaderfont\hfil{\rightmark}\KBpagenumfont\hskip1.5zw\thepage}%
  \let\@mkboth\@gobbletwo
  \let\chaptermark\@gobble
  \let\sectionmark\@gobble
}
\newenvironment{titlepage}
    {%
      \cleardoublepage
      \if@twocolumn
        \@restonecoltrue\onecolumn
      \else
        \@restonecolfalse\newpage
      \fi
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\if@restonecol\twocolumn \else \newpage \fi
     \if@twoside\else
        \setcounter{page}\@ne
     \fi
    }

% \maketitleでの出力に`Publisher'が入るようにしました．
% \publisherで指定されていれば，それが優先されて出力されます．
% `Publisher'を印字させたくなければ，\publisher{}と引数を空にします．
% \authorで使われる\andも`中黒'で区切るようにしています．
% また，\titleに[]オプションで副題を入れられるようにしました．
% \title[副題]{タイトル}となります．

\def\title{\@ifnextchar[{\title@}{\title@[\hbox{}]}}
\def\title@[#1]#2{\gdef\@title{\begin{tabular}{c}#2\\
\Large#1\end{tabular}}}
\def\publisher#1{\gdef\@publisher{#1}}
\def\p@thanks#1{\footnotemark
  \protected@xdef\@thanks{\@thanks
    \protect{\noindent$\m@th^\thefootnote$~#1\protect\par}}}
\def\and{%                  % \begin{tabular}
  \end{tabular}%
  ・
  \begin{tabular}[t]{@{}c@{}}\normalsize}%   % \end{tabular}
\if@titlepage
  \newcommand{\maketitle}{\begin{titlepage}%
  \let\footnotesize\small
  \let\footnoterule\relax
  \let\footnote\thanks
  \null\vfil
  \vskip 150\p@
  \begin{center}%
    {\Huge \@title \par}%
    \vskip 4em%
    {\Large
     \lineskip .75em%
      \begin{tabular}[t]{@{}c@{}}\normalsize%
        \@author
      \end{tabular}\par}%
      \vskip 4\baselineskip%
    {\large \@date} \par%       % Set date in \large size.
\vfill
{\bfs\@publisher}
  \end{center}\par
  \@thanks\vfil\null
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\p@thanks\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\@publisher\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  \global\let\publisher\relax
  }%
\else
  \newcommand{\maketitle}{\par
  \begingroup
    \renewcommand{\thefootnote}{\fnsymbol{footnote}}%
    \def\@makefnmark{\hbox{\ifydir $\m@th^{\@thefnmark}$
      \else\hbox{\yoko$\m@th^{\@thefnmark}$}\fi}}%
     \long\def\@makefntext##1{\parindent 1em\noindent
       \hbox to1.8em{\hss$\m@th^{\@thefnmark}$}##1}%
    \if@twocolumn
      \ifnum \col@number=\@ne \@maketitle
      \else \twocolumn[\@maketitle]%
      \fi
    \else
      \newpage
      \global\@topnum\z@   % Prevents figures from going at top of page.
      \@maketitle
    \fi
     \thispagestyle{jpl@in}\@thanks
  \endgroup
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\p@thanks\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  }
  \def\@maketitle{%
  \newpage\null
  \vskip 2em%
  \begin{center}%
  \let\footnote\thanks
    {\LARGE \@title \par}%
    \vskip 1.5em%
    {\large
      \lineskip .5em%
      \begin{tabular}[t]{c}%
        \@author
      \end{tabular}\par}%
    \vskip 1em%
    {\large \@date}%
  \end{center}%
  \par\vskip 1.5em}
\fi
\newcommand*{\chaptermark}[1]{}
\setcounter{secnumdepth}{2}
\newcounter{part}
\newcounter{chapter}
\newcounter{section}[chapter]
\newcounter{subsection}[section]
\newcounter{subsubsection}[subsection]
\newcounter{paragraph}[subsubsection]
\newcounter{subparagraph}[paragraph]
\renewcommand{\thepart}{\@Roman\c@part}
\renewcommand{\thechapter}{\@arabic\c@chapter}
\renewcommand{\thesection}{\thechapter.\@arabic\c@section}
\renewcommand{\thesubsection}{\thesection.\@arabic\c@subsection}
\renewcommand{\thesubsubsection}{%
   \thesubsection.\@arabic\c@subsubsection}
\renewcommand{\theparagraph}{%
   \thesubsubsection.\@arabic\c@paragraph}
\renewcommand{\thesubparagraph}{%
   \theparagraph.\@arabic\c@subparagraph}
\newcommand{\@chapapp}{\prechaptername}
\newcommand{\@chappos}{\postchaptername}
\newcommand\frontmatter{%
  \if@openright \cleardoublepage \else \clearpage \fi
  \@mainmatterfalse\pagenumbering{roman}}
\newcommand{\mainmatter}{%
  \if@openright \cleardoublepage \else \clearpage \fi
  \@mainmattertrue\pagenumbering{arabic}}
\newcommand{\backmatter}{%
  \if@openright \cleardoublepage \else \clearpage \fi
  \@mainmatterfalse}
\newcommand{\part}{%
  \if@openright \cleardoublepage \else \clearpage \fi
%  \cleardoublepage
  \thispagestyle{empty}%
  \if@twocolumn\onecolumn\@tempswatrue\else\@tempswafalse\fi
  \null\vfil
  \secdef\@part\@spart}
\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{%
       \protect\numberline{\prepartname\thepart\postpartname}#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \markboth{}{}%
  {\centering
   \interlinepenalty\@M\reset@font
   \ifnum \c@secnumdepth >-2\relax
     \KBpartnumfont\prepartname\thepart\postpartname
     \par\vskip20\p@
   \fi
   \KBpartfont#2\par}%
   \@endpart}
\def\@spart#1{{%
  \centering
  \interlinepenalty\@M\reset@font
  \Huge\bfs#1\par}%
  \@endpart}
\def\@endpart{\vfil\newpage
   \if@twoside\null\thispagestyle{empty}\newpage\fi
   \if@tempswa\twocolumn\fi}
% \chapterに約物の行頭処理を追加しました．
\newcommand{\chapter}{%
  \if@openright\cleardoublepage\else\clearpage\fi
  \thispagestyle{empty}%
  \global\@topnum\z@
%  \@afterindentfalse
  \@afterindenttrue
  \secdef\@chapter\@schapter}
% multicite.styで使う\@ref@prefixを追加しています．
\def\@chapter[#1]#2{%
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
    \refstepcounter{chapter}%
    \xdef\@ref@prefix{\thechapter::}% for multicite.sty
    \typeout{\@chapapp\space\thechapter\space\@chappos}%
    \addcontentsline{toc}{chapter}%
      {\protect\numberline{\@chapapp\thechapter\@chappos}#1}%
    \else\addcontentsline{toc}{chapter}{#1}\fi
  \else
    \addcontentsline{toc}{chapter}{#1}%
  \fi
  \chaptermark{#1}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makechapterhead{#2}\@afterheading}
%%%%%%
\def\@makechapterhead#1{{\parindent\z@%%\interlinepenalty\@M%
\toplinebox{5}{% 10行取りにしています．%5に変更
   \raggedright
   \KBchapternumfont
   \ifnum \c@secnumdepth >\m@ne
     \setlength\@tempdima{\linewidth}%
    \if@mainmatter
      \@chapapp\thechapter\@chappos
     \else
      \hbox{}
    \fi
     \vspace{.9\Cvs}\par
     \KBchapterfont\@inhibitglue#1\vfil\fi}}%
}

\def\@schapter#1{%
  \@makeschapterhead{#1}\@afterheading
}

\def\@makeschapterhead#1{{\parindent\z@%%\interlinepenalty\@M%
\toplinebox{5}{% 10行取りにしています．%５に変更
     \centerline{\KBchapterfont\@inhibitglue#1}\vfil}
   }}



% 吉永徹美氏例示マクロを元に作成
% \section以下の節番号の位置に装飾文字やマクロを置けるようにします．
% ここでは，節番号の書体指定を入れています．
\def\@seccntformat#1{% #1: <counter name>
\csname @seccnt@prefix@#1\endcsname%
\csname the#1\endcsname%
\csname @seccnt@postfix@#1\endcsname%
\csname @seccnt@afterskip@#1\endcsname}
% \def\@seccntformat#1{\csname the#1\endcsname\quad}
% \@seccnt@<POSITION>@<SECTIONNAME>
\def\@seccnt@post@skip{\hskip1zw}
\def\@seccnt@prefix@section{\KBsectionnumfont}% \thesectionの前置き
\def\@seccnt@postfix@section{} % \thesectionの後置き
\def\@seccnt@afterskip@section{\@seccnt@post@skip}
\def\@seccnt@prefix@subsection{\KBsubsectionnumfont}% \thesubsectionの前置き
\def\@seccnt@postfix@subsection{}% \thesubsectionの後置き
\def\@seccnt@afterskip@subsection{\@seccnt@post@skip}
\def\@seccnt@prefix@subsubsection{\KBsubsubsectionnumfont}% \thesubsubsectionの前置き
\def\@seccnt@postfix@subsubsection{}% \thesubsubsectionの後置き
\def\@seccnt@afterskip@subsubsection{\@seccnt@post@skip}
\def\@seccnt@prefix@paragraph{\KBparagraphnumfont}% \theparagraphの前置き
\def\@seccnt@postfix@paragraph{}% \theparagraphの後置き
\def\@seccnt@afterskip@paragraph{\@seccnt@post@skip}
\def\@seccnt@prefix@subparagraph{}% \thesubparagraphの前置き
\def\@seccnt@postfix@subparagraph{}% \thesubparagraphの後置き
\def\@seccnt@afterskip@subparagraph{\@seccnt@post@skip}
% \section以下の体裁の設定です．
% 命名は\@make<SECTION>headになっているので，
% 対応する<SECTION>の中を適時修正するか，この箇所だけ別ファイルにして
% 好みの体裁をパターン化しておき\usepackageで切り替えるようなことをしてもよいでしょう．
\def\@makesectionhead#1#2#3{%
\bgroup
       \noindent#2\hskip#1\relax
       \setbox\z@\hbox{\@svsec}%
       \@tempdima\linewidth\advance\@tempdima-\wd\z@
       \advance\@tempdima-#1\relax
       \setbox\tw@\hbox{#3}%
       \dp\z@\z@\copy\z@%
          \ifdim\wd\tw@>\@tempdima
               \vtop{\hsize=\@tempdima\@parboxrestore\unhbox\tw@\@@par}
               \par\noindent
          \else
               \@inhibitglue\unhbox\tw@
          \fi
       \advance\@tempdima\wd\z@
\egroup
}
\def\@makesubsectionhead#1#2#3{%
\bgroup
       \noindent#2\hskip#1\relax
       \setbox\z@\hbox{\@svsec}%
       \@tempdima\linewidth\advance\@tempdima-\wd\z@
       \advance\@tempdima-#1\relax
       \setbox\tw@\hbox{#3}%
       \dp\z@\z@\copy\z@%
          \ifdim\wd\tw@>\@tempdima
               \vtop{\hsize=\@tempdima\@parboxrestore\unhbox\tw@\@@par}
               \par\noindent
          \else
               \@inhibitglue\unhbox\tw@
          \fi
       \advance\@tempdima\wd\z@
\egroup
}
\def\@makesubsubsectionhead#1#2#3{%
\bgroup
       \noindent#2\hskip#1\relax
       \setbox\z@\hbox{\@svsec}%
       \@tempdima\linewidth\advance\@tempdima-\wd\z@
       \advance\@tempdima-#1\relax
       \setbox\tw@\hbox{#3}%
       \dp\z@\z@\copy\z@%
          \ifdim\wd\tw@>\@tempdima
               \vtop{\hsize=\@tempdima\@parboxrestore\unhbox\tw@\@@par}
               \par\noindent
          \else
               \@inhibitglue\unhbox\tw@
          \fi
       \advance\@tempdima\wd\z@
\egroup
}
\def\@makeparagraphhead#1#2#3{%
\bgroup
       \noindent#2\hskip#1\relax
       \setbox\z@\hbox{\@svsec}%
       \@tempdima\linewidth\advance\@tempdima-\wd\z@
       \advance\@tempdima-#1\relax
       \setbox\tw@\hbox{#3}%
       \dp\z@\z@\copy\z@%
          \ifdim\wd\tw@>\@tempdima
               \vtop{\hsize=\@tempdima\@parboxrestore\unhbox\tw@\@@par}
               \par\noindent
          \else
               \@inhibitglue\unhbox\tw@
          \fi
       \advance\@tempdima\wd\z@
\egroup
}
% #1: ``section'' などの文字列（LaTeX カウンタ名）
% #2: 見出しの ``レベル''（番号を出力するか否かに関係します）
% #3: 見出しの字下げ量
% #4: 見出しの上側の空白量と見出しの後の字下げの有無に関係する寸法
% #5: 見出しの下側の空白量または，本文を追い込む際の見出しの後の空白量に
%     関係する寸法
% #6: 見出しの書体などの設定
% #7: 目次用タイトル
% #8: 本文用タイトル
% \make<SECTION>headが定義されていればその体裁で処理．未定義ならばデフォルトの体裁で処理されます．
\def\@sect#1#2#3#4#5#6[#7]#8{%
  \ifnum #2>\c@secnumdepth
    \let\@svsec\@empty
  \else
    \refstepcounter{#1}%
    \protected@edef\@svsec{\@seccntformat{#1}\relax}%
  \fi
  \@tempskipa #5\relax
  \ifdim \@tempskipa>\z@
\@ifundefined{@make#1head}{%
    \begingroup
      #6{%
        \@hangfrom{\hskip #3\relax{\@svsec}}%
%        \@hangfrom{\hskip #3\relax{\@svsec}}%
          \interlinepenalty\@M\@inhibitglue#8\@@par}%
    \endgroup}{\csname @make#1head\endcsname{#3}{#6}{#8}}
    \csname #1mark\endcsname{#7}%
    \addcontentsline{toc}{#1}{%
      \ifnum #2>\c@secnumdepth \else
        \protect\numberline{\csname the#1\endcsname}%
      \fi
      #7}%
  \else
    \def\@svsechd{%
      #6{\hskip #3\relax
      \@svsec #8}%
      \csname #1mark\endcsname{#7}%
      \addcontentsline{toc}{#1}{%
        \ifnum #2>\c@secnumdepth \else
          \protect\numberline{\csname the#1\endcsname}%
        \fi
        #7}}%
  \fi
  \@xsect{#5}}
% sectionなどを指定した行数の天地中央に置く(α版)
\newdimen\pre@head@skip
\newdimen\after@head@skip
\newdimen\@pre@section@skip
\newdimen\@after@section@skip
\newdimen\@pre@subsection@skip
\newdimen\@after@subsection@skip
\newdimen\@pre@subsubsection@skip
\newdimen\@after@subsubsection@skip
\def\KBheadinggap{\@ifnextchar[{\KB@headinggap}{\KB@headinggap[\z@]}}
\def\KB@headinggap[#1]#2#3{\pre@head@skip=\normalbaselineskip\relax
	\multiply\pre@head@skip by#3\relax
	\advance\pre@head@skip -\normalbaselineskip
	\after@head@skip\pre@head@skip
	\advance\pre@head@skip 1\Cht
	\divide \pre@head@skip 2\relax
	\setbox0=\hbox{\csname KB#2font\endcsname\char\euc"A1A1}
	\@tempdima\ht0
	\divide\@tempdima by2\relax
	\advance\@tempdima -1\Cht
	\advance\pre@head@skip \@tempdima
	\advance\pre@head@skip #1\relax
	\advance\after@head@skip -\pre@head@skip
	\csname @pre@#2@skip\endcsname=\pre@head@skip
	\csname @after@#2@skip\endcsname=\after@head@skip
}
% \KBheadinggap[上下shift量]{heading name}{行取数}
\KBheadinggap[.5\normalbaselineskip]{section}{3}
\KBheadinggap{subsection}{2}
\KBheadinggap{subsubsection}{2}
%--------------------------------------------------
\newcommand{\section}{%
   \@startsection{section}{1}{\z@}%
    {\@pre@section@skip}
    {\@after@section@skip}
   {\KBsectionfont}}%
\newcommand{\subsection}{%
   \@startsection{subsection}{2}{\z@}%
    {\@pre@subsection@skip}
    {\@after@subsection@skip}
   {\KBsubsectionfont}}%
\newcommand{\subsubsection}{%
   \@startsection{subsubsection}{3}{\z@}%
%    {\@pre@subsubsection@skip}
%    {\@after@subsubsection@skip}
    {\normalbaselineskip}
    {1sp}
   {\KBsubsubsectionfont}}%
\newcommand{\paragraph}{%
    \@startsection{paragraph}{4}{\z@}%
   {3.25ex \@plus 1ex \@minus .2ex}%
   {-1em}%
   {\KBparagraphfont}}
\newcommand{\subparagraph}{%
   \@startsection{subparagraph}{5}{\z@}%
   {3.25ex \@plus 1ex \@minus .2ex}%
   {-1em}%
   {\KBsubparagraphfont}}
\newcommand{\appendix}{\par
  \setcounter{chapter}{0}%
  \setcounter{section}{0}%
  \renewcommand{\@chapapp}{\appendixname}%
  \renewcommand{\@chappos}\space%
  \renewcommand{\thechapter}{\@Alph\c@chapter}}
\if@twocolumn
  \setlength\leftmargini {3zw}
\else
  \setlength\leftmargini {2zw}%% 3zw -> 2zw
\fi
\setlength\leftmarginii  {2zw}
\setlength\leftmarginiii {2zw}
\setlength\leftmarginiv  {2zw}
\if@twocolumn
  \setlength\leftmarginv {1zw}
  \setlength\leftmarginvi{1zw}
\else
  \setlength\leftmarginv {1zw}
  \setlength\leftmarginvi{1zw}
\fi
\labelsep1zw
\labelwidth\leftmargini
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand{\theenumi}{\@arabic\c@enumi}
\renewcommand{\theenumii}{\@alph\c@enumii}
\renewcommand{\theenumiii}{\@roman\c@enumiii}
\renewcommand{\theenumiv}{\@Alph\c@enumiv}
\newcommand{\labelenumi}{\theenumi.}
\newcommand{\labelenumii}{\theenumii.}
\newcommand{\labelenumiii}{\theenumiii.}
\newcommand{\labelenumiv}{\theenumiv.}
\renewcommand{\p@enumii}{\theenumi}
\renewcommand{\p@enumiii}{\theenumi(\theenumii)}
\renewcommand{\p@enumiv}{\p@enumiii\theenumiii}
\renewenvironment{enumerate}
  {\ifnum \@enumdepth >3\relax\@toodeep\else
   \advance\@enumdepth\@ne
   \edef\@enumctr{enum\romannumeral\the\@enumdepth}%
   \list{\csname label\@enumctr\endcsname}{%
         \ifnum \@listdepth=\@ne \topsep.5\normalbaselineskip
           \else\topsep\z@\fi
         \parskip\z@\itemsep\z@ \parsep\z@
         \labelwidth1zw \labelsep.3zw
         \ifnum \@enumdepth=\@ne \leftmargin1zw\relax
           \else\leftmargin\leftskip\fi
         \advance\leftmargin 1zw
         \usecounter{\@enumctr}%
         \def\makelabel##1{\hss\llap{##1}}}%
   \fi}{\endlist}
\newcommand{\labelitemi}{\textbullet}
\newcommand{\labelitemii}{%
  \iftdir
     {\textcircled{~}}
  \else
     {\normalfont\bfs\textendash}
  \fi
}
\newcommand{\labelitemiii}{\textasteriskcentered}
\newcommand{\labelitemiv}{\textperiodcentered}
\renewenvironment{itemize}
  {\ifnum \@itemdepth >3\relax\@toodeep\else
   \advance\@itemdepth\@ne
   \edef\@itemitem{labelitem\romannumeral\the\@itemdepth}%
   \expandafter
   \list{\csname \@itemitem\endcsname}{%
\labelwidth1zw \labelsep.3zw
      \iftdir
         \ifnum \@listdepth=\@ne \topsep.5\normalbaselineskip
           \else\topsep\z@\fi
         \parskip\z@ \itemsep\z@ \parsep\z@
         \labelwidth1zw \labelsep.3zw
         \ifnum \@itemdepth =\@ne \leftmargin1zw\relax
           \else\leftmargin\leftskip\fi
         \advance\leftmargin 1zw
      \fi
         \def\makelabel##1{\hss\llap{##1}}}%
   \fi}{\endlist}
\newenvironment{description}
  {\list{}{\labelwidth\z@ \itemindent-\leftmargin
   \iftdir
     \leftmargin\leftskip \advance\leftmargin3\Cwd
     \rightmargin\rightskip
     \labelsep=1zw \itemsep\z@
     \listparindent\z@ \topskip\z@ \parskip\z@ \partopsep\z@
   \fi
           \let\makelabel\descriptionlabel}}{\endlist}
\newcommand{\descriptionlabel}[1]{%
   \hspace\labelsep\normalfont\bfs #1}

\renewenvironment{description}
  {\list{}{\labelwidth=\leftmargin
\labelsep=1zw
\advance\labelwidth by-\labelsep
   \iftdir
     \leftmargin\leftskip \advance\leftmargin3\Cwd
     \rightmargin\rightskip
     \labelsep=1zw \itemsep\z@
     \listparindent\z@ \topskip\z@ \parskip\z@ \partopsep\z@
   \fi
           \let\makelabel\descriptionlabel}}{\endlist}
\renewcommand{\descriptionlabel}[1]{%
   \normalfont\bfs #1\hfil}
%%%%%%%
\newenvironment{verse}
  {\let\\\@centercr
   \list{}{\itemsep\z@ \itemindent -1.5em%
           \listparindent\itemindent
           \rightmargin\leftmargin \advance\leftmargin 1.5em}%
           \item\relax}{\endlist}
\newenvironment{quotation}
  {\list{}{\listparindent 1zw%
           \itemindent\listparindent
           \rightmargin\p@
           \parsep\z@ \@plus\p@}%
           \item\relax}{\endlist}
\newenvironment{quote}
  {\list{}{\rightmargin\leftmargin}%
           \item\relax}{\endlist}
\newcounter{figure}[chapter]
\renewcommand{\thefigure}{%
  \ifnum\c@chapter>\z@\thechapter.\fi\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\thefigure}
\newenvironment{figure}
               {\let\center\Center\let\endcenter\endCenter
               \@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\let\center\Center\let\endcenter\endCenter
               \@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}[chapter]
\renewcommand{\thetable}{\thechapter.\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
%   一般的に`図表'のcaptionは`図'の下，`表'はcaptionはその表の上に配置します．
%   このクラスファイルでは図を配置する目的で使われるfigure環境において
%   ``図の下にcaptionを置く前提'' で\abovecaptionskipはfigure環境内での
%   図とcaptionとのアキであるという想定で定義してます．
%   \belowcaptionskipはtable環境内で`表'の上にcaptionが配置されたとき
%   のアキということになります．
%   よってfigure環境でobjectを上に配置，もしくはtable環境でobjectの下に
%   captionを配置すると少しおかしな事になるかも知れません．
% # 2009/11/06に吉永徹美氏のマクロを参考に
% # \makecaptionの定義を全面的に書き直しました．
\abovecaptionskip2mm% 図とcaption とのアキとして想定
\belowcaptionskip2mm% 表とcaption とのアキとして想定
\def\@@float@type@figure{figure}
\def\@@float@type@table{table}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\long\def\@makecaption#1#2{%
 \ifx\@captype\@@float@type@figure\belowcaptionskip\z@\fi
 \ifx\@captype\@@float@type@table\abovecaptionskip\z@\fi
	\nointerlineskip\vskip\abovecaptionskip
	\setbox\z@\hbox{\KBcaptionfont\bfs#1\hskip1zw}%
	\dimen@\hsize \advance\dimen@-\wd\z@
	\setbox\tw@\vbox{\hsize\dimen@\@parboxrestore\KBcaptionfont#2}%
	\global\setbox\@ne\vtop{}%
	\setbox\tw@\vbox{%
	\dimen@\z@\unvcopy\tw@%%%%%
	\@makecaption@get@boxsize%%
		\unvbox\tw@
		\@makecaption@reconstruct@box}%
	\hbox to\hsize{\hss\box\z@\box\@ne\hss}%
	\@minipagefalse\nointerlineskip
	\vskip\belowcaptionskip}
\def\@makecaption@reconstruct@box{%
	\@tempdima\lastskip\unskip
	\unpenalty
	\setbox\tw@\lastbox
	\ifvoid\tw@\else
		\global\setbox\@ne\vtop{%
	\hbox to\dimen@{\unhbox\tw@}%%%%%
%\hbox{\unhbox\tw@}%
		\vskip\@tempdima%
		\unvbox\@ne}%
	\expandafter\@makecaption@reconstruct@box
	\fi
}
\def\@makecaption@get@boxsize{%
	\unskip \unpenalty \unskip \unpenalty
	\setbox4\lastbox
	\ifvoid4\else
		\setbox4\hbox{\unhbox4}%
		\ifdim\dimen@<\wd4 \dimen@\wd4\fi
		\expandafter\@makecaption@get@boxsize
	\fi}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\setlength\arraycolsep{2\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\@addtoreset{equation}{chapter}
\renewcommand{\theequation}{%
  \ifnum\c@chapter>\z@\thechapter.\fi \@arabic\c@equation}
\if@enablejfam
  \DeclareSymbolFont{mincho}{JY1}{mc}{m}{n}
  \DeclareSymbolFontAlphabet{\mathmc}{mincho}
  \SetSymbolFont{mincho}{bold}{JY1}{gt}{m}{n}
  \DeclareMathAlphabet{\mathgt}{JY1}{gt}{m}{n}
  \reDeclareMathAlphabet{\mathrm}{\@mathrm}{\@mathmc}
  \reDeclareMathAlphabet{\mathbf}{\@mathbf}{\@mathgt}
% \mathsfでも和文はゴシックになるようにしました．
  \reDeclareMathAlphabet{\mathsf}{\@mathsf}{\@mathgt}
  \jfam\symmincho
\else
  \DeclareRobustCommand{\mathmc}{%
    \@latex@error{Command \noexpand\mathmc invalid with\space
       `disablejfam' class option.}\@eha
  }
  \DeclareRobustCommand{\mathgt}{%
    \@latex@error{Command \noexpand\mathgt invalid with\space
       `disablejfam' class option.}\@eha
  }
\fi
\setcounter{tocdepth}{2}
\newcommand{\@pnumwidth}{1.5zw}
\newcommand{\@tocrmarg}{2.55em}
\newcommand{\@dotsep}{1.5}
\newdimen\toclineskip
\setlength\toclineskip{\z@}
\newdimen\@lnumwidth
% 目次で約物が行頭に来たとき\inhibitglueするように変更しました．
\def\numberline#1{\hbox to\@lnumwidth{#1\hfil}\@inhibitglue}

\def\numberline#1{%
   \setbox\z@\hbox{#1\hskip1zw}%
   \ifdim\wd\z@<\@lnumwidth \hbox to\@lnumwidth{\unhbox\z@\hfil}%
   \else
   \box\z@
   \fi\@inhibitglue}

% 目次のリーダー罫を和文中黒にしました．
\def\@dottedtocline#1#2#3#4#5{\ifnum #1>\c@tocdepth \else
  \vskip\toclineskip \@plus.2\p@
  {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
    \parindent #2\relax\@afterindenttrue
   \interlinepenalty\@M
   \leavevmode
   \@lnumwidth #3\relax
   \advance\leftskip \@lnumwidth \hbox{}\hskip -\leftskip
    {\@TocSectionSlectFont#4}
    \nobreak\leaders\hbox{$\m@th \mkern \@dotsep mu・\mkern \@dotsep
       mu$}\hfill \nobreak\hbox to\@pnumwidth{%
         \hss\@TocSectionNumSlectFont#5}\par}\fi}
\def\addcontentsline#1#2#3{%
  \protected@write\@auxout
    {\let\label\@gobble \let\index\@gobble \let\glossary\@gobble
\@temptokena{\thepage}}%
    {\string\@writefile{#1}%
       {\protect\contentsline{#2}{#3}{\the\@temptokena}}}%
}
\newcommand{\tableofcontents}{%
  \if@twocolumn\@restonecoltrue\onecolumn
  \else\@restonecolfalse\fi
  \chapter*{\contentsname}%
    \@mkboth{\contentsname}{\contentsname}\vspace{-1.5\baselineskip}%
  \@starttoc{toc}%
  \if@restonecol\twocolumn\fi
}
\newcommand*{\l@part}[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \addvspace{2.25em \@plus\p@}%
    \begingroup
    \parindent\z@\rightskip\@pnumwidth
    \parfillskip-\@pnumwidth
    {\leavevmode\KBtocpartfont
     \setlength\@lnumwidth{3.9zw}%
     #1\hfil\nobreak
     {\KBtocnumpartfont\hbox to\@pnumwidth{\hss#2}}}\par
    \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
     \endgroup
  \fi}
\newcommand*{\l@chapter}[2]{%
  \ifnum \c@tocdepth >\m@ne
    \addpenalty{-\@highpenalty}%
    \addvspace{1.0em \@plus\p@}%
    \begingroup
      \parindent\z@ \rightskip\@pnumwidth \parfillskip-\rightskip
      \leavevmode\KBtocchapterfont
      \setlength\@lnumwidth{4zw}%
      \advance\leftskip\@lnumwidth \hskip-\leftskip
      #1\nobreak\hfil\nobreak\KBtocnumchapterfont\hbox to\@pnumwidth{\hss#2}\par
      \penalty\@highpenalty
    \endgroup
  \fi}

\newcommand{\IfSecFontChange}{\S@ectionfalse\subS@ectionfalse\subsubS@ectionfalse}

\newcommand*{\l@section}{\IfSecFontChange%
\S@ectiontrue\@dottedtocline{1}{1.5em}{2.7em}}
\newcommand*{\l@subsection}   {\IfSecFontChange
\subS@ectiontrue\@dottedtocline{2}{4.2em}{3.25em}}
\newcommand*{\l@subsubsection}{\IfSecFontChange%
\subsubS@ectiontrue\@dottedtocline{3}{7.0em}{4.1em}}
\newcommand*{\l@paragraph}    {\@dottedtocline{4}{10em}{5em}}
\newcommand*{\l@subparagraph} {\@dottedtocline{5}{12em}{6em}}
\newcommand{\listoffigures}{%
  \if@twocolumn\@restonecoltrue\onecolumn
  \else\@restonecolfalse\fi
  \chapter*{\listfigurename}
  \@mkboth{\listfigurename}{\listfigurename}%
  \@starttoc{lof}%
  \if@restonecol\twocolumn\fi
}
\newcommand*{\l@figure}{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand{\listoftables}{%
  \if@twocolumn\@restonecoltrue\onecolumn
  \else\@restonecolfalse\fi
  \chapter*{\listtablename}
  \@mkboth{\listtablename}{\listtablename}%
  \@starttoc{lot}%
  \if@restonecol\twocolumn\fi
}
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newcommand{\newblock}{\hskip .11em\@plus.33em\@minus.07em}
\newenvironment{thebibliography}[1]
{\section*{\huge\bibname}
   \list{\@biblabel{\@arabic\c@enumiv}}%
        {\settowidth\labelwidth{\@biblabel{#1}}%
         \leftmargin\labelwidth
         \advance\leftmargin\labelsep
         \@openbib@code
         \usecounter{enumiv}%
         \let\p@enumiv\@empty
         \renewcommand\theenumiv{\@arabic\c@enumiv}\small}%
   \sloppy
   \clubpenalty4000
   \@clubpenalty\clubpenalty
   \widowpenalty4000%
   \sfcode`\.\@m
\lefthyphenmin=2\righthyphenmin=2%% ハイフネーションの条件を少し緩和
\frenchspacing% 全体のspaceを均等に
}
  {\def\@noitemerr
    {\@latex@warning{Empty `thebibliography' environment}}%
   \endlist}
\let\@openbib@code\@empty
\newenvironment{theindex}
  {\if@twocolumn\@restonecolfalse\else\@restonecoltrue\fi
   \columnseprule\z@ \columnsep 35\p@
   \twocolumn[\@makeschapterhead{\indexname}]%
   \@mkboth{\indexname}{\indexname}%
   \thispagestyle{empty}\parindent\z@
   \parskip\z@ \@plus .3\p@\relax
   \let\item\@idxitem\small}
  {\if@restonecol\onecolumn\else\clearpage\fi}


\renewenvironment{theindex}
  {\if@openright\cleardoublepage\else\clearpage\fi%
   \if@twocolumn\@restonecolfalse\else\@restonecoltrue\fi
   \columnseprule\z@ \columnsep 35\p@
\begin{multicols}{2}[\@makeschapterhead{\indexname}]
   \@mkboth{\indexname}{\indexname}%
\addcontentsline{toc}{chapter}{\indexname}
   \thispagestyle{empty}\parindent\z@
   \parskip\z@ \@plus .3\p@\relax
   \let\item\@idxitem\small}
  {\if@restonecol\end{multicols}\else\clearpage\fi}


\newcommand{\@idxitem}{\par\hangindent 4zw}
\newcommand{\subitem}{\@idxitem \hspace*{2zw}}
\newcommand{\subsubitem}{\@idxitem \hspace*{3zw}}
\newcommand{\indexspace}{\par \vskip.5\baselineskip\relax}
\def\@makefnmark{\hbox{\@textsuperscript{\normalfont\@thefnmark )}}}
\renewcommand{\footnoterule}{%
  \kern-3\p@
  \hrule width .4\columnwidth
  \kern 2.6\p@}
\@addtoreset{footnote}{chapter}
\newcommand\@makefntext[1]{\setbox\z@\hbox{\@makefnmark\hskip.25zw}
\leftskip\wd\z@
\advance\leftskip.25zw\parindent1zw
  \noindent\hbox to0pt{\hss\box\z@}#1}

%\renewcommand\@makefntext[1]{%
%  \advance\leftskip 3zw
%  \parindent 1zw
%  \noindent
%  \llap{\@makefnmark\hskip0.3zw}#1}


%\newif\if西暦 \西暦false
%\def\西暦{\西暦true}
%\def\和暦{\西暦false}
%\newcount\heisei \heisei\year \advance\heisei-1988\relax
%\def\today{{%
%  \iftdir
%    \if 西暦
%      \kansuji\number\year 年
%      \kansuji\number\month 月
%      \kansuji\number\day 日
%    \else
%      平成\ifnum\heisei=1 元年\else\kansuji\number\heisei 年\fi
%      \kansuji\number\month 月
%      \kansuji\number\day 日
%    \fi
%  \else
%    \if 西暦
%      \number\year ~年
%      \number\month ~月
%      \number\day ~日
%    \else
%      平成\ifnum\heisei=1 元年\else\number\heisei ~年\fi
%      \number\month ~月
%      \number\day ~日
%    \fi
%  \fi}}

\newcommand{\prepartname}{第}
\newcommand{\postpartname}{部}
\newcommand{\prechaptername}{第}
\newcommand{\postchaptername}{章}
\newcommand{\contentsname}{目　次}
\newcommand{\listfigurename}{図 目 次}
\newcommand{\listtablename}{表 目 次}
\newcommand{\bibname}{参考文献}
\newcommand{\indexname}{索　引}
\newcommand{\figurename}{図}
\newcommand{\tablename}{表}
\newcommand{\appendixname}{付録}
\pagestyle{headings}
\pagenumbering{arabic}
\raggedbottom
\if@twocolumn
  \twocolumn
  \sloppy
  \flushbottom
\else
  \onecolumn
\fi
\if@twoside
  \@mparswitchtrue
\else
  \@mparswitchfalse
\fi

%newtheorem環境で作られる環境での()を全角へ変更．および\itをキャンセル
\def\@opargbegintheorem#1#2#3{\trivlist
      \item[\hskip \labelsep{\bfs #1\ #2（#3）}]}

% 小口を調整するマクロです．
\def\Koguchi#1{%
\evensidemargin=#1
\oddsidemargin\paperwidth
\advance\oddsidemargin by-\textwidth
\advance\oddsidemargin by-\evensidemargin
\setlength\@@evensidemargin{\evensidemargin}
\advance\oddsidemargin by-1in
\advance\evensidemargin by-1in
%\topmargin\paperheight
%\advance\topmargin by-\textheight
%\topmargin.5\topmargin
%\advance\topmargin by-\headsep
%\advance\topmargin by-\headheight
%\advance\topmargin-1in
}

\def\KB@ten@@aki#1{%
\topmargin=#1
\advance\topmargin by-\headsep
\advance\topmargin by-\headheight
%\advance\topmargin by-\topskip
%\advance\topmargin by\Cht
\advance\topmargin-1in
}

\if@KB@ten@@
\KB@ten@@aki{\@Top@Margin@@}
\fi

% \marginparwidthは\marginparsepを引いた\evensidemarginの0.8倍にしてます．
% \小口の指定がある場合もその長さの0.8倍です．
\if@Koguchi
\Koguchi{\@Koguchi}
\fi
\ifdim\@@marginparwidth=0pt
\advance\@@evensidemargin by-\marginparsep
\marginparwidth.8\@@evensidemargin
\else
\marginparwidth\@@marginparwidth
\fi

%%%%

% 頁先頭に来た場合の行取り用のマクロです．
\newdimen\line@gap
   \line@gap\normalbaselineskip
    \advance\line@gap-\Cht
    \advance\line@gap-\Cdp
\newdimen\header@@height

\long\def\toplinebox#1#2{{%
  \normalsize\header@@height\z@\parindent\z@%
  \advance\header@@height by#1\normalbaselineskip%
  \advance\header@@height by-\normalbaselineskip%
  \advance\header@@height by\Cht%
  \advance\header@@height by\Cdp%
\hrule height\topskip depth-\topskip
    \parbox[c][\header@@height][c]{\textwidth}{#2%
}\par
\hrule height\z@\vskip\line@gap
}\ignorespaces}



% 字取りマクロ／\jidori{長さ}{TEXT}
\def\jidori#1#2{\leavevmode\hbox to #1{\kanjiskip\fill\xkanjiskip\kanjiskip#2}}

%%% 図版アタリケイ引く／#1=幅, #2=高さ.
\def\Fig#1#2{%
\parbox[b]{#1}{%
\hbox to#1{\vtop to#2{\hsize#1\hrule\vss
\hbox to#1{\vrule height#2\hss\vrule height#2}
\vss\hrule}}}}


% \displaystyle の省略形
\let\dis\displaystyle

% ベースはLaTeX2e 美文書作成入門に記載のものを参考に作りました．
% ルビ文字が判面の天についても一行目のベースラインが下がらないようにしました．
% \ruby{本文}{ルビ文字}
\newdimen\mytempdima
\newcommand{\ruby}[2]{%
\leavevmode
\setbox0=\hbox{#1}%	
\mytempdima=\f@size\p@
\setbox1=\hbox{\fontsize{.5\mytempdima}{0pt}\selectfont #2}%
\ifdim\wd0>\wd1 \dimen0=\wd0 \else \dimen0=\wd1 \fi
\hbox{%
\kanjiskip=0pt plus 2fil
\xkanjiskip=0pt plus 2fil
\vbox to\Cht{\vss%
\hbox to\dimen0{%
\fontsize{.5\mytempdima}{0pt}\selectfont \hfil#2\hfil}%
\nointerlineskip
\hbox to\dimen0{\mathstrut\hfil#1\hfil}}}}

%サク字用マクロ need graphicx package
% 
\newcommand{\sakuji}[2]{\scalebox{0.5}[1]{\hbox to2zw{#1\hskip-.1zw#2}}}


%% \\ により改行のできる caption ^* \makecaptionの再定義に伴い廃止
%% \pcation{TEXT\\TEXT}
%\newif\ifp@rc@ption
%\p@rc@ptionfalse
%\newsavebox{\@parc@ption}
%\newsavebox{\@parc@ptionB}
%\def\parcaption#1{%
%\sbox{\@parc@ption}{\shortstack[l]{\KBcaptionfont#1}}%
%\setbox\@parc@ptionB\hbox{\csname fnum@\@captype\endcsname}%
%\@tempdima\columnwidth \advance\@tempdima-\wd\@parc@ptionB
%\@tempdimb.95\@tempdima
%\ifdim\wd\@parc@ption >\@tempdimb \@tempdima\@tempdimb
%\else\@tempdima\wd\@parc@ption\fi
%\sbox{\@parc@ptionB}{\parbox[t]{\@tempdima}{\KBcaptionfont#1}}
%\p@rc@ptiontrue%
%\caption{\usebox{\@parc@ptionB}}%
%}

\def\Center{%
      \topsep\z@
      \partopsep\z@
      \parsep\z@
      \parskip\z@
\trivlist \centering\item[]}
\let\endCenter=\endtrivlist


% 字下げ幅を適時調整できるリスト
% 環境の前に空行を入れると半行分アキをつくる．
% \setlength{\Departopsep}{\baselineskip}で一行アキに変更可能．
% \begin{Description}{2zw}で字下げ2倍のリストする．
\newdimen\Departopsep
\Departopsep.5\baselineskip
\newenvironment{Description}[1]%
  {\partopsep=\Departopsep\list{}{\topsep=0pt\leftmargin=#1\labelwidth=\leftmargin
\labelsep=0zw
\advance\labelwidth by-\labelsep
   \iftdir
     \leftmargin\leftskip \advance\leftmargin3\Cwd
     \rightmargin\rightskip
     \labelsep=1zw \itemsep\z@
     \listparindent\z@ \topskip\z@ \parskip\z@ \partopsep\z@
   \fi
           \let\makelabel\Descriptionlabel}}{\endlist}
\newcommand{\Descriptionlabel}[1]{%
   \normalfont#1\hfil}

% 独立数式を頁先頭におけるようにする．
\predisplaypenalty100

\def\HO{\makebox[1zw][c]{\rule{.75zw}{.1mm}}}

\long\def\@savemarbox#1#2{%
   \global\setbox#1%
      \color@vbox
      \normalcolor%% \textcolor実行時に\marginparに`color'が及ばないように．
      \vtop{%
         \hsize\marginparwidth
         \@parboxrestore
         \@marginparreset\KBmarginparfont
         #2%
         \@minipagefalse
         \outer@nobreak}%
    \color@endbox}


% \sectionなどの見出しに対して行頭約物の処理を追加しました．
\def\@xsect#1{%
  \@tempskipa #1\relax
  \ifdim \@tempskipa<\z@
    \@nobreakfalse
    \global\@noskipsectrue
    \everypar{%
      \if@noskipsec
        \global\@noskipsecfalse
       {\setbox\z@\lastbox}%
        \clubpenalty\@M
        \begingroup \@svsechd \endgroup
        \unskip
        \@tempskipa #1\relax
        \hskip -\@tempskipa
      \else
        \clubpenalty \@clubpenalty
        \everypar{\everyparhook}%
      \fi\everyparhook}%
  \else
    \par \nobreak
    \vskip \@tempskipa
    \@afterheading
  \fi
  \par  % 2000-12-18
  \ignorespaces}
\def\@ssect#1#2#3#4#5{%
  \@tempskipa #3\relax
  \ifdim \@tempskipa<\z@
    \def\@svsechd{#4{\hskip #1\relax #5}}%
  \else
    \begingroup
      #4{%
        \@hangfrom{\hskip #1}%
          \interlinepenalty \@M\@inhibitglue#5\@@par}%
    \endgroup
  \fi
  \@xsect{#3}}

% 約物の行頭処理とfootnoteでの後続文字の判定で使います．
% 基本的な処理はjsbookを参考にしました．
% 対象約物を追加してます．
\def\@inhibitglue{%
  \futurelet\@let@token\@@inhibitglue}
\def\@@inhibitglue{%
  \ifx\@let@token「
    \inhibitglue
  \else
    \ifx\@let@token（
      \inhibitglue
    \else
      \ifx\@let@token『
        \inhibitglue
      \else
        \ifx\@let@token［
          \inhibitglue
        \else
          \ifx\@let@token《
           \inhibitglue
          \else
            \ifx\@let@token【
             \inhibitglue
            \else
              \ifx\@let@token〈
               \inhibitglue
              \else
               \ifx\@let@token“
                \inhibitglue
               \else
                 \ifx\@let@token〔
                  \inhibitglue
                 \else
                   \ifx\@let@token＜
                    \inhibitglue
                   \else
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                     \ifx\@let@token．
                      \unskip
                     \else
                       \ifx\@let@token，
                        \unskip
                       \else
                        \ifx\@let@token．
                          \unskip
                         \else
                           \ifx\@let@token。
                            \unskip
                           \else
                            \ifx\@let@token、
                              \unskip
                            \else
                              \ifx\@let@token。
                               \unskip
                              \else
                                \ifx\@let@token・
                                  \unskip
                                \else
%%%%%%%%%%%%%%%%%%%%%%%%%%
\fi\fi\fi\fi\fi\fi\fi\fi\fi
\fi\fi\fi\fi\fi\fi\fi\fi}
\let\everyparhook=\@inhibitglue
\AtBeginDocument{\everypar{\everyparhook}}
\def\@doendpe{%
  \@endpetrue
  \def\par{%
    \@restorepar\everypar{\everyparhook}\par\@endpefalse}%
  \everypar{{\setbox\z@\lastbox}\everypar{\everyparhook}\@endpefalse\everyparhook}}
% \@item内と\@afterheadingでの\clubpenaltyの増加を無効にしています．
% 伝統的な欧文組版ではページの最下段において"見出し＋1行"という状態を
% 好まない傾向があるといいます．
% (頁下段に見出しだけが残るいわゆる首吊りは論外ですが)日本語組版では
% 特にこのような拘りはなく，それよりも素の流れが好まれる傾向があるようです．
% オリジナルのLaTeXではこのようなことを抑制する目的で見出し直後の
% \clubpenaltyを変更していますが，日本語組版では先に挙げた理由により時
% として不自然に映る流れになるのでここで無効にしています．
% # \clubpenalty(\@clubpenalty)や\widowpenalty自体をglobalに0にしても
% # 差し支えないような気もしているのですが，確信が持てていないのでデフォルト
% # の150の設定には手をつけません．
\def\@item[#1]{%
  \if@noparitem
    \@donoparitem
  \else
    \if@inlabel
      \indent \par
    \fi
    \ifhmode
      \unskip\unskip \par
    \fi
    \if@newlist
      \if@nobreak
        \@nbitem
      \else
        \addpenalty\@beginparpenalty
        \addvspace\@topsep
        \addvspace{-\parskip}%
      \fi
    \else
      \addpenalty\@itempenalty
      \addvspace\itemsep
    \fi
    \global\@inlabeltrue
  \fi
  \everypar{%
    \@minipagefalse
    \global\@newlistfalse
    \if@inlabel
      \global\@inlabelfalse
      {\setbox\z@\lastbox
       \ifvoid\z@
         \kern-\itemindent
       \fi}%
      \box\@labels
      \penalty\z@
    \fi
    \if@nobreak
      \@nobreakfalse
%      \clubpenalty \@M
    \else
%      \clubpenalty \@clubpenalty
      \everypar{\everyparhook}%
    \fi\everyparhook}%
  \if@noitemarg
    \@noitemargfalse
    \if@nmbrlist
      \refstepcounter\@listctr
    \fi
  \fi
  \sbox\@tempboxa{\makelabel{#1}}%
  \global\setbox\@labels\hbox{%
    \unhbox\@labels
    \hskip \itemindent
    \hskip -\labelwidth
    \hskip -\labelsep
    \ifdim \wd\@tempboxa >\labelwidth
      \box\@tempboxa
    \else
      \hbox to\labelwidth {\unhbox\@tempboxa}%
    \fi
    \hskip \labelsep}%
  \ignorespaces}
\def\@afterheading{%
  \@nobreaktrue
  \everypar{%
    \if@nobreak
      \@nobreakfalse
%      \clubpenalty \@M
      \if@afterindent \else
        {\setbox\z@\lastbox}%
      \fi
    \else
%      \clubpenalty \@clubpenalty
      \everypar{\everyparhook}%
    \fi\everyparhook}}

% dvips用のsplecialの埋め込みです．(dviout, dvipdfmxでも有効です)
% \AFourtlueは用紙サイズをA4判に限定して天地中央に(tombowが指定されて
% いればトンボを含んだ状態で)配置させます．
% jsbookでは\paperwidthと\paperheightを基準にしてsplecial用紙サイズを
% 決定しています．
% ここではプリンタ出力に便利なようにA4判を基準に算出させています．
% クラスオプションA4size（jbookなどのa4paperやa4とは意味が異なります）で
% A4基準の仕様になり，指定しないと\paperwidthと\paperheightを基準にした
% 用紙サイズに決定するようにしています．
% (tombowありの判面＋トンボの用紙サイズになります．)
% PDFやdvioutの画面上で余白に無駄なく表示させるには指定しないほうがスッキリします．

\ifAFour
\newdimen\Hof@@fset
\newdimen\Vof@@fset
  \setlength{\@tempdima}{\paperwidth}
  \setlength{\@tempdimb}{\paperheight}
  \setlength{\Hof@@fset}{210mm}
  \setlength{\Vof@@fset}{297mm}
  \iftombow
   \advance \@tempdima 1in
   \advance \@tempdimb 1in
  \fi
   \advance \Hof@@fset -\@tempdima
   \advance \Vof@@fset -\@tempdimb
   \divide \Hof@@fset 2
   \divide \Vof@@fset 2
  \iftombow
   \advance \Hof@@fset -.5in
   \advance \Vof@@fset -.5in
  \fi
\voffset\Vof@@fset
\hoffset\Hof@@fset
  \AtBeginDvi{\special{papersize=210mm,297mm}}
\else
  \setlength{\@tempdima}{\paperwidth}
  \setlength{\@tempdimb}{\paperheight}
  \iftombow
    \advance \@tempdima 1in
    \advance \@tempdimb 1in
    \voffset -.5in
    \hoffset -.5in
  \fi
  \AtBeginDvi{\special{papersize=\the\@tempdima,\the\@tempdimb}}
\fi



\def\sujiPath{./num/}
% 丸数字を使う．1\UTF{FF5E}29までに対応．
\def\marusuji#1{%
\protect\makebox[1zw][c]{\protect\raisebox{-.15zh}{\protect\includegraphics[width=1zw]{\sujiPath%
#1.eps}}%
}}%
%
\let\@@PartFont\KBpartfont
\let\@@PartNumFont\KBpartnumfont
\let\@@ChapterFont\KBchapterfont
\let\@@ChapterNumFont\KBchapternumfont
\let\@@Indexheadfont\KBindextitlefont
\let\@@SectionFont\KBsectionfont
\let\@@SectionNumFont\KBsectionnumfont
\let\@@subSectionFont\KBsubsectionfont
\let\@@subSectionNumFont\KBsubsectionfont
\let\@@subsubSectionFont\KBsubsubsectionfont
\let\@@subsubSectionNumFont\KBsubsubsectionnumfont
\let\@@ParagraphFont\KBparagraphfont
\let\@@subParagraphFont\KBsubparagraphfont
\let\@@CaptionFont\KBcaptionfont
\let\@@PageNumFont\KBpagenumfont
\let\@@HeaderFont\KBheaderfon
\let\@@MarginparFont\KBmarginparfont
\let\@@TocPartFont\KBtocpartfont
\let\@@TocNumPartFont\KBtocnumpartfont
\let\@@TocChapterFont\KBtocchapterfont
\let\@@TocNumChapterFont\KBtocnumchapterfont
\let\@@TocSectionFontt\KBtocsectionfont
\let\@@TocsubSectionFont\KBtocsubsectionfont
\let\@@TocsubsubSectionFont\KBtocsubsubsectionfont
\let\@@TocNumSectionFont\KBtocnumsectionfont
\let\@@TocNumsubSectionFont\KBtocnumsubsectionfont
\let\@@TocNumsubsubSectionFont\KBtocnumsubsubsectionFont

% ZR氏による\footnoteでの添字に関係するアキの調整
% \textbf{（和文）}\footnote のような場合でも，閉じ）の右側の
% アキを\unskipで吸収させます．
% また，添字と後続文字のアキを原則として0.25zwに固定します．
% ただし，後続文字が "\footnote{}．" "\footnote{}「" のように約物の場合は
% \@inhibitglueでアキを吸収するようにしています．
\def\pxfn@pkgname{pxftnote}
\def\pxfn@error{\PackageError\pxfn@pkgname}
\def\pxfn@warn{\PackageWarning\pxfn@pkgname}
\newif\ifpxfn@hooked

%%------

%% save original definitions
\ifx\footnotes@ve\@undefined
\let\kb@org@@footnote=\footnote
\let\kb@org@@footnotemark=\footnotemark
\else % jsclasses loaded
\let\kb@org@@footnote=\footnotes@ve
\let\kb@org@@footnotemark=\footnotemarks@ve
\fi
\let\pxfn@org@@footnotetext=\@footnotetext

%%<*> \jfootnote / \jfootnotemark
\def\jfootnote{\pxfn@prehook\kb@org@@footnote}
\def\jfootnotemark{\pxfn@prehook\@ifnextchar[%
  {\pxfn@jfootnotemark@a}{\kb@org@@footnotemark\pxfn@posthook}}
\def\pxfn@jfootnotemark@a[#1]{\kb@org@@footnotemark[#1]\pxfn@posthook}

%% \pxfn@prehook, \pxfn@posthook
\def\pxfn@prehook{\pxPreJFootnoteHook\pxfn@hookedtrue}
\def\pxfn@posthook{%
  \ifpxfn@hooked \pxfn@hookedfalse
    \expandafter\pxPostJFootnoteHook \fi}

%% \pxfn@ifstartwith\CS{<prefix>}{<yes>}
% If the expansion of \CS starts with <prefix> then do <yes>.
\def\pxfn@ifstartwith#1#2{%
  \def\pxfn@tmpa{#2}\pxfn@detokenize\pxfn@tmpa\pxfn@pfx
  \expandafter\pxfn@ifstartwith@a\pxfn@pfx\@nil
  \pxfn@detokenize#1\pxfn@tmpa
  \edef\pxfn@tmpa{\pxfn@tmpa\pxfn@pfx}%
  \expandafter\pxfn@checker\pxfn@tmpa\@nil}
\AtBeginDocument{\let\pxfn@tmpa\relax\let\pxfn@pfx\relax}
\def\pxfn@ifstartwith@a#1\@nil{%
  \def\pxfn@checker##1#1##2\@nil{%
    \ifcat_##1_\expandafter\@firstofone
    \else \expandafter\@gobble\fi}}
\def\pxfn@detokenize#1#2{%
  \expandafter\pxfn@detokenize@a\expandafter#2\meaning#1\@nil}
\def\pxfn@detokenize@a#1#2->#3\@nil{\def#1{#3}}

%% \pxfn@inserthook@i, etc.
% Inserts \pxfn@posthook immediately after \insert operation.
\def\pxfn@inserthook@ii{\afterassignment\pxfn@inserthook@i}
\def\pxfn@inserthook@i{\afterassignment\pxfn@inserthook@a}
\def\pxfn@inserthook@a{\aftergroup\pxfn@posthook}

%% enable the postprocess hook
\let\pxfn@inserthook\relax
\pxfn@ifstartwith\@footnotetext{\insert\footins}%
  {\let\pxfn@inserthook\pxfn@inserthook@i}
\pxfn@ifstartwith\@footnotetext{\ifydir\def\@tempa}%
  {\let\pxfn@inserthook\pxfn@inserthook@ii}
\ifx\pxfn@inserthook\relax
  \pxfn@warn{Cannot enable postprocess hook}\@ehc
\else \def\@footnotetext{\pxfn@inserthook\pxfn@org@@footnotetext}%
\fi

\let\footnote\jfootnote
\let\footnotemark\jfootnotemark

%%------ Initial settings

% These settings basically obey the folloiwng W3C WG Note:
%   Requirements for Japanese Text Layout
%   http://www.w3.org/TR/2009/NOTE-jlreq-20090604/
%
\def\pxPreJFootnoteHook{\relax
  {\skip@\lastskip \@tempswatrue
   \ifdim\skip@>.225zw \ifdim\skip@<.275zw \@tempswafalse \fi\fi
   \if@tempswa \unskip \fi}}
\def\pxPostJFootnoteHook{\hskip.25zw\@inhibitglue}
%\def\pxPostJFootnoteHook{}

%%------ all done


\newdimen\dmath@height
\newdimen\dmath@height@vshift
\newcount\dmath@cunt

\def\lineofmath{%
\setbox\z@\vbox\bgroup
\abovedisplayskip\z@
\abovedisplayshortskip\abovedisplayskip
\belowdisplayshortskip\abovedisplayskip
\belowdisplayskip\abovedisplayskip%
}
\def\endlineofmath{\egroup
\dmath@height\ht\z@
%\showthe\dmath@height
\dmath@height@vshift\dmath@height
\advance\dmath@height\dp\z@
\dmath@cunt\dmath@height
\divide\dmath@cunt \baselineskip
\dmath@height \dmath@cunt\baselineskip
\advance\dmath@height \Cht
\advance\dmath@height \Cdp
\parindent\z@
%%%%
%\dmath@height2\baselineskip
%\advance\dmath@height -\baselineskip
%\advance\dmath@height \Cht
%\advance\dmath@height \Cdp
%%%%
\vskip\line@gap\prevdepth-10000pt
%\showboxdepth=100 \showboxbreadth=100
\fboxrule.1mm\fboxsep-\fboxrule\fbox{%
%\setbox2=%
\vbox to\dmath@height{%\ifdim\dmath@height@vshift<2\Cht%この正確な数値がわからない．\fi%
\vss\box\z@\vss}
%\showbox2%
%$\vcenter to\dmath@height{\@parboxrestore\vss\unvbox\z@\vss}$%
}
%\scrollmode\showbox2\box2
\vskip\line@gap\prevdepth-10000pt%\noindent
}


%\AtBeginDocument{\@ifpackageloaded{type1cm}{\PackageWarning{kbdbook}{}}{\relax}}
\AtBeginDocument{\@ifpackageloaded{type1cm}{\ClassWarning{kbdbook}{"type1cm.sty" was used, so the construction of the font changes.}}{\relax}}

\endinput

\def\@@inhibitglue{%
  \ifx\@let@token「
    \inhibitglue
  \else
    \ifx\@let@token（
      \inhibitglue
    \else
      \ifx\@let@token『
        \inhibitglue
      \else
        \ifx\@let@token［
          \inhibitglue
        \else
          \ifx\@let@token《
           \inhibitglue
          \else
            \ifx\@let@token【
             \inhibitglue
            \else
              \ifx\@let@token〈
               \inhibitglue
              \else
               \ifx\@let@token“
                \inhibitglue
               \else
                 \ifx\@let@token〔
                  \inhibitglue
                 \else
                   \ifx\@let@token＜
                    \inhibitglue
                   \else
                   \fi
                 \fi
                \fi
              \fi
            \fi
          \fi
        \fi
      \fi
    \fi
  \fi}


\endinput

\AtBeginDocument{%
\@ifundefined{AmS}{}{%
  \ifnum\cmex@opt=7 \def\cmex@opt{10}%
  \else \def\cmex@opt{0}\fi
  \DeclareFontFamily{U}{msa}{}%
  \DeclareFontShape{U}{msa}{m}{n}{<-6>msam5<6-8>msam7<8->msam10}{}%
  \DeclareFontFamily{U}{msb}{}%
  \DeclareFontShape{U}{msb}{m}{n}{<-6>msbm5<6-8>msbm7<8->msbm10}{}%
  \DeclareFontFamily{U}{euf}{}%
  \DeclareFontShape{U}{euf}{m}{n}{<-6>eufm5<6-8>eufm7<8->eufm10}{}%
  \DeclareFontShape{U}{euf}{b}{n}{<-6>eufb5<6-8>eufb7<8->eufb10}{}%
\typeout{ams上書き}}%
%
}

2009/11/13
pTeXでの\inhibitglue由来の不具合に対してTeX Q&AにおけるZ.R氏のパッチを適用
\@setfontsize，\fontsizeに\parindent，\(x)kanjiskipの追従．
\@afterheading \@itemでの\clubpenaltyの増加を無効．
\makecaptionを全面的に再定義