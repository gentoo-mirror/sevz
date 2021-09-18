# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An implementation of the MPRIS protocol for MPD."
HOMEPAGE="https://github.com/natsukagami/mpd-mpris"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
RDEPEND=">=media-sound/mpd-0.22.3"
DEPEND="${RDEPEND} dev-lang/go"

inherit go-module

EGO_SUM=(
	"github.com/fhs/gompd/v2 v2.2.0"
	"github.com/fhs/gompd/v2 v2.2.0/go.mod"
	"github.com/godbus/dbus/v5 v5.0.3"
	"github.com/godbus/dbus/v5 v5.0.3/go.mod"
	"github.com/pkg/errors v0.9.1"
	"github.com/pkg/errors v0.9.1/go.mod"
)

go-module_set_globals

SRC_URI="https://github.com/natsukagami/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" ${EGO_SUM_SRC_URI}"

src_compile() {
	go build -v -o mpd-mpris cmd/mpd-mpris/main.go || die
}

src_install() {
	insinto "/usr/lib/systemd/user/"

	dobin mpd-mpris
	doins mpd-mpris.service
	einstalldocs
}
