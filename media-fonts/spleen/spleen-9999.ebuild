# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font font-ebdftopcf

DESCRIPTION="Monospaced bitmap font"
HOMEPAGE="https://github.com/fcambus/spleen"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fcambus/${PN}.git"
else
	SRC_URI="https://github.com/fcambus/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="BSD-2"
SLOT="0"

DOCS=(
	AUTHORS
	ChangeLog
	README.md
)
