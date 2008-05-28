# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit distutils

DESCRIPTION="A Python data processing framework. Implemented algorithms include: Principal Component Analysis (PCA), Independent Component Analysis (ICA), Slow Feature Analysis (SFA), Growing Neural Gas (GNG), Factor Analysis, Fisher Discriminant Analysis (FDA), and Gaussian Classifiers"
HOMEPAGE="http://mdp-toolkit.sourceforge.net/index.html"

MY_P="${P/mdp/MDP}"
MY_P="${MY_P/_rc/RC}"
S="${WORKDIR}/${MY_P}"

SRC_URI="mirror://sourceforge/mdp-toolkit/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""
DEPEND="virtual/python
	>=dev-lang/python-2.4
	>=dev-python/numpy-0.9.8"
RDEPEND="${DEPEND}"

