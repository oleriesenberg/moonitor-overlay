# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: Exp $

inherit gems

DESCRIPTION="A fast and very simple Ruby web server"
HOMEPAGE="http://code.macournoyer.com/thin/"

LICENSE="GPL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE=""

USE_RUBY="any"
DEPEND=">=dev-ruby/eventmachine-0.10.0
	>=dev-ruby/rack-0.2.0
	>=dev-ruby/daemons-1.0.3"
 
pkg_postinst() {
	ewarn
	ewarn "To use Thin w/ UNIX sockets you need EventMachine 0.11.0"
	ewarn
}