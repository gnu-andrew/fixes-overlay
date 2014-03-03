# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libbluray/libbluray-0.5.0.ebuild,v 1.1 2013/12/22 11:03:46 radhermit Exp $

EAPI=5

inherit autotools java-pkg-opt-2 flag-o-matic eutils

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="http://www.videolan.org/developers/libbluray.html"
SRC_URI="http://ftp.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="aacs java static-libs +truetype utils +xml"

COMMON_DEPEND="
	xml? ( dev-libs/libxml2 )
"
JDK_DEPEND="
		|| (
			dev-java/icedtea-bin:7
			dev-java/icedtea-bin:6
			dev-java/icedtea:7
			dev-java/icedtea:6
		)
"

RDEPEND="
	${COMMON_DEPEND}
	aacs? ( media-libs/libaacs )
	java? (
		truetype? ( media-libs/freetype:2 )
		${JDK_DEPEND}
	)
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		truetype? ( media-libs/freetype:2 )
		dev-java/ant-core
	)
	virtual/pkgconfig
"

DOCS=( ChangeLog README.txt )

pkg_setup() {
	JAVA_PKG_WANT_BUILD_VM="
		icedtea-7 icedtea-bin-7 icedtea7
		icedtea-6 icedtea-bin-6 icedtea6 icedtea6-bin"
	JAVA_PKG_WANT_SOURCE="1.6"
	JAVA_PKG_WANT_TARGET="1.6"

	java-pkg-opt-2_pkg_setup
}

src_prepare() {
	if use java ; then
		export JDK_HOME="$(java-config -g JAVA_HOME)"

		# don't install a duplicate jar file
		sed -i '/^jar_DATA/d' src/Makefile.am || die

		eautoreconf

		java-pkg-opt-2_src_prepare
	fi
}

src_configure() {
	local myconf
	if use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		append-cflags "$(java-pkg_get-jni-cflags)"
		myconf="$(use_with truetype freetype)"
	fi

	econf \
		--disable-optimizations \
		$(use_enable utils examples) \
		$(use_enable java bdjava) \
		$(use_enable static-libs static) \
		$(use_with xml libxml2) \
		${myconf}
}

src_install() {
	default

	if use utils; then
		cd src
		dobin index_dump mobj_dump mpls_dump
		cd .libs/
		dobin bd_info bdsplice clpi_dump hdmv_test libbluray_test list_titles sound_dump
		if use java; then
			dobin bdj_test
		fi
	fi

	if use java; then
		java-pkg_dojar "${S}"/src/.libs/${PN}.jar
		doenvd "${FILESDIR}"/90${PN}
	fi

	prune_libtool_files
}
