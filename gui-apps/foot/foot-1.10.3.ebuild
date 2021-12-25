# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg flag-o-matic

if [[ ${PV} != *9999* ]]; then
	SRC_URI="https://codeberg.org/dnkl/foot/archive/${PV}.tar.gz  -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}"
else
	inherit git-r3
	EGIT_REPO_URI="https://codeberg.org/dnkl/foot.git"
fi

DESCRIPTION="A fast, lightweight and minimalistic Wayland terminal emulator"
HOMEPAGE="https://codeberg.org/dnkl/foot"
LICENSE="MIT"
SLOT="0"
IUSE="ime +grapheme-clustering pgo themes"

DEPEND="
	grapheme-clustering? ( dev-libs/libutf8proc )
	dev-libs/wayland
	media-libs/fcft
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libxkbcommon
	x11-libs/pixman
"
RDEPEND="
	${DEPEND}
	gui-apps/foot-terminfo
"
BDEPEND="
	app-text/scdoc
	dev-libs/tllist
	dev-libs/wayland-protocols
	sys-libs/ncurses
"

src_configure() {
	use pgo && tc-is-clang && append-cflags -Wno-ignored-optimization-argument

	local emesonargs=(
		$(meson_use ime)
		$(meson_feature grapheme-clustering)
		"-Dterminfo=disabled"
		"-Dwerror=false"
		$(meson_use themes)
	)
	if use pgo; then
		emesonargs+=( "-Db_pgo=generate" )
	fi
	meson_src_configure
}

src_compile() {
	meson_src_compile

	BUILD_DIR="${WORKDIR}/${P}-build"
	if use pgo; then
		tmp_file="$(mktemp -p $(pwd))"
		"${BUILD_DIR}"/footclient --version || die
		"${BUILD_DIR}"/foot --version || die
		./scripts/generate-alt-random-writes.py --rows=67 --cols=135 \
			--scroll --scroll-region --colors-regular --colors-bright \
			--colors-256 --colors-rgb --attr-bold --attr-italic \
			--attr-underline --sixel ${tmp_file} || die
		"${BUILD_DIR}"/pgo "${tmp_file}" "${tmp_file}" "${tmp_file}" || die
		rm "${tmp_file}"

		tc-is-clang && llvm-profdata merge "${S}"/default_*profraw --output="${BUILD_DIR}"/default.profdata || die

		meson configure -Db_pgo=use "${BUILD_DIR}" || die

		meson_src_compile
	fi
}

src_install() {
	meson_src_install
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
}
