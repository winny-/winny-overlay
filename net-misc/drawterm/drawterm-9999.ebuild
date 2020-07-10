# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils mercurial

DESCRIPTION="connect to Plan 9 CPU servers from other operating systems"
HOMEPAGE="http://drawterm.9front.org/"
LICENSE="9base MIT"
SLOT="9front"
SRC_URI=""
EHG_REPO_URI="https://code.9front.org/hg/drawterm"
KEYWORDS=""
IUSE=""

DEPEND="
dev-libs/libbsd
x11-libs/libX11
x11-libs/libXau
x11-libs/libxcb
x11-libs/libXdmcp
x11-libs/libXt
"

src_compile() {
	export CONF=unix
	default
}

src_install() {
	dobin "${PN}"
	doman "${PN}.1"
	dodoc README
}
