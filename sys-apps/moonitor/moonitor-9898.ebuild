# Copyright 2009 Torsten Schmits
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

EGIT_BRANCH="plasma"

inherit eutils cmake-utils git

EGIT_REPO_URI="git://moonitor.org/moonitor.git"

DESCRIPTION="A dbus monitoring suite for package managers with KDE panel support"

HOMEPAGE="http://moonitor.org"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="x86 amd64"

IUSE="kde4 qt4 paludis daemon"

BDEPS=">=dev-libs/boost-1.34.1
		~sys-libs/dbus-c++-9999
		kde4? ( kde-base/plasma-workspace )
		qt4? ( >=x11-libs/qt-gui-4.4 )"

DEPEND="${BDEPS}"

RDEPEND="${BDEPS}
		dev-python/dbus-python
	 	app-portage/portage-utils"

_modify-cmakelists() {
	:
}

pkg_setup() {
	if use daemon ; then
		enewuser moonitor
	fi
}

src_configure() {
	mycmakeargs="$(cmake-utils_use_with qt4) $(cmake-utils_use_with kde4)
				 $(cmake-utils_use_with paludis) $(cmake-utils_use_with daemon)
				 -DKDEDIR=$(kde4-config --prefix)"
	cmake-utils_src_configure
}
