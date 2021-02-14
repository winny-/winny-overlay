# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# This ebuild is copied from 2xsaiko overlay.  This way the
# www-client/qutebrowser ebuild in this overlay will not require yet
# another overlay to install with +adblock.

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=pyproject.toml

CRATES="
	adblock-0.3.4
	addr-0.2.0
	addr2line-0.14.0
	adler-0.2.3
	aho-corasick-0.7.15
	autocfg-1.0.1
	backtrace-0.3.55
	base64-0.13.0
	bitflags-1.2.1
	byteorder-1.3.4
	cc-1.0.66
	cfg-if-0.1.10
	cfg-if-1.0.0
	core-foundation-0.9.1
	core-foundation-sys-0.8.2
	crc32fast-1.2.1
	ctor-0.1.16
	either-1.6.1
	error-chain-0.12.4
	flate2-1.0.19
	foreign-types-0.3.2
	foreign-types-shared-0.1.1
	form_urlencoded-1.0.0
	getrandom-0.1.15
	ghost-0.1.2
	gimli-0.23.0
	idna-0.1.5
	idna-0.2.0
	indoc-1.0.3
	instant-0.1.9
	inventory-0.1.10
	inventory-impl-0.1.10
	itertools-0.9.0
	lazy_static-1.4.0
	libc-0.2.81
	lock_api-0.4.2
	log-0.4.11
	matches-0.1.8
	memchr-2.3.4
	miniz_oxide-0.4.3
	native-tls-0.2.6
	num-traits-0.2.14
	object-0.22.0
	once_cell-1.5.2
	openssl-0.10.31
	openssl-probe-0.1.2
	openssl-sys-0.9.59
	parking_lot-0.11.1
	parking_lot_core-0.8.1
	paste-1.0.4
	percent-encoding-1.0.1
	percent-encoding-2.1.0
	pkg-config-0.3.19
	ppv-lite86-0.2.10
	proc-macro2-0.4.30
	proc-macro2-1.0.24
	psl-0.4.1
	psl-codegen-0.4.2
	psl-lexer-0.2.0
	pyo3-0.13.1
	pyo3-macros-0.13.1
	pyo3-macros-backend-0.13.1
	quote-0.6.13
	quote-1.0.7
	rand-0.7.3
	rand_chacha-0.2.2
	rand_core-0.5.1
	rand_hc-0.2.0
	redox_syscall-0.1.57
	regex-1.4.2
	regex-syntax-0.6.21
	remove_dir_all-0.5.3
	rental-0.5.5
	rental-impl-0.5.5
	rmp-0.8.9
	rmp-serde-0.13.7
	rustc-demangle-0.1.18
	rustc_version-0.2.3
	schannel-0.1.19
	scopeguard-1.1.0
	seahash-3.0.7
	security-framework-2.0.0
	security-framework-sys-2.0.0
	semver-0.9.0
	semver-parser-0.7.0
	sequence_trie-0.3.6
	serde-1.0.118
	serde_derive-1.0.118
	smallvec-1.5.1
	stable_deref_trait-1.2.0
	syn-0.14.9
	syn-1.0.54
	tempfile-3.1.0
	thread_local-1.0.1
	tinyvec-1.1.0
	tinyvec_macros-0.1.0
	twoway-0.2.1
	unchecked-index-0.2.2
	unicode-bidi-0.3.4
	unicode-normalization-0.1.16
	unicode-xid-0.1.0
	unicode-xid-0.2.1
	unindent-0.1.7
	url-1.7.2
	url-2.2.0
	vcpkg-0.2.11
	version_check-0.9.2
	wasi-0.9.0+wasi-snapshot-preview1
	winapi-0.3.9
	winapi-i686-pc-windows-gnu-0.4.0
	winapi-x86_64-pc-windows-gnu-0.4.0
"

inherit cargo distutils-r1

PSL_COMMIT="3c1add017dd9b8ee81ca490f75262d067af53f7d"

DESCRIPTION="Brave's adblock library in Python"
HOMEPAGE="https://github.com/ArniDagur/python-adblock"
SRC_URI="
	https://github.com/ArniDagur/python-adblock/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://raw.githubusercontent.com/publicsuffix/list/${PSL_COMMIT}/public_suffix_list.dat -> public_suffix_list-${PSL_COMMIT}.dat
	$(cargo_crate_uris ${CRATES})"

LICENSE="|| ( Apache-2.0 MIT )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/python-adblock-${PV}"

RESTRICT="mirror"

src_prepare() {
	# required by distutils-r1
	printf '\n[build-system]\nbuild-backend = "poetry.masonry.api"' >> "${S}"/pyproject.toml

	# patch library to not try to download files at build time
	sed -i "s,List::fetch(),List::from_str(include_str!(\"${DISTDIR}/public_suffix_list-${PSL_COMMIT}.dat\"))," \
		"${WORKDIR}"/cargo_home/gentoo/psl-codegen-0.4.2/src/lib.rs

	distutils-r1_src_prepare
}

src_compile() {
	distutils-r1_src_compile
}

src_install() {
	distutils-r1_src_install
}

python_compile() {
	ECARGO_ARGS=(--target-dir "${BUILD_DIR}")
	cargo_src_compile
	distutils-r1_python_compile
}

python_install() {
	insinto "$(python_get_sitedir)/adblock"
	newins "${BUILD_DIR}/release/libadblock.so" adblock.so

	distutils-r1_python_install
}
