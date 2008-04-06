# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit gems

DESCRIPTION="Atchoum helps you build cool static website composed of html files by helping you write less code and use the mighty power of Markaby http://code.whytheluckystiff.net/markaby/."
HOMEPAGE="http://code.macournoyer.com/atchoum/"

SRC_URI="http://code.macournoyer.com/gems/${P}.gem"

LICENSE="Ruby License"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

USE_RUBY="any"

DEPEND="dev-ruby/markaby"
RDEPEND="${DEPEND}" 
