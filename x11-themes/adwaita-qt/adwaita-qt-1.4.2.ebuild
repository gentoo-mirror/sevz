# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake multibuild

DESCRIPTION="A style to bend Qt applications to look like they belong into GNOME Shell"
HOMEPAGE="https://github.com/FedoraQt/adwaita-qt"
SRC_URI="https://github.com/FedoraQt/${PN}/archive/${PV}/${P}.tar.gz"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+qt5 qt6 +X"
REQUIRED_USE="
	|| ( qt5 qt6 )
	X? ( qt5 )
"

DEPEND="
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtwidgets:5
		X? (
			dev-qt/qtx11extras
			x11-libs/libxcb
		)
	)
	qt6? (
		dev-qt/qtbase:6[dbus,gui,widgets]
	)
"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/allow-optional-X11.patch" )

pkg_setup() {
	MULTIBUILD_VARIANTS=( $(usev qt5) $(usev qt6) )
}

src_configure() {
	my_src_configure() {
		if [[ ${MULTIBUILD_VARIANT} == qt5 ]]; then
			local mycmakeargs=(
				-DUSE_QT6=OFF
				-DUSE_XCB="$(usex X)"
			)
		fi
		if [[ ${MULTIBUILD_VARIANT} == qt6 ]]; then
			local mycmakeargs=(
				-DUSE_QT6=ON
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
}
