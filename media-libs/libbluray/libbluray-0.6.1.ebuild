# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libbluray/libbluray-0.6.1.ebuild,v 1.1 2014/08/05 09:49:31 polynomial-c Exp $

EAPI=5

inherit autotools java-pkg-opt-2 flag-o-matic eutils multilib-minimal

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="http://www.videolan.org/developers/libbluray.html"
SRC_URI="http://ftp.videolan.org/pub/videolan/libbluray/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE="aacs java static-libs +truetype utils +xml"

COMMON_DEPEND="
	xml? ( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )
	truetype? ( >=media-libs/freetype-2.5.0.1:2[${MULTILIB_USEDEP}] )
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
	aacs? ( >=media-libs/libaacs-0.6.0[${MULTILIB_USEDEP}] )
	java? ( ${JDK_DEPEND} )
"
DEPEND="
	${COMMON_DEPEND}
	java? (
		${JDK_DEPEND}
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

		java-pkg-opt-2_src_prepare
	fi

	eautoreconf
}

multilib_src_configure() {
	local myconf
	if multilib_is_native_abi && use java; then
		export JAVACFLAGS="$(java-pkg_javac-args)"
		append-cflags "$(java-pkg_get-jni-cflags)"
		myconf="--enable-bdjava"
	else
		myconf="--disable-bdjava"
	fi

	ECONF_SOURCE="${S}" econf \
		--disable-optimizations \
		$(multilib_native_use_enable utils examples) \
		$(use_with truetype freetype) \
		$(use_enable static-libs static) \
		$(use_with xml libxml2) \
		${myconf}
}

multilib_src_install() {
	emake DESTDIR="${D}" install

	if multilib_is_native_abi && use utils; then
		cd src
		dobin index_dump mobj_dump mpls_dump
		cd .libs/
		dobin bd_info bdsplice clpi_dump hdmv_test libbluray_test list_titles sound_dump
		if use java; then
			dobin bdj_test
		fi
	fi

	if multilib_is_native_abi && use java; then
		java-pkg_newjar "${BUILD_DIR}"/src/.libs/${PN}-j2se-${PV}.jar
		doenvd "${FILESDIR}"/90${PN}
	fi
}

multilib_src_install_all() {
	einstalldocs
	prune_libtool_files
}
