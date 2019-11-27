# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="Hex2bin-${PV}"

DESCRIPTION="Yet Another Hex to bin converter"
HOMEPAGE="http://hex2bin.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"
LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND=""
DEPEND=""

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}/${P}-Makefile.patch"
)

src_install() {
	emake install \
		  INSTALL_DIR="${D}/usr" \
		  MAN_DIR="${D}/usr/share/man/man1"
	dodoc doc/{CRC\ list.txt,formats.txt,intelhex.spc,README,S-record.txt,srec.txt}
}
