# Copyright 1999-2006 moonitor.org
# Distributed under the terms of the GNU General Public License v3
# $Header: $

inherit git cmake-utils

EGIT_REPO_URI="git://moonitor.org/tek-utils.git"

HOMEPAGE=""

DESCRIPTION=""

RESTRICT="mirror"

LICENSE="GPL-3"

SLOT="0"

KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND="dev-util/cmake"

RDEPEND=">=dev-lang/python-2.5
		 dev-python/tek
		 >=media-libs/mutagen-1.16"

src_unpack(){
	git_src_unpack
}

src_compile() {
	cmake-utils_src_compile
}
