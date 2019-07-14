# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils autotools

MY_PATCHLEVEL="20"

S="${WORKDIR}/${PN}-${PV}.orig"

DESCRIPTION="A curses URL parser for text files"
SLOT="0"
HOMEPAGE="https://packages.qa.debian.org/u/urlview.html"
SRC_URI="https://ftp.debian.org/debian/pool/main/u/urlview/${PN}_${PV}.orig.tar.gz
https://ftp.debian.org/debian/pool/main/u/urlview/${PN}_${PV}-${MY_PATCHLEVEL}.diff.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="sys-libs/ncurses:0"
DEPEND="${RDEPEND}"

src_prepare() {
    epatch "${WORKDIR}/${PN}_${PV}-${MY_PATCHLEVEL}.diff"
    eapply_user
    eautoconf
    eautomake
}

src_install() {
    dodir "/usr/share/man/man1"
    emake DESTDIR="${D}" \
          mandir="${D}/usr/share/man/" \
          install
}
