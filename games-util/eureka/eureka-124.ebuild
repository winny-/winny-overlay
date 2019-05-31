# Copyright 2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Map editor for the classic DOOM games, and a few related games such as Heretic and Hexen."
HOMEPAGE="http://eureka-editor.sourceforge.net/"
SRC_URI="mirror://sourceforge/eureka-editor/${PV}/${P}-source.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}/${PN}-1.24-source

DEPEND=">=x11-libs/fltk-1.3.0
	sys-libs/zlib"

src_prepare() {
#	eapply "${FILESDIR}"/${P}-gentoo-makefile.patch

	eapply_user
}

