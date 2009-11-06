# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit gems

DESCRIPTION="Ruby process monitor"
HOMEPAGE="http://god.rubyforge.org"

SRC_URI="http://gemcutter.org/gems/${P}.gem"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

USE_RUBY="ruby18 ruby19"
DEPEND=""

gem_src_install() {
	newconfd "${FILESDIR}/god.confd" god
	newinitd "${FILESDIR}/god.initd" god
}

