cp /mangos/movemap-generator /wow
cp /mangos/map-extractor /wow
cp /mangos/vmap-extractor /wow
cd /wow
./map-extractor
./vmap-extractor
./movemap-generator

echo Moving generated files from /wow to /config/wowfiles
echo This may take a while.

mkdir /config/wowfiles
mkdir /config/mangoslogs

mv /wow/mmaps /config/wowfiles
mv /wow/vmaps /config/wowfiles
mv /wow/maps /config/wowfiles
mv /wow/dbc /config/wowfiles

ln -s /config/wowfiles/mmaps /mangos
ln -s /config/wowfiles/vmaps /mangos
ln -s /config/wowfiles/maps /mangos
ln -s /config/wowfiles/dbc /mangos

mkdir /config/wowconfig/

if [ ! -f /config/wowconfig/mangosd.conf ]; then
   cp /install/mangosd.conf /config/wowconfig
fi

if [ ! -f /config/wowconfig/realmd.conf ]; then
   cp /install/realmd.conf /config/wowconfig
fi

echo Script Finished
echo If you want, you can recreate this container without the /wow mapping / world of warcraft installation directory
echo The needed files are now present in the /config directory.
