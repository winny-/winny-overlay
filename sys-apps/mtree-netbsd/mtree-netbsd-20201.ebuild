# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_VERSION=2020Q1
SRC_URI="https://cdn.netbsd.org/pub/pkgsrc/pkgsrc-${MY_VERSION}/pkgsrc-${MY_VERSION}.tar.xz"

DESCRIPTION="Validates directory tree against specification (from NetBSD)"
HOMEPAGE="http://cdn.netbsd.org/pub/pkgsrc/current/pkgsrc/pkgtools/mtree/README.html"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=""
DEPEND="
${RDEPEND}
!sys-apps/mtree
"
BDEPEND="
sys-devel/bmake
dev-libs/libnbcompat
"

S="${WORKDIR}/pkgsrc/pkgtools/mtree/files"

PATCHES=(
	"${FILESDIR}/undefined_reference_to_makedev.patch"
)

src_configure () {
	econf LIBS='-lnbcompat'
}

src_compile() {
	bmake ${MAKEOPTS}
}

src_install() {
	bmake install DESTDIR="$D" ${MAKEOPTS}
}
