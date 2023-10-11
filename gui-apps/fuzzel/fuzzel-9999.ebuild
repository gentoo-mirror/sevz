# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Application launcher for wlroots based Wayland compositors."
HOMEPAGE="https://codeberg.org/dnkl/fuzzel"

if [[ "${PV}" != 9999 ]]; then
	SRC_URI="https://codeberg.org/dnkl/${PN}/archive/${PV}.tar.gz  -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}"
else
	EGIT_REPO_URI="https://codeberg.org/dnkl/fuzzel.git"
	inherit git-r3
fi

LICENSE="MIT ZLIB"
SLOT="0"
IUSE="cairo png svg dmenu"

REQUIRED_USE="svg ( cairo )"

CDEPEND="
	dev-libs/wayland
	media-libs/fcft
	media-libs/fontconfig
	x11-libs/libxkbcommon
	x11-libs/pixman
	cairo? ( x11-libs/cairo )
	png? ( media-libs/libpng:= )
	svg? ( gnome-base/librsvg )
"
DEPEND="
	${CDEPEND}
	dev-libs/tllist
"
RDEPEND="
	${CDEPEND}
	dmenu? ( x11-misc/dmenu )
"
BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
"

src_configure() {
	local emesonargs=(
		$(meson_feature cairo enable-cairo)
		-Dpng-backend=$(usex png libpng none)
		-Dsvg-backend=$(usex svg librsvg nanosvg)
	)

	meson_src_configure
}

src_install() {
	local DOCS=( README.md CHANGELOG.md )
	meson_src_install
	einstalldocs

	rm -r "${ED}"/usr/share/doc/${PN} || die

	if use dmenu; then
		dobin "${FILESDIR}"/fuzzel_path
		dobin "${FILESDIR}"/fuzzel_run
	fi
}
