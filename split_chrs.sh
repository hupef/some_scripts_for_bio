
file=$1

grep -n ">"  ${file}|awk -F":" '{print $2}' >${file}.names.temp

grep -n ">"  ${file}|awk -F":" '{print $1}' >${file}.lines.temp1
cp ${file}.lines.temp1 ${file}.lines.temp2
wc -l ${file} |awk  '{print $1+1}' >>${file}.lines.temp2
sed -i  '1d' ${file}.lines.temp2 
paste ${file}.lines.temp1 ${file}.lines.temp2|awk '{print $2-$1-1}'|paste ${file}.names.temp - >${file}.temp

cat ${file}.temp |while read line;
do
	line_name=$(echo  $line|awk '{print $1}')
	file_name=${line_name#>}
	line_len=$(echo  $line|awk '{print $2}')
	touch ${file_name}.fasta
	#echo ${line_name} >>${file_name}.fasta
	grep ${line_name} -A ${line_len} ${file} >${file_name}.fasta
	echo ${file_name}.fasta" split done"
done
rm *temp*
