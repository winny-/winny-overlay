# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Patches found at https://packages.altlinux.org/en/sisyphus/srpms/lavaps/patches/lavaps_2.7-4.2.diff
# Todo: enable gtk support or fix tk rendering quirks.

EAPI=7

DESCRIPTION="a lava lamp of currently running processes"
HOMEPAGE="https://www.isi.edu/~johnh/SOFTWARE/LAVAPS/"
SRC_URI="https://www.isi.edu/~johnh/SOFTWARE/LAVAPS/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-lang/tk:0=
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libX11
"
DEPEND="
	${RDEPEND}
	dev-lang/perl
"

src_prepare() {
	eapply "${FILESDIR}/${P}-src_linux_proc_ps.h.patch"
	eapply "${FILESDIR}/${P}-src_process_model.cc.patch"
	eapply "${FILESDIR}/${P}-src_blob.cc.patch"
	eapply "${FILESDIR}/${P}-src_lava_signal.cc.patch"
	eapply_user
}

src_configure() {
	econf --with-tcltk
}

src_compile() {
	# Building documentation fails with parallel Make.
	pushd doc
	emake -j1 all-recursive
	popd

	emake
}

src_install() {
	default
	rm "${D}/lavaps.schemas" # XXX
}
