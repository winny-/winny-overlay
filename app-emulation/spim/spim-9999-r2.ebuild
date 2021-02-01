# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs qmake-utils subversion

# Unfortunately upstream does not use subversion branches/tags to mark
# releases, so the revision is used, and found via inspecting the svn
# commit history. Upstream also does not offer source tarballs(!).
#
# As a result, just stuff the revision in the filename
# e.g. spim-9.1.21_p729.ebuild
if [[ "${PV}" = 9999* ]]; then
	MY_SVN_REVISION=""
else
	MY_SVN_REVISION="${PV##*_p}"
fi

DESCRIPTION="MIPS Simulator"
HOMEPAGE="http://spimsimulator.sourceforge.net/"
ESVN_REPO_URI="https://svn.code.sf.net/p/spimsimulator/code/${MY_SVN_REVISION:+@${MY_SVN_REVISION}}"
ESVN_PROJECT="spimsimulator-code"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc X qt5"

RDEPEND="
	X? (
		media-fonts/font-adobe-100dpi
		x11-libs/libXaw
	)
	qt5? (
		dev-qt/qtwidgets:5
		dev-qt/qthelp:5
		dev-qt/qtprintsupport:5
		dev-libs/icu
	)
"
DEPEND="${RDEPEND}
	X? (
		x11-base/xorg-proto
		x11-misc/imake
	)
	sys-devel/bison
"
# test hangs forever, disabling it
RESTRICT="test"

src_prepare() {
	# Remove stale lex/yacc files
	rm QtSpim/{parser_yacc,scanner_lex}.*
	# This is clearly wrong:
	# ./QtSpim/parser_yacc.cpp:#include "parser.tab.h"
	# So let's fix that.
	sed -i -e 's/parser\.tab/parser_yacc/g' QtSpim/QtSpim.pro

	# XXX Check if these are necessary
	# fix bugs 240005 and 243588
	# eapply "${FILESDIR}/${P}-r1-respect_env.patch"

	# fix bug 330389
	# sed -i -e 's:-12-\*-75-:-14-\*-100-:g' xspim/xspim.c || die

	default
}

src_configure() {
	if use qt5; then
		pushd QtSpim
		eqmake5
		# Maybe there is a way to tell QtSpim.pro to not generate these
		# commands, but I don't understand why this was a problem in the
		# first place.  So just nuke the mad commands.
		sed -i -e '/MOVE.*parser_yacc/d' Makefile
		popd
	fi
}

src_compile() {
	emake DESTDIR="${EPREFIX}" -C spim

	if use X; then
		emake DESTDIR="${EPREFIX}" EXCEPTION_DIR=/var/lib/spim \
			-C xspim -j1 xspim
	fi

	if use qt5; then
		emake DESTDIR="${EPREFIX}" EXCEPTION_DIR=/var/lib/spim \
			  -C QtSpim -j1
	fi
}

src_install() {
	emake DESTDIR="${ED}" -C spim install
	newman Documentation/spim.man spim.1

	if use X; then
		emake DESTDIR="${ED}" -C xspim install
		newman Documentation/xspim.man xspim.1
		# XXX Install desktop file
	fi

	if use qt5; then
		newbin QtSpim/QtSpim qtspim
		# XXX Install QtSpim docs
		# XXX Install desktop file
		newman Documentation/qtspim.man qtspim.1
	fi

	# XXX Install rest of Spim docs
	dodoc ChangeLog README
}

src_test() {
	emake -C spim test
}
