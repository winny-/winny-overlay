# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="When you need a web server in a hurry"
HOMEPAGE="https://unix4lyfe.org/darkhttpd/"
SRC_URI="https://unix4lyfe.org/darkhttpd/${P}.tar.bz2"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	dobin ${PN}
	dodoc AUTHORS README
}
