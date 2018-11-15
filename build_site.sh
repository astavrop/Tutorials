#!/bin/bash

# cleanup
rm -rf Tutorials
rm -rf API
#rm index.md

# copy folders & files
cp -r ../Tutorials .
cp ../index.md .

# create directories
mkdir -p ./_data/sidebars
mkdir -p API
mkdir -p tmp
cd tmp

# --------------
# build index
# --------------

# clone & build escript
echo "Building EScript..."
git clone https://github.com/EScript/EScript.git escript &> /dev/null && cd escript
cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_ESCRIPT_APPLICATION=ON -DBUILD_ESCRIPT_TEST=OFF . && make && cd ..
echo "done"

echo "Collecting Timestamps..."
export LC_TIME="en_US.UTF-8"
echo "{" > timestamps.json
git ls-tree -r --name-only HEAD ../../Tutorials | while read filename; do
  echo "\"${filename:3}\": \"$(git log -1 --date=format:"%B %d, %Y" --format="%ad" -- "$filename")\"," >> timestamps.json
done
echo "}" >> timestamps.json
echo "done"

# build table of contents & update code sections
echo "Building TOC..."
./escript/EScript/escript ../../Tools/MarkDownTool.escript -t -c -o=../_data/sidebars/home_sidebar.yml -s=timestamps.json ../Tutorials
echo "done"

# --------------
# build api docs
# --------------

# Geometry
echo "Building Geometry doc..."
git clone https://github.com/PADrend/Geometry.git Geometry &> /dev/null
cd Geometry && doxygen doc/Doxyfile | grep error
cd .. && mv Geometry/doc/html ../API/Geometry
echo "done"

# GUI
echo "Building GUI doc..."
git clone https://github.com/PADrend/GUI.git GUI &> /dev/null
cd GUI && doxygen doc/Doxyfile | grep error
cd .. && mv GUI/doc/html ../API/GUI
echo "done"

# Rendering
echo "Building Rendering doc..."
git clone https://github.com/PADrend/Rendering.git Rendering &> /dev/null
cd Rendering && doxygen doc/Doxyfile | grep error
cd .. && mv Rendering/doc/html ../API/Rendering
echo "done"

# Util
echo "Building Util doc..."
git clone https://github.com/PADrend/Util.git Util &> /dev/null
cd Util && doxygen doc/Doxyfile | grep error
cd .. && mv Util/doc/html ../API/Util
echo "done"

# MinSG
echo "Building MinSG doc..."
git clone https://github.com/PADrend/MinSG.git MinSG &> /dev/null
cd MinSG && doxygen doc/Doxyfile | grep error
cd .. && mv MinSG/doc/html ../API/MinSG
echo "done"

# cleanup
cd ..
#rm -rf tmp
