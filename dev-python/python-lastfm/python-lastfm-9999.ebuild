# Copyright 2010 Torsten Schmits
# Distributed under the terms of the GNU General Public License v2

inherit distutils git

EGIT_REPO_URI="git://github.com/tek/python-lastfm.git"
DESCRIPTION="A python interface to the last.fm web services API"
HOMEPAGE="http://code.google.com/p/python-lastfm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""
DEPEND=""
RDEPEND="dev-python/decorator
		 ${DEPEND}"
