# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_VERSION=2020Q1
SRC_URI="https://cdn.netbsd.org/pub/pkgsrc/pkgsrc-${MY_VERSION}/pkgsrc-${MY_VERSION}.tar.xz"

DESCRIPTION="Portable NetBSD compatibility library"
HOMEPAGE="https://www.NetBSD.org/"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/bmake"

S="${WORKDIR}/pkgsrc/pkgtools/libnbcompat/files"

src_configure() {
	econf --enable-db \
		  --enable-bsd-getopt
}

src_compile() {
	bmake ${MAKEOPTS}
}

src_install() {
	bmake install DESTDIR="$D"
}
