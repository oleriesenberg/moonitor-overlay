# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="1"

NEED_PYTHON=2.5

inherit distutils

DESCRIPTION="Python IDE completion helper"
HOMEPAGE="http://code.google.com/p/pysmell/"
SRC_URI="http://pypi.python.org/packages/source/p/pysmell/${P}.zip"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}
	dev-python/setuptools"

#src_install() {
	#distutils_src_install
#}
