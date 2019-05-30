# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

DESCRIPTION="A 3D-accelerated Doom source port based on ZDoom code"
HOMEPAGE="https://zdoom.org"

SRC_URI="https://zdoom.org/files/gzdoom/src/${PN}-src-g${PV}.zip"
KEYWORDS="~amd64 ~x86"

LICENSE="GPL-3"
SLOT="0"
IUSE="fluidsynth +gtk3 vulkan"

RDEPEND="fluidsynth? ( media-sound/fluidsynth )
	gtk3? ( x11-libs/gtk+:3 )
	vulkan? ( media-libs/vulkan-loader )
	media-libs/libsdl2
	virtual/glu
	virtual/jpeg:62
	virtual/opengl"

DEPEND="${RDEPEND}
	|| ( dev-lang/nasm dev-lang/yasm )"

src_unpack() {
	S="${WORKDIR}/${PN}-g${PV}"
	default
}

src_prepare() {
	# Use default data path
	sed -i -e "s:/usr/local/share/:/usr/share/doom-data/:" src/posix/i_system.h
	sed -i -e '/SetValueForKey ("Path", "\/usr\/share\/games\/doom", true);/ a \\t\tSetValueForKey ("Path", "/usr/share/doom-data", true);' \
		src/gameconfigfile.cpp
	sed -i -e '/SetValueForKey("Path", "\/usr\/share\/games\/doom\/soundfonts", true);/ a \\t\tSetValueForKey ("Path", "/usr/share/doom-data/soundfonts", true);' \
		src/gameconfigfile.cpp

	cmake-utils_src_prepare
}

src_configure() {
	# fluidsynth is detected dynamically
	# vulkan always appears to be compiled in on amd64 (see CMakeLists.txt)
	mycmakeargs=(
		-DNO_GTK="$(usex gtk3 no yes)"
	)

	cmake-utils_src_configure
}

src_install() {
	dodoc docs/*.txt
	dohtml docs/console*.{css,html}

	newicon "src/posix/zdoom.xpm" "${PN}.xpm"
	make_desktop_entry "${PN}" "GZDoom" "${PN}" "Game;ActionGame;"

	cd "${BUILD_DIR}"

	insinto "/usr/share/doom-data"
	doins *.pk3
	insinto "/usr/share/doom-data/soundfonts"
	doins soundfonts/*.sf2

	dobin "${PN}"
}

pkg_postinst() {
	elog 'Copy or link wad files into /usr/share/doom-data/ or $HOME/.config/gzdoom/'
	elog "ATTENTION: The path has changed! It used to be /usr/share/games/doom-data/"
	elog
	elog "Starting from GZDoom 3.3.0, TiMidity++ is now an internal MIDI player."
	elog "Unfortunately, it does not support system soundfonts directly."
	elog "To make them selectable, turn '/usr/share/timidity/foo' into a zip archive and put it"
	elog 'into /usr/share/doom-data/soundfonts/ or $HOME/.config/gzdoom/soundfonts/'
	elog
	elog "To play, simply run:"
	elog "   gzdoom"
	elog
}
