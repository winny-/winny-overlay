# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit savedconfig toolchain-funcs

DESCRIPTION="sacc(omys), simple console gopher client"
HOMEPAGE="gopher://bitreich.org/1/scm/sacc/log.gph"
SRC_URI="ftp://ftp@bitreich.org/releases/sacc/${PN}-v${PV}.tgz"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="sys-libs/ncurses
${RDEPEND}"

src_prepare() {
	sed config.mk \
		-e '/^CC/d' \
		-e 's|/usr/local|/usr|g' \
		-e 's|{|(|g;s|}|)|g' \
		-i || die

	sed Makefile \
		-e 's|{|(|g;s|}|)|g' \
		-e '/^[[:space:]]*@echo/d' \
		-e 's|^	@|	|g' \
                -e 's|chmod 555|chmod 755|g' \
		-i || die

	restore_config config.h
        eapply_user
}

src_compile() {
	emake CC=$(tc-getCC)
}
src_install() {
	default
	save_config config.h
}
