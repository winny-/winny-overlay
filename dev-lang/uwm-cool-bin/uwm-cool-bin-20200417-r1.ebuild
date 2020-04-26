# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/-bin/}"

DESCRIPTION="Cool toolchain variant used to teach compilers at University of Wisconsin - Milwaukee"
HOMEPAGE="http://pabst.cs.uwm.edu/classes/cs654 http://pabst.cs.uwm.edu/classes/cs655"
SRC_URI="${MY_PN}-${PV}.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="fetch"

RDEPEND="
app-emulation/spim
sys-devel/bison
>=virtual/jre-1.8:*
"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P/-bin}"

src_compile() {
	:
}

src_install() {
	insinto "/opt/${MY_PN}"
	dodir .

	cp -r * "${ED}/opt/${MY_PN}/"
	chmod 0755 "${ED}/opt/${MY_PN}/cmd/"*
	chmod 0755 "${ED}/opt/${MY_PN}/bin/"*
#	fperms 755 "/opt/${MY_PN}/cmd/"*

	insinto "/etc/profile.d"
	doins "${FILESDIR}/uwm-cool.sh"

	insinto /afs/cs.uwm.edu/users/classes/cs654/lib
	dosym "/opt/${MY_PN}/lib/basic.cool" '/afs/cs.uwm.edu/users/classes/cs654/lib/basic.cool'
}

pkg_postinst() {
	einfo "Run . /etc/profile add /opt/${MY_PN}/cmd to your path"
}
