# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/rope/rope-9999.ebuild,v 1.0 2009/09/16 02:20:00 tek Exp $

EAPI="2"

PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"
EHG_REPO_URI="http://bitbucket.org/agr/rope"

inherit distutils mercurial

DESCRIPTION="Python refactoring library"
HOMEPAGE="http://rope.sourceforge.net/ http://pypi.python.org/pypi/rope"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND=""

pkg_setup() {
	S=${WORKDIR}/${PN}
}

src_install() {
	distutils_src_install
	docinto docs
	dodoc docs/*.txt
}
