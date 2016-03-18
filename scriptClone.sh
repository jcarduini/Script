# Diretorio base de downloads e instalacoes
MAIN_DIR=$HOME/Softwares

# Diretorio de downloads
MAIN_DOWNLOAD_DIR=$MAIN_DIR/Sources

# Diretorio de instalacoes
MAIN_INSTALL_DIR=$MAIN_DIR/Binaries

# Caminho para baixar
PATH_TO_DOWNLOAD_ALL=https://raw.githubusercontent.com/karies/cling-all-in-one/master/clone.sh

# Script que sera executado contendo LLVM, CLANG e CLING
ALL_FILE=$MAIN_DOWNLOAD_DIR/clone.sh


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

# Instalacao do CMAKE, pre-requisito para compilar cling
sudo zypper install cmake

# LLVM + CLANG + CLING
	# Download arquivo
if ! [ -e $ALL_FILE ];
	then wget $MAIN_DOWNLOAD_DIR $PATH_TO_DOWNLOAD_ALL;
fi

	# Configuracao do script 
cd $MAIN_DOWNLOAD_DIR
chmod u+x clone.sh
./clone.sh
