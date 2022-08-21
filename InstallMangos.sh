

  cd "/sources/linux"


P_SOAP="0"
P_DEBUG="0"
P_STD_MALLOC="1"
P_ACE_EXTERNAL="1"
P_PGRESQL="0"
P_TOOLS="1"
P_SD3="1"
P_ELUNA="1"
P_BOTS="1"

  cmake .. -DDEBUG=$P_DEBUG -DUSE_STD_MALLOC=$P_STD_MALLOC -DACE_USE_EXTERNAL=$P_ACE_EXTERNAL -DPOSTGRESQL=$P_PGRESQL -DBUILD_TOOLS=$P_TOOLS -DSCRIPT_LIB_ELUNA=$P_ELUNA -DSCRIPT_LIB_SD3=$P_SD3 -DSOAP=$P_SOAP -DPLAYERBOTS=$P_BOTS -DCMAKE_INSTALL_PREFIX="/mangos"
  make

mkdir /mangos
cp /sources/linux/src/tools/Extractor_projects/Movemap-Generator/movemap-generator /mangos
cp /sources/linux/src/tools/Extractor_projects/map-extractor/map-extractor /mangos
cp /sources/linux/src/tools/Extractor_projects/vmap-extractor/vmap-extractor /mangos
cp /sources/linux/src/mangosd/mangosd /mangos
cp /sources/linux/src/realmd/realmd /mangos

rm -rf /sources 
