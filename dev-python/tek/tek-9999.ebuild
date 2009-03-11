# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git cmake-utils

EGIT_REPO_URI="git://moonitor.org/pytek.git"

HOMEPAGE=""

DESCRIPTION=""

RESTRICT="mirror"

LICENSE="GPL-2"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-util/cmake
		dev-util/git"

RDEPEND=">=dev-lang/python-2.5"

src_unpack(){
	git_src_unpack
}

src_compile() {
	cmake-utils_src_compile
}
