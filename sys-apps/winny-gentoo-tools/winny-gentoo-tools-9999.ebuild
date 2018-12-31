# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
[[ "${PV}" == 9999* ]] && inherit git-r3

DESCRIPTION="Some simple scripts to manage package manager tasks"
SLOT="0"
HOMEPAGE="https://github.com/winny-/${PN}"
EGIT_REPO_URI="https://github.com/winny-/${PN}.git"

LICENSE="Unlicense"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_compile() {

}

src_install() {
    emake DESTDIR="${D}" PREFIX="/usr" install
    dodoc README.org
}
