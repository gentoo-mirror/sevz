# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Arch Linux wallpapers"
HOMEPAGE="https://bbs.archlinux.org/viewtopic.php?id=259604"
SRC_URI="https://github.com/xyproto/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="CC0-1.0 SPL"

SLOT="0"
KEYWORDS="~*"

src_install() {
	insinto /usr/share/backgrounds/archlinux
	doins img/* archlinux.stw

	insinto /usr/share/gnome-background-properties
	doins arch-backgrounds.xml

	einstalldocs
}
