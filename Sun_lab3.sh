#! /bin/bash/

##########move the file to the correct directory#############
mkdir Sun_Project1
cd Sun_Project1/
mkdir -p Sun_Project1/DOM
mkdir -p Sun_Project1/CAST
cp ~/0008658-160822134323880.csv Sun_Project1/
cp ~/0008659-160822134323880.csv Sun_Project1/

i=0
arr=("DOM" "CAST")

for file in $(ls Sun_Project1/*.csv)

do

cd ${arr[$i]}
cp ../${file} ./
########sort and remove duplicates##############
head -1 ${file} > ${arr[$i]}_header.txt
sort -nk17,17 ${file} | uniq > ${arr[$i]}_lat_uniq.txt
sort -nk18,18 ${arr[$i]}_lat_uniq.txt | uniq > ${arr[$i]}_lat_long_uniq.txt

########calculate the lines of file and comaper##########
x=$(wc -l ${file}.csv | awk '{print $1}')
y=$(wc -l ${arr[$i]}_lat_long_uniq.txt | awk '{print $1}')
echo "scale=3; (y/x)* 100" | bc

###########grabbing "USNM" and calculate############
grep "USNM" ${arr[$i]}_lat_long_uniq.txt > ${arr[$i]}_USNM.txt 
z=$(wc -l "${arr[$i]}_USNM.txt" | awk '{print $1}')

##########getting clumns 17 and 18#########
awk 'FS="\t" {print $17, $18}' ${arr[$i]}_USNM.txt > ${arr[$i]}_USNM_lat_long.txt
grep -v "^\s*$" ${arr[$i]}_USNM_lat_long.txt > ${arr[$i]}_lat_long_cleaned.txt

#########moving to main directory and combin the cleaned file########
cd ..
((i=i+1))
done

cd Sun_Project1/
cat CAST/CAST_lat_long_cleaned.txt DOM/DOM_lat_long_cleaned.txt > Lat_Long_cleaned.txt
