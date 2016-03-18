# Numero processadorescd 
N=$4

# Diretorio base de downloads e instalacoes OK
MAIN_DIR=$HOME/Softwares

# Diretorio de downloads
MAIN_DOWNLOAD_DIR=$MAIN_DIR/Sources

# Diretorio de instalacoes
MAIN_INSTALL_DIR=$MAIN_DIR/Binaries

#-------------------------------------------------------------------------------------------
# Versoes dos programas OK
ZLIB_VERSION=zlib-1.2.8
LLVM_VERSION=llvm-3.6.0.src
CLANG_VERSION=clang
CLING_VERSION=cling

#-------------------------------------------------------------------------------------------
# Caminhos para download dos programas OK
PATH_TO_DOWNLOAD_ZLIB=zlib.net/zlib-1.2.8.tar.gz
PATH_TO_DOWNLOAD_LLVM=llvm.org/releases/3.6.0/llvm-3.6.0.src.tar.xz
PATH_TO_DOWNLOAD_CLANG=llvm.org/releases/3.6.0/cfe-3.6.0.src.tar.xz
PATH_TO_DOWNLOAD_CLING=https://root.cern.ch/download/root_v5.99.05.source.tar.gz

#-------------------------------------------------------------------------------------------
# Caminhos para os programas baixados OK
ZLIB_FILE=$MAIN_DOWNLOAD_DIR/$ZLIB_VERSION".tar.gz"
LLVM_FILE=$MAIN_DOWNLOAD_DIR/$LLVM_VERSION".tar.xz"
CLANG_FILE=$MAIN_DOWNLOAD_DIR/"cfe-3.6.0.src.tar.xz"
CLING_FILE=$MAIN_DOWNLOAD_DIR/"root_v5.99.05.source.tar.gz"

#-------------------------------------------------------------------------------------------
# Caminhos para instalação dos programas  OK
ZLIB_INSTALL_DIR=$MAIN_INSTALL_DIR/$ZLIB_VERSION
LLVM_INSTALL_DIR=$MAIN_INSTALL_DIR/$LLVM_VERSION
CLANG_INSTALL_DIR=$LLVM_INSTALL_DIR/tools/$CLANG_VERSION
CLING_INSTALL_DIR=$MAIN_INSTALL_DIR/$CLING_VERSION

#-------------------------------------------------------------------------------------------
# Instalacao dos compiladores gcc c++ e fortran, cmake OK
sudo zypper install cmake gcc gcc-fortran gcc-c++ git bash make binutils \
xorg-x11-libX11-devel xorg-x11-libXpm-devel xorg-x11-devel \
xorg-x11-proto-devel xorg-x11-libXext-devel

#-------------------------------------------------------------------------------------------
# Criacao dos diretorios padroes OK
	# Principal
if ! [ -e $MAIN_DIR ];
	then mkdir $MAIN_DIR;
fi

	# Downloads
if ! [ -e $MAIN_DOWNLOAD_DIR ];
	then mkdir $MAIN_DOWNLOAD_DIR;
fi

	# Instalacao
if ! [ -e $MAIN_INSTALL_DIR ];
	then mkdir $MAIN_INSTALL_DIR;
fi

#-------------------------------------------------------------------------------------------
	# Pre-requisitos do Clang
#-------------------------------------------------------------------------------------------
# Zlib OK
	# Criacao do diretorio de instalacao
if ! [ -e $ZLIB_INSTALL_DIR ];
	then mkdir $ZLIB_INSTALL_DIR;
fi

	# Download 
if ! [ -e $ZLIB_FILE ];
	then wget -P $MAIN_DOWNLOAD_DIR $PATH_TO_DOWNLOAD_ZLIB;
fi

	# Descompactacao do source
cd $MAIN_DOWNLOAD_DIR 			# Sources
tar -vzxf $ZLIB_FILE

	# Configuracao e instalacao
cd $ZLIB_VERSION			# Sources/zlib
CC=gcc CXX=g++ FC=gfortran F77=gfortran ./configure --prefix=$ZLIB_INSTALL_DIR
make all -j$N
make install

#-------------------------------------------------------------------------------------------
# Clang OK
	# Download
if ! [ -e $CLANG_FILE ];
	then wget -P $MAIN_DOWNLOAD_DIR $PATH_TO_DOWNLOAD_CLANG;
fi	

#-------------------------------------------------------------------------------------------
# Cling 
	# Criacao do diretorio de instalacao
if ! [ -e $CLING_INSTALL_DIR ];
	then mkdir $CLING_INSTALL_DIR;
fi

	# Download
if ! [ -e $CLING_FILE ];
	then wget -P $MAIN_DOWNLOAD_DIR $PATH_TO_DOWNLOAD_CLING;
fi

#-------------------------------------------------------------------------------------------
# LLVM OK
	# Criacao do diretorio de instalacao
if ! [ -e $LLVM_INSTALL_DIR ];
	then mkdir $LLVM_INSTALL_DIR;
fi

	# Download 
if ! [ -e $LLVM_FILE ];
	then wget -P $MAIN_DOWNLOAD_DIR $PATH_TO_DOWNLOAD_LLVM;
fi

	# Descompactacao do source LLVM
cd $MAIN_DOWNLOAD_DIR			# Sources
tar -xJf $LLVM_FILE

	# Descompactacao do source CLANG e move para LLVM/tools
tar -xJf $CLANG_FILE && mv cfe-3.6.0.src $LLVM_VERSION/tools/$CLANG_VERSION

	# Descompactacao do source CLING e move para LLVM/tools
cd $MAIN_DOWNLOAD_DIR			# Sources
tar -vzxf $CLING_FILE 
mv root $LLVM_VERSION/tools/$CLING_VERSION

	# Configuracao LLVM e Clang e Cling
cd $CLING_INSTALL_DIR			# Binaries/cling
CC=gcc CXX=g++ FC=gfortran F77=gfortran ./configure 
cmake -G "Unix Makefiles" $MAIN_INSTALL_DIR/$LLVM_VERSION/tools/$CLING_VERSION
make install

	# Verificacao da construcao do CLANG e instalacao
cd $MAIN_DOWNLOAD_DIR/$LLVM_VERSION/tools/$CLANG_VERSION
CC=gcc CXX=g++ FC=gfortran F77=gfortran --prefix=$LLVM_INSTALL_DIR 
make test
make install

	# Instalacao LLVM
cd $MAIN_DOWNLOAD_DIR/$LLVM_VERSION			# Sources/LLVM
CC=gcc CXX=g++ FC=gfortran F77=gfortran --prefix=$LLVM_INSTALL_DIR
make install 
#-------------------------------------------------------------------------------------------
# Finalizacao - exportar links para os enderecos padroes

echo "export PATH=$PATH:$ZLIB_INSTALL_DIR/bin:$LLVM_INSTALL_DIR/bin" >> $HOME/.bashrc

echo "export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ZLIB_INSTALL_DIR/lib:$LLVM_INSTALL_DIR/lib" >> $HOME/.bashrc

echo "export INCLUDE=$INCLUDE:$ZLIB_INSTALL_DIR/include:$LLVM_INSTALL_DIR/include" >> $HOME/.bashrc

#-------------------------------------------------------------------------------------------
#-------------------------------------------------------------------------------------------
