# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A 26-level dungeon crawl to the Amulet of Yendor."
HOMEPAGE="https://sites.google.com/site/broguegame/"
SRC_URI="https://sites.google.com/site/broguegame/${PN}-${PV}-linux-amd64.tbz2"

LICENSE="AGPL-3"
SLOT="0"
KEYWORDS="-* ~amd64"

RDEPEND="dev-games/libtcod:1/5
sys-libs/ncurses:0
media-libs/libsdl"

DEPEND="${RDEPEND}"

MY_BROGUE_SHARE="/usr/share/${PN}/"

src_prepare() {
	rm -rf src/libtcod*
	eapply "${FILESDIR}/${P}-makefile.patch"
	eapply "${FILESDIR}/${P}-share.patch"
	eapply_user
}

src_compile() {
	emake BROGUE_SHARE="$MY_BROGUE_SHARE"
}

src_install() {
	dobin "bin/${PN}"
#	fowners :games "${DESTREE}/usr/bin/${PN}"
#	fperms 0750 "${DESTREE}/usr/bin/${PN}"

	insinto "$MY_BROGUE_SHARE"
	doins bin/keymap
	doins bin/icon.bmp
	insinto "$MY_BROGUE_SHARE/fonts"
	doins bin/fonts/*.png
}

pkg_postinst() {
	echo
	elog "Note: BrogueHighScores.txt *.broguerec *.broguesave files are accessed"
	elog "      from the current directory. This behavior may be modified in"
	elog "      future."
}
