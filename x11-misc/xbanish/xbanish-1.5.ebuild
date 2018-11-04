# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="banish the mouse cursor when typing, show it again when the mouse moves"
SLOT="0"
HOMEPAGE="https://github.com/jcs/xbanish"
SRC_URI="https://github.com/jcs/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="x11-libs/libX11
    x11-libs/libXfixes
    x11-libs/libXi"
DEPEND="${RDEPEND}"

src_install() {
    emake PREFIX="${D}/usr" \
        MANDIR="${D}/usr/share/man/man1" \
        INSTALL_PROGRAM="install" \
        install
    dodoc README
}
