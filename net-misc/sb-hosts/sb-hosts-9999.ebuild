# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 savedconfig

DESCRIPTION="Consolidating and extending hosts files from several well-curated sources"
HOMEPAGE="https://github.com/StevenBlack/hosts"
EGIT_REPO_URI="https://github.com/StevenBlack/hosts.git"

LICENSE="MIT"
SLOT="0"
IUSE="fakenews gambling porn social"

src_prepare() {
	default
	restore_config myhosts
}

src_install() {
	insinto "/etc"

	if ( use fakenews || use gambling || use porn || use social ); then
		NEW_HOSTS="./alternates/"
		ADD_DASH=false
		if use fakenews; then
			check_dash
			NEW_HOSTS+="fakenews"
		fi
		if use gambling; then
			check_dash
			NEW_HOSTS+="gambling"
		fi
		if use porn; then
			check_dash
			NEW_HOSTS+="porn"
		fi
		if use social; then
			check_dash
			NEW_HOSTS+="social"
		fi
		NEW_HOSTS+="/hosts"
		doins ${NEW_HOSTS}
	else
		doins ./hosts
	fi

	save_config myhosts
}

check_dash(){
	if ${ADD_DASH}; then
		NEW_HOSTS+="-"
	else
		ADD_DASH=true
	fi
}
