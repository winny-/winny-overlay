# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3
EGIT_REPO_URI="https://github.com/cktan/tomlc99/"

DESCRIPTION="TOML in c99; v1.0 compliant"
HOMEPAGE="https://github.com/cktan/tomlc99"
SRC_URI=""

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i'' \
		-e 's|-shared|-shared -Wl,-soname,$@|' \
		-e "s|/lib$|/$(get_libdir)|" \
		Makefile
	eapply_user
}

src_install() {
	emake install prefix="${D}/usr"
	dodoc README.md
}
