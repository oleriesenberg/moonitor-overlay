# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git cmake-utils

EGIT_REPO_URI="git://moonitor.org/mootils.git"

HOMEPAGE="http://moonitor.org"

DESCRIPTION="some package mask handling python tools using eix search"

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-util/cmake"

RDEPEND="|| (app-portage/eix sys-apps/paludis[>=0.58.0])
		 dev-python/tek"

src_unpack(){
	git_src_unpack
}

src_compile() {
	cmake-utils_src_compile
}
