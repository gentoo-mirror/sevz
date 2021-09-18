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
IUSE="ime +grapheme-clustering pgo lto"

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
	filter-flags '-flto*'

	local emesonargs=(
		$(meson_use ime)
		$(meson_feature grapheme-clustering)
		$(meson_use lto b_lto)
		"-Dterminfo=disabled"
		"-Dwerror=false"
	)
	if use lto; then
		emesonargs+=( "-Db_lto_threads=$(makeopts_jobs)" )
	fi
	if use pgo; then
		emesonargs+=( "-Db_pgo=generate" )
	fi
	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use pgo; then
		local build_dir="../${P}-build"
		local script_options="--scroll --scroll-region --colors-regular --colors-bright --colors-256 --colors-rgb --attr-bold --attr-italic --attr-underline --sixel"
		tmp_file=$(mktemp)

		$build_dir/footclient --version
		$build_dir/foot --version
		./scripts/generate-alt-random-writes.py --rows=67 --cols=135 \
		${script_options} ${tmp_file}
		$build_dir/pgo ${tmp_file} ${tmp_file} ${tmp_file}
		rm "${tmp_file}"

		meson configure -Db_pgo=use $build_dir
		meson_src_compile
	fi
}

src_install() {
	meson_src_install
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
}
