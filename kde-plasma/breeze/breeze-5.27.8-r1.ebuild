# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm plasma.kde.org

DESCRIPTION="Breeze visual style for the Plasma desktop (just xcursor theme)"
HOMEPAGE="https://invent.kde.org/plasma/breeze"

LICENSE="GPL-2" # TODO: CHECK
SLOT="5"
KEYWORDS="~amd64"

PDEPEND="kde-frameworks/breeze-icons"

src_prepare() {
	cmake_comment_add_subdirectory libbreezecommon
	cmake_comment_add_subdirectory kstyle
	cmake_comment_add_subdirectory misc

	sed -i -e '/find_package(KF5KCMUtils ${KF5_MIN_VERSION} REQUIRED)/d' \
		-e '/find_package(KF5I18n ${KF5_MIN_VERSION} CONFIG REQUIRED)/d' \
		-e '/ki18n_install(po)/d' CMakeLists.txt
	ecm_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DWITH_DECORATIONS=OFF
		-DWITH_WALLPAPERS=ON
	)

	ecm_src_configure
}

src_install() {
	ecm_src_install

	# cmake files
	rm -r "${ED}"/usr/lib64 || die
}
