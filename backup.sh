#!/bin/sh

backdir=/home/xuq7
tmpdir=/home/xuq7/baidu
uploadoption='overwrite'
datenow=`date +%Y%m%d%H%M`
backdir_=`echo ${backdir} | sed -e "s/\//\%/g"`

if [[ $(date +%u) -eq 1 ]]; then
backfile=backup_${backdir_}_${datenow}.tar.gz
else
backfile=backup_${backdir_}.tar.gz
fi

echo `date` >> ${tmpdir}/upload.log
if [ ! -f ${tmpdir}/${backfile} ]; then
echo "taring:......" >> ${tmpdir}/upload.log
timestart=`date +%s`
cp ~/.bashrc ~/Desktop/
tar -P -zcf ${tmpdir}/${backfile} ${backdir} --exclude=${tmpdir}/${backfile} --exclude=".*" --exclude=autocms --exclude=bin --exclude=lib --exclude=git --exclude=include --exclude=lib --exclude=lib64 --exclude=libexec --exclude=share --exclude=undelivered >> ${tmpdir}/upload.log
rm ~/Desktop/.bashrc
echo "taring done!" >> ${tmpdir}/upload.log
timeend=`date +%s`
tartime=$((${timeend}-${timestart}))
tarminutes=`echo "${tartime}/60" | bc`
tarseconds=`echo "${tartime}%60" | bc`
echo "taring time: ${tarminutes} minutes and ${tarseconds} seconds" >>  ${tmpdir}/upload.log

fi

echo "uploading: ${tmpdir}/${backfile}" >> ${tmpdir}/upload.log
filesize=`du -sh ${tmpdir}/${backfile} | awk '{ print $1}'`
echo "size is:${filesize},  Directory is: ${backdir}" >> ${tmpdir}/upload.log
filesize=`stat -c%s ${tmpdir}/${backfile}`
timestart=`date +%s`
if [[ ${filesize} -le 1073741824 ]]; then
${tmpdir}/bpcs_uploader.php upload ${tmpdir}/${backfile} ${backfile} $uploadoption >> ${tmpdir}/upload.log 
elif [[ ${filesize} -gt 1073741824 ]]; then
${tmpdir}/bpcs_uploader.php uploadbig ${tmpdir}/${backfile} ${backfile} $uploadoption >> ${tmpdir}/upload.log
fi
timeend=`date +%s`
uploadtime=$((${timeend}-${timestart}))
uploadminutes=`echo "${uploadtime}/60" | bc`
uploadseconds=`echo "${uploadtime}%60" | bc`
echo "uploading time: ${uploadminutes} minutes and ${uploadseconds} seconds" >>  ${tmpdir}/upload.log
echo "removing local zipped file..." >> ${tmpdir}/upload.log
rm ${tmpdir}/${backfile}
echo "Done!" >> ${tmpdir}/upload.log 
echo "---------------------------------------------------------------------" >> ${tmpdir}/upload.log
echo "" >> ${tmpdir}/upload.log
