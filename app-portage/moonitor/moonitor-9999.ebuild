# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git qt3 cmake-utils

EGIT_REPO_URI="git://moonitor.org/moonitor.git"

DESCRIPTION="A dbus monitoring suite for emerge with KDE panel support"

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~x86 ~amd64"


IUSE="kde qt3 ncurses"

BDEPS=">=dev-libs/boost-1.34.1
		sys-libs/dbus-c++
		kde? ( || ( kde-base/kicker kde-base/kdebase ) )
		qt3? ( >=x11-libs/qt-3.3 )
		ncurses? ( =sys-libs/ndk++-9999 )"

DEPEND="${BDEPS}
		dev-util/cmake"

RDEPEND="${BDEPS}
		dev-python/dbus-python
	 	app-portage/portage-bashrc-ng
	 	app-portage/portage-utils"

pgk_setup() {
	if ! built_with_use dev-libs/boost threads ; then
		eerror
		eerror "dev-libs/boost missing threads support."
		eerror "Please rebuild boost with USE=\"threads\""
		eerror
		die
	fi
}

src_compile() {
	mycmakeargs="$(cmake-utils_use_with qt3) $(cmake-utils_use_with kde)
	$(cmake-utils_use_with ncurses)"
	cmake-utils_src_compile
}

pkg_postinst() {
	ewarn
	ewarn "In order to use moonitor, you have to append \"moonitor=on\" to"
	ewarn "/etc/portage/bashrc-ng/bashrc-ng.conf to activate the bashrc module."
	ewarn
	ewarn "You can enter your favourite emerge command in /etc/moonitor/moonitor.conf."
	ewarn "If you are using <app-portage/cfg-update-1.8.2, you have to set it to"
	ewarn "\"/usr/bin/emerge_with_indexing_for_cfg-update\""
	ewarn
	ewarn "To own the moonitor dbus service, your user must be a member of the portage group."
	ewarn
	ewarn "DO NOT report bugs to Gentoo's bugzilla"
	ewarn "Please report all bugs to http://trac.moonitor.org"
}
