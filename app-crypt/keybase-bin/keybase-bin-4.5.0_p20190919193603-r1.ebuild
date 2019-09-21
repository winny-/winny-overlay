# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils systemd unpacker xdg-utils

COMMIT_HASH="93e889ab01"

SRC_URI_BASE="https://s3.amazonaws.com/prerelease.keybase.io/linux_binaries/deb/keybase_"

DESCRIPTION="Keybase Go client, filesystem, and GUI"
HOMEPAGE="https://keybase.io"
SRC_URI="amd64? ( ${SRC_URI_BASE}${PV/_p/-}.${COMMIT_HASH}_amd64.deb )
	x86? ( ${SRC_URI_BASE}${PV/_p/-}.${COMMIT_HASH}_i386.deb )"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"
KEYWORDS="-* ~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	!app-crypt/kbfs
	!app-crypt/keybase
	app-crypt/gnupg
	sys-fs/fuse
	gnome-base/gconf
	x11-libs/libXScrnSaver"

S="${WORKDIR}"

QA_PREBUILT="*"

src_install() {
	exeinto /opt/keybase
	doexe opt/keybase/Keybase
	doexe opt/keybase/libffmpeg.so
	doexe opt/keybase/libEGL.so
	doexe opt/keybase/libGLESv2.so
	doexe opt/keybase/post_install.sh
	rm -f opt/keybase/{Keybase,lib*.so,post_install.sh}

	exeinto /opt/keybase/

	insinto /opt
	doins -r opt/keybase

	exeinto /usr/bin
	doexe usr/bin/git-remote-keybase
	doexe usr/bin/kbfsfuse
	doexe usr/bin/kbnm
	doexe usr/bin/keybase
	doexe usr/bin/keybase-redirector
	doexe usr/bin/run_keybase

	for d in etc/chromium etc/opt/chrome usr/lib/mozilla; do
		insinto /$d/native-messaging-hosts
		doins $d/native-messaging-hosts/io.keybase.kbnm.json
	done

	domenu usr/share/applications/keybase.desktop

	systemd_douserunit usr/lib/systemd/user/*.service

	cd usr/share/icons/hicolor
	local size
	for size in *; do
		doicon -s $size $size/apps/keybase.png
	done
}

pkg_postinst() {
	/opt/keybase/post_install.sh
	xdg_desktop_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
}
