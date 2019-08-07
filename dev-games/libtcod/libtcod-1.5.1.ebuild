# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Based off of https://bugs.gentoo.org/show_bug.cgi?id=547236

EAPI="7"

DESCRIPTION="A free, fast, portable and uncomplicated API for roguelike developers."
HOMEPAGE="http://roguecentral.org/doryen/libtcod/"
SRC_URI="https://github.com/libtcod/libtcod/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="1/5"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/libsdl
		 media-libs/libpng:0
		 sys-libs/zlib"
DEPEND="${RDEPEND}"

src_prepare() {
	sed -i s'/\.\/libtcod\.so/libtcod\.so/' libtcodpy.py
	eapply "${FILESDIR}/${P}-library-version.patch"
	eapply_user
}

src_compile() {
	# Fails on parallel build.
	if use amd64; then
		emake -f makefiles/makefile-linux64 release -j1 TEMP="$WORKDIR/temp"
	elif use x86; then
		emake -f makefiles/makefile-linux release -j1 TEMP="$WORKDIR/tmp"
	fi
}

src_install() {
	dolib.so libtcod.so.${PV} libtcodgui.so.${PV} libtcodxx.so.${PV}
	insinto /usr/include/${P}
	doins include/*
}
