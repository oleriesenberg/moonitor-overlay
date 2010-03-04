# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit perl-module git 

DESCRIPTION="System for searching, installing, and downloading vim scripts"
HOMEPAGE="http://search.cpan.org/~cornelius/Vimana/"
EGIT_REPO_URI="git://github.com/c9s/Vimana.git"
LICENSE="Artistic GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/App-CLI
		 dev-perl/Cache
		 perl-core/File-Path
		 dev-perl/File-Type
		 dev-perl/File-Find-Rule
		 dev-perl/Exporter-Lite
		 dev-perl/File-Which
		 dev-perl/File-Copy-Recursive
		 dev-perl/Class-Accessor
		 dev-perl/Time-Progress
		 dev-perl/Archive-Any
		 dev-perl/DateTime
		 dev-perl/JSON
		 dev-perl/JSON-XS"
