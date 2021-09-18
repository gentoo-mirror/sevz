# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="dzen for Wayland"
HOMEPAGE="https://github.com/djpohly/dtao"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/djpohly/dtao"
	KEYWORDS=""
else
	SRC_URI="https://github.com/djpohly/dtao/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"
IUSE="+man"

RDEPEND="
	dev-libs/wayland
	x11-libs/pixman
	media-libs/fcft
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	virtual/pkgconfig
	man? ( app-text/ronn )
"

src_prepare() {
	use man || eapply "${FILESDIR}/${PN}-no-make-manpages.patch"
	eapply_user
}

src_install() {
	emake PREFIX="${ED}/usr" install
	einstalldocs
}
