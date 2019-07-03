# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_APPIMAGE="Ripcord-${PV}-x86_64.AppImage"

DESCRIPTION="a desktop chat client for group-centric services like Slack and Discord"
HOMEPAGE="https://cancel.fm/ripcord/"
SRC_URI="https://cancel.fm/dl/${MY_APPIMAGE}"

LICENSE="ripcord-alpha-preview"
SLOT="0"
KEYWORDS="~amd64 -x86"
IUSE=""

RESTRICT="mirror bindist"

DEPEND=""
RDEPEND="${DEPEND}
dev-libs/glib
dev-libs/libbsd
dev-libs/libpcre
sys-devel/gcc[cxx]
sys-libs/glibc
sys-libs/zlib
x11-libs/libXau
x11-libs/libXdmcp
x11-libs/libxcb
virtual/opengl
x11-libs/libX11
sys-fs/fuse"
BDEPEND=""

QA_PREBUILT="usr/bin/ripcord"

S="${WORKDIR}"

src_unpack() {
    cp "${DISTDIR}/${MY_APPIMAGE}" "${S}/"
}

src_install() {
    newbin "${MY_APPIMAGE}" ripcord
}
