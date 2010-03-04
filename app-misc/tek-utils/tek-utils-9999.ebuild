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

IUSE="media mail"

DEPEND="dev-util/cmake"

RDEPEND=">=dev-lang/python-2.5
		 dev-python/tek
		 media? ( >=media-libs/mutagen-1.16 )
		 mail? ( net-mail/lbdb dev-python/vobject )"

src_unpack(){
	git_src_unpack
}

src_compile() {
	mycmakeargs="$(cmake-utils_use_with media) $(cmake-utils_use_with mail)"
	cmake-utils_src_compile
}
