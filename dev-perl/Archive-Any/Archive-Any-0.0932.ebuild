# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Cache/Cache-2.04.ebuild,v 1.5 2007/12/27 13:05:37 ticho Exp $

inherit perl-module

DESCRIPTION="perl stuff"
SRC_URI="http://search.cpan.org/CPAN/authors/id/C/CM/CMOORE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/~cmoore/Archive-Any-0.0932/"

RDEPEND="dev-perl/Archive-Zip
		 virtual/perl-Archive-Tar"

SLOT="0"
LICENSE="Artistic GPL-2"
KEYWORDS="amd64 x86"
IUSE=""
