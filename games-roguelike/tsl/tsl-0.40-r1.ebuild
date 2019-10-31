# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="The Slimy Lichmummy is an adventure game by Ulf Astrom, similar in style to the classic \"Rogue\""
HOMEPAGE="http://www.happyponyland.net/the-slimy-lichmummy"
SRC_URI="http://www.happyponyland.net/files/${P}.tar.gz"

LICENSE="TSL"
SLOT="0"
KEYWORDS="~amd64"

IUSE="allegro +ncurses"

RESTRICT=""

RDEPEND="
allegro? ( media-libs/allegro:5 )
ncurses? ( sys-libs/ncurses:0 )
"

DEPEND="${RDEPEND}"

MY_TSL_SHARE="/usr/share/${PN}/"

REQUIRED_USE="|| ( ncurses allegro )"

src_prepare() {
	# Do not hide errors
	sed -i'' -e '/exit 0/d' build_*.sh
	# Respect allegro configuration
	sed -i'' \
		-e 's/-lallegro -lallegro_image -lallegro_font/$(pkg-config --libs allegro-5 allegro_image-5 allegro_font-5)/' \
		build_gui.sh
	# Respect ncurses configuration
	sed -i'' \
		-e 's/-lcurses/$(pkg-config --libs ncurses)/' \
		build_console.sh
	# Set gui assets to load from share directory
	sed -i'' \
		-e "s,\\([^\"]*\\.png\\),$MY_TSL_SHARE/\\1," \
		-e "s,\\([^\"]*\\.tga\\),$MY_TSL_SHARE/\\1," \
		allui.c

	eapply_user
}

# XXX Write a makefile that allows for this to be parallelized
src_compile() {
	if use ncurses; then
		./build_console.sh || die
		mv tsl tsl-console || die
	fi
	if use allegro; then
		./build_gui.sh || die
		mv tsl tsl-gui || die
	fi
}

src_install() {
	if use ncurses; then
		dobin tsl-console
	fi
	if use allegro; then
		dobin tsl-gui
		insinto "$MY_TSL_SHARE"
		doins *.png
		doins *.tga
	fi
	insinto "$MY_TSL_SHARE"
	dodoc CHANGES.TXT README.TXT
	dodoc tsl_conf_*
}

pkg_postinst() {
	echo
	elog "Note: TSL-SAVE is accessed from your home directory."
	elog "      morgue.txt is access from your current directory."
	elog "      Expect this behavior to change in the future."
}
