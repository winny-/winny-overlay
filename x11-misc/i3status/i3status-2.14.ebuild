# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit fcaps  meson

DESCRIPTION="generates a status bar for dzen2, xmobar or similar"
HOMEPAGE="https://i3wm.org/i3status/"
SRC_URI="https://github.com/i3/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~riscv x86"
IUSE="pulseaudio"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/yajl-2.0.2
	dev-libs/confuse:=
	dev-libs/libnl:3
	media-libs/alsa-lib
	pulseaudio? ( || ( media-sound/pulseaudio media-sound/apulse[sdk] ) )
"

DEPEND="
	${RDEPEND}
	app-text/asciidoc
	app-text/xmlto
"


src_configure() {
	local emesonargs=(
		$(meson_use pulseaudio)
	)
	meson_src_configure
}

pkg_postinst() {
	fcaps cap_net_admin usr/bin/${PN}

	elog "${PN} can be used with any of the following programs:"
	elog "   i3bar (x11-wm/i3)"
	elog "   x11-misc/xmobar"
	elog "   x11-misc/dzen"
	elog "Please refer to manual: man ${PN}"
}
