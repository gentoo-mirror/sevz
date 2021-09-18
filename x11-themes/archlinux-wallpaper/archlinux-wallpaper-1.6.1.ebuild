# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Arch Linux wallpapers"
HOMEPAGE="https://bbs.archlinux.org/viewtopic.php?id=259604"
SRC_URI="https://github.com/xyproto/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="CC0-1.0 SPL"

KEYWORDS="~*"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND=""

SLOT="0"

src_compile() { :; }
src_test() { :; }

src_install() {
	insinto /usr/share/backgrounds/archlinux
	doins img/*.jpg img/*.png archlinux.stw

	insinto /usr/share/gnome-background-properties
	doins arch-backgrounds.xml

	einstalldocs
}
