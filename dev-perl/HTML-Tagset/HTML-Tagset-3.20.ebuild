# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-Tagset/HTML-Tagset-3.20.ebuild,v 1.6 2010/01/10 12:40:13 grobian Exp $

inherit perl-module

DESCRIPTION="data tables useful in parsing HTML"
SRC_URI="mirror://cpan/authors/id/P/PE/PETDANCE/${P}.tar.gz"
HOMEPAGE="http://search.cpan.org/search?module=${PN}"

SLOT="0"
LICENSE="|| ( Artistic GPL-1 )"
KEYWORDS="alpha ~amd64 arm hppa ia64 m68k ~mips ~ppc ~ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd ~ppc-aix ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

SRC_TEST="do"

DEPEND="dev-lang/perl"
