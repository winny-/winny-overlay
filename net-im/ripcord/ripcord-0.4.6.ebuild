# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

APPIMAGE="Ripcord-${PV}-x86_64.AppImage"

DESCRIPTION="a desktop chat client for group-centric services like Slack and Discord"
HOMEPAGE="https://cancel.fm/ripcord/"
SRC_URI="https://cancel.fm/dl/${APPIMAGE}"

LICENSE="ripcord-alpha-preview"
SLOT="0"
KEYWORDS="~amd64 -x86"
IUSE=""

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
x11-libs/libX11"
BDEPEND=""

src_unpack() {
    mkdir -p "${S}"
    cp "${DISTDIR}/${APPIMAGE}" "${S}/"
}

src_install() {
    newbin "${APPIMAGE}" ripcord
}
