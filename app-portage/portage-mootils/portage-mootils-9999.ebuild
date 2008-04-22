# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git cmake-utils

EGIT_REPO_URI="git://moonitor.org/mootils.git"

HOMEPAGE="http://moonitor.org"

DESCRIPTION="some portage-related python tools and libs using eix search"

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-util/cmake"

RDEPEND=">=dev-lang/python-2.5
		 >=app-portage/eix-0.12.1
		 dev-python/tek"

src_compile() {
	cmake-utils_src_compile
}
