#!/bin/bash
#--------------------------------------------------------------------------------------------
# Diretorio base de downloads e instalacoes
MAIN_DIR=$HOME/Softwares

#--------------------------------------------------------------------------------------------
# Diretorio de downloads
MAIN_DOWNLOAD_DIR=$MAIN_DIR/Sources

#--------------------------------------------------------------------------------------------
# Diretorio de instalacoes
MAIN_INSTALL_DIR=$MAIN_DIR/Binaries

#--------------------------------------------------------------------------------------------
# Versoes
ALL_VERSION=root_v6.02.03.source

#--------------------------------------------------------------------------------------------
# Caminho para baixar
PATH_TO_DOWNLOAD_ALL=https://root.cern.ch/download/root_v6.02.03.source.tar.gz
#PATH_TO_DOWNLOAD_ALL=https://raw.githubusercontent.com/karies/cling-all-in-one/master/clone.sh

#--------------------------------------------------------------------------------------------
# Script que sera executado contendo LLVM, CLANG e CLING
ALL_FILE=$MAIN_DOWNLOAD_DIR/$ALL_VERSION".tar.gz"

#--------------------------------------------------------------------------------------------
# Diretorios de instalacao
ALL_INSTALL_DIR=$MAIN_INSTALL_DIR/$ALL_VERSION

#--------------------------------------------------------------------------------------------
# Criacao dos diretorios padroes
	# Principal
if ! [ -e $MAIN_DIR ];
	then mkdir $MAIN_DIR;
fi

	# Downloads
if ! [ -e $MAIN_DOWNLOAD_DIR ];
	then mkdir $MAIN_DOWNLOAD_DIR;
fi

	# Instalacoes
if ! [ -e $MAIN_INSTALL_DIR ];
	then mkdir $MAIN_INSTALL_DIR;
fi

#--------------------------------------------------------------------------------------------
# Instalacao do CMAKE, pre-requisito para compilar cling
sudo zypper install git bash make gcc-c++ gcc binutils \
xorg-x11-libX11-devel xorg-x11-libXpm-devel xorg-x11-devel \
xorg-x11-proto-devel xorg-x11-libXext-devel

#--------------------------------------------------------------------------------------------
# LLVM + CLANG + CLING
	# Download arquivo
#cd $MAIN_DONLOAD_DIR #Softwares/Sources
if ! [ -e $ALL_FILE ];
	then wget -P $MAIN_DOWNLOAD_DIR $PATH_TO_DOWNLOAD_ALL;
fi

# Descompactacao do source
cd $MAIN_DOWNLOAD_DIR
tar -xzvf $ALL_FILE

	# Configuracao  
cd $MAIN_DOWNLOAD_DIR/$ALL_VERSION # Sources/root
./configure --prefix=/usr/local 
make -j2
make install
