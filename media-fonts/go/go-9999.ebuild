# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font git-r3

EGIT_REPO_URI="https://go.googlesource.com/image"

DESCRIPTION="Go font family"
HOMEPAGE="https://go.googlesource.com/image"

LICENSE="BSD"
SLOT="0"
KEYWORDS="*"

S="${WORKDIR}/${P}/font/gofont/ttfs"
FONT_SUFFIX="ttf"
FONT_S="${S}"
DOCS="README"
