# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

#
# This is a precompiled ebuild because gradle is not currently integrated with
# portage yet.
#
# https://wiki.gentoo.org/wiki/Gentoo_Java_Packing_Policy#Gradle
#

EAPI=7

MY_PN="${PN/-bin/}"

DESCRIPTION="A chat software specifically made for Twitch"
HOMEPAGE="http://chatty.github.io/"
SRC_URI="https://github.com/chatty/chatty/releases/download/v${PV}/Chatty_${PV}.zip"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""

RDEPEND=">=virtual/jre-1.8
		${CDEPEND}"

BDEPEND=""

S="${WORKDIR}"

src_unpack() {
	default
	cp "${FILESDIR}/chatty.sh" .
}

src_prepare() {
	default
	sed -i "s/_OPTDIR_/${PN}-${SLOT}/" chatty.sh
}

src_install() {
	insinto /opt/${PN}-${SLOT}/lib/
	doins Chatty.jar
	doins -r sounds img
	dodoc readme.txt
	newbin chatty.sh chatty
}
