#!/bin/bash

madgraph5_path="매드그래프 경로"

# argv1 = Wp mass
# argv2 = coupling constant(kL)
# argv3 = file number

# argv4 = nevents
# argv5 = ptl
# argv6 = ptlmax




filename="KL${1}_${2}_${3}"
ptlmin=$5
ptlmax=$6
coupling=$((${2}/10))


cat << EOF > card_${1}_${2}_${3}.sh  
#!/bin/bash

export SCRAM_ARCH=slc6_amd64_gcc700
export VO_CMS_SW_DIR=/cvmfs/cms.cern.ch
echo "\$VO_CMS_SW_DIR \$SCRAM_ARCH"
source \$VO_CMS_SW_DIR/cmsset_default.sh
export SSL_CERT_DIR='/etc/grid-security/certificates'
cd /home/cykim/CMSSW_10_2_23/src ; echo "cmsenv"  
cd -

#script 파일
cat << EOF > script_${1}_${2}_${3}
import model VPrime_NLO

generate p p > e+ ve
add process p p > e- ve~

output $filename
launch $filename

set kl $coupling
set mwp $1
set wwp auto

set nevents $4
set ptl $ptlmin
set ptlmax $ptlmax
$(echo "EOF")



if [ ! -d condorMadOut ]; then mkdir condorMadOut; chmod 777 condorMadOut ; fi
cp script_${1}_${2}_${3} condorMadOut/


$madgraph5_path/bin/mg5_aMC condorMadOut/script_${1}_${2}_${3}


chmod -R 777 $filename ; mv $filename condorMadOut/


EOF



chmod 777 card_${1}_${2}_${3}.sh


# submit 파일
cat << EOF > job_${1}_${2}_${3}.jdl

executable = card_${1}_${2}_${3}.sh
universe = vanilla
error = err/error_\$(Cluster).log
output = output/output_\$(Cluster).log
log = /dev/null
should_transfer_files = YES
transfer_input_files = card_${1}_${2}_${3}.sh 
transfer_output_files = condorMadOut
requirements = (machine == "node01")
when_to_transfer_output = ON_EXIT

queue

EOF

condor_submit job/job_${1}_${2}_${3}.jdl


