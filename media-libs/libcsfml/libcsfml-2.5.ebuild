# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils

MY_P="CSFML-${PV}"

DESCRIPTION="C bindings for SFML"
HOMEPAGE="https://www.sfml-dev.org/ https://github.com/SFML/CSFML"
SRC_URI="https://github.com/SFML/CSFML/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="ZLIB"
SLOT="0/$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="media-libs/libsfml"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
"

S="${WORKDIR}/${MY_P}"

DOCS=( readme.txt )

src_prepare() {
	sed -i "s:DESTINATION .*:DESTINATION /usr/share/doc/${PF}:" \
		doc/CMakeLists.txt || die

	# Have ebuild DOCS handle this.
	sed -i '/install(FILES /d' \
		CMakeLists.txt || die

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DCSFML_BUILD_DOC=$(usex doc)
	)

	cmake-utils_src_configure
}
