#!/bin/bash

for i in {1..9}
do 
  wget "http://www.census.gov/geo/cob/bdy/zt/z500shp/zt"0$i"_d00_shp.zip"
done

for i in {10..72} 
do  
  wget "http://www.census.gov/geo/cob/bdy/zt/z500shp/zt"$i"_d00_shp.zip"
done

exit 0;

