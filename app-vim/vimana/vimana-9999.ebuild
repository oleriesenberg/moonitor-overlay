# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit git perl-module

DESCRIPTION="System for searching, installing, and downloading vim scripts"
HOMEPAGE="http://search.cpan.org/~cornelius/Vimana-0.04/lib/Vimana.pm"
EGIT_REPO_URI="git://github.com/c9s/Vimana.git"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="dev-perl/App-CLI
		 dev-perl/Cache
		 dev-perl/File-Path
		 dev-perl/File-Type
		 dev-perl/File-Find-Rule
		 dev-perl/Exporter-Lite
		 dev-perl/File-Which
		 dev-perl/File-Copy-Recursive
		 dev-perl/Class-Accessor"
