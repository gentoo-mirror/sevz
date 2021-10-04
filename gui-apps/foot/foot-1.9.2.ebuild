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
IUSE="ime +grapheme-clustering pgo"

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
	pgo? ( dev-libs/weston[headless] )
"

src_configure() {
	local emesonargs=(
		$(meson_use ime)
		$(meson_feature grapheme-clustering)
		"-Dterminfo=disabled"
		"-Dwerror=false"
	)
	use pgo && emesonargs+=( "-Db_pgo=generate" )

	meson_src_configure
}

src_compile() {
	meson_src_compile

	if use pgo; then
		export XDG_RUNTIME_DIR="$(mktemp -p $(pwd) -d xdg-runtime-XXXXXX)"
		weston --backend=headless-backend.so --socket=wayland-5 --idle-time=0 &
		local compositor=$!
		export WAYLAND_DISPLAY=wayland-5

		local build_dir="../${P}-build"

		foot_tmp_file=$(mktemp)
		"${build_dir}"/footclient --version
		"${build_dir}"/foot --config=/dev/null --term=xterm sh -c "./scripts/generate-alt-random-writes.py --scroll --scroll-region --colors-regular --colors-bright --colors-256 --colors-rgb --attr-bold --attr-italic --attr-underline --sixel ${foot_tmp_file} && cat ${foot_tmp_file}"
		rm ${foot_tmp_file}

		meson configure -Db_pgo=use "${build_dir}"
		meson_src_compile

		exit_code=$?
		kill "${compositor}"
	fi
}

src_install() {
	meson_src_install
	mv "${D}/usr/share/doc/${PN}" "${D}/usr/share/doc/${PF}" || die
}
