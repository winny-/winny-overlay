# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils cmake-utils

OWNER="Torr_Samaho"
MY_COMMIT="dd3c3b57023f"

DESCRIPTION="OpenGL ZDoom port with Client/Server multiplayer"
HOMEPAGE="https://zandronum.com/"
SRC_URI="https://bitbucket.org/${OWNER}/${PN}/get/${MY_COMMIT}.tar.bz2 -> ${P}.tar.bz2
	https://bitbucket.org/api/1.0/repositories/${OWNER}/${PN}/changesets/${MY_COMMIT}?format=yaml -> ${P}.metadata
"

LICENSE="Sleepycat"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="cpu_flags_x86_mmx cpu_flags_x86_sse2 dedicated +gtk +opengl timidity"

REQUIRED_USE="|| ( dedicated opengl )
	gtk? ( opengl )
	timidity? ( opengl )"

RDEPEND="gtk? ( x11-libs/gtk+:2 )
	timidity? ( media-sound/timidity++ )
	opengl? ( media-libs/fmod:1
		media-libs/libsdl
		virtual/glu
		virtual/jpeg:62
		virtual/opengl
	)
	dev-db/sqlite
	dev-libs/openssl:0"

DEPEND="${RDEPEND}
	cpu_flags_x86_mmx? ( || ( dev-lang/nasm dev-lang/yasm ) )"

src_unpack() {
	unpack "${P}.tar.bz2"
	S="${WORKDIR}/${OWNER}-${PN}-${MY_COMMIT}"
}

src_prepare() {
	# Normally Mercurial would generate gitinfo.h for NETGAMEVERSION
	# let's do it without Mercurial
	local timestamp=$(awk -F\' '/utctimestamp/{print $2}' "${DISTDIR}/${P}.metadata")
	local unixtimestamp=$(date +%s -d "${timestamp}")
	echo "#define HG_REVISION_NUMBER ${unixtimestamp}" > src/gitinfo.h
	echo "#define HG_REVISION_HASH_STRING \"0\"" >> src/gitinfo.h
	echo "#define HG_TIME \"\"" >> src/gitinfo.h

	# Use system libs
	sed -i -e "/add_subdirectory( sqlite )/d" CMakeLists.txt

	# Use default data path
	sed -i -e "s:/usr/local/share/:/usr/share/doom-data/:" src/sdl/i_system.h

	# Fix building with gcc-5
	sed -i -e 's/ restrict/ _restrict/g' dumb/include/dumb.h dumb/src/it/*.c

	eapply_user
}

src_configure() {
	mycmakeargs=(
		-DNO_ASM="$(usex cpu_flags_x86_mmx OFF ON)"
		-DNO_GTK="$(usex gtk OFF ON)"
		-DFMOD_INCLUDE_DIR=/opt/fmodex/api/inc/
		-DFMOD_LIBRARY=/opt/fmodex/api/lib/libfmodex.so
	)

	# Can't build both client and server at once... so separate them
	if use opengl; then
		BUILD_DIR="${WORKDIR}/${P}_client"
		cmake-utils_src_configure
	fi
	if use dedicated; then
		BUILD_DIR="${WORKDIR}/${P}_server"
		mycmakeargs+=(-DSERVERONLY=1)
		cmake-utils_src_configure
	fi
}

src_compile() {
	if use opengl; then
		BUILD_DIR="${WORKDIR}/${P}_client"
		cmake-utils_src_make
	fi
	if use dedicated; then
		BUILD_DIR="${WORKDIR}/${P}_server"
		cmake-utils_src_make SERVERONLY=1
	fi
}

src_install() {
	dodoc docs/{commands,zandronum*}.txt docs/console.{css,html}

	cd "${BUILD_DIR}"
	insinto "/usr/share/doom-data"
	doins *.pk3

	if use opengl; then
		dobin "${WORKDIR}/${P}_client/${PN}"
		doicon "${S}/src/win32/zandronum.ico"
		make_desktop_entry "${PN}" "Zandronum" "${PN}.ico" "Game;ActionGame;"
	fi
	if use dedicated; then
		dobin "${WORKDIR}/${P}_server/${PN}-server"
	fi
}

pkg_postinst() {
	elog "Copy or link wad files into /usr/share/doom-data/"
	elog "ATTENTION: The path has changed! It used to be /usr/share/games/doom-data/"
	if use opengl; then
		elog
		elog "To play, install games-util/doomseeker or simply run:"
		elog "   zandronum"
	fi
}
