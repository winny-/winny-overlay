# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_APPIMAGE="Ripcord-${PV}-x86_64.AppImage"
MY_PN="${PN/-bin/}"

inherit desktop xdg-utils

DESCRIPTION="a desktop chat client for group-centric services like Slack and Discord"
HOMEPAGE="https://cancel.fm/ripcord/"
SRC_URI="https://cancel.fm/dl/${MY_APPIMAGE}"

LICENSE="ripcord-alpha-preview"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""

RESTRICT="mirror bindist"

DEPEND=""
RDEPEND="${DEPEND}
dev-libs/glib:2
dev-libs/libbsd
dev-libs/libpcre
sys-libs/zlib
x11-libs/libXau
x11-libs/libXdmcp
x11-libs/libxcb
virtual/opengl
x11-libs/libX11
sys-fs/fuse"
BDEPEND=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}/${A}" "${S}/" || die
	cd "${S}"
	chmod +x "${MY_APPIMAGE}" || die
	"./${MY_APPIMAGE}" --appimage-extract &> /dev/null || die
}

src_prepare() {
	default
	sed -i \
		-e "s,Exec=Ripcord,Exec=ripcord,g" \
		squashfs-root/Ripcord.desktop || die
}

src_install() {
	doicon squashfs-root/Ripcord_Icon.png || die
	domenu squashfs-root/Ripcord.desktop || die

	insinto "/opt/${MY_PN}"
	doins "${MY_APPIMAGE}"
	fperms +x "/opt/${MY_PN}/${MY_APPIMAGE}"
	dosym "../../opt/${MY_PN}/${MY_APPIMAGE}" "usr/bin/${MY_PN}"
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	xdg_icon_cache_update
}
