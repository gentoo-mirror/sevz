# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic savedconfig toolchain-funcs git-r3

DESCRIPTION="patched version of dwl"
HOMEPAGE="https://github.com/Sevz17/dwl"
EGIT_REPO_URI="https://github.com/Sevz17/dwl"

LICENSE="CC0-1.0 GPL-3 MIT"
SLOT="0"
KEYWORDS=""
IUSE="X"

RDEPEND="
	dev-libs/libinput
	dev-libs/wayland
	gui-libs/wlroots[X(-)?]
	x11-libs/libxcb
	x11-libs/libxkbcommon
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
"

src_prepare() {
	restore_config config.def.h

	default
}

src_configure() {
	use X && append-cppflags -DXWAYLAND
	tc-export CC
}

src_install() {
	emake PREFIX="${ED}/usr" install

	einstalldocs

	save_config config.def.h
}
