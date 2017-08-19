#!/usr/bin/env bash

gemma=../bin/gemma

# Test for https://github.com/genetics-statistics/GEMMA/issues/45
testIssue45() {
    outn=issue45
    $gemma -bfile data/issue45/WisAsp_BCFfiltered_VCFfiltered_vcf-merge_VCFfiltered-take2_maf05_plink_LinkImpute_LDprune_removedrelatedsamples \
           -gk 1 -debug -issue 45 -o $outn
    assertEquals 0 $?
    outfn=output/$outn.cXX.txt
    assertEquals "439" `wc -l < $outfn`
    assertEquals "-1209.36" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

testIssue45LMM() {
    return
    # univariate version
    testname=issue45LMM
    datadir=../example
    $gemma -bfile -bfile data/issue45/WisAsp_BCFfiltered_VCFfiltered_vcf-merge_VCFfiltered-take2_maf05_plink_LinkImpute_LDprune_removedrelatedsamples \
           -k output/issue45.cXX.txt \
           -lmm 1 \
           -maf 0.1 \
           -issue 45 \
           -o $testname
    assertEquals 0 $?
    outfn=output/$testname.assoc.txt
    assertEquals "89110" `wc -l < $outfn`
    assertEquals "3442900275.33" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

# Long running!
testIssue45LMM4() {
    return
    testname=issue45LMM4
    datadir=../example
    $gemma -bfile -bfile data/issue45/WisAsp_BCFfiltered_VCFfiltered_vcf-merge_VCFfiltered-take2_maf05_plink_LinkImpute_LDprune_removedrelatedsamples \
           -k output/issue45.cXX.txt \
           -lmm 4 \
           -n 13 15  \
           -issue 45 \
           -o $testname
    assertEquals 0 $?
    outfn=output/$testname.assoc.txt
    assertEquals "8001" `wc -l < $outfn`
    assertEquals "9352494.49" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

# issue 45: run with the fixed K
testIssue45LMM4b() {
    testname=issue45LMM4b
    datadir=../example
    $gemma -bfile -bfile data/issue45/WisAsp_BCFfiltered_VCFfiltered_vcf-merge_VCFfiltered-take2_maf05_plink_LinkImpute_LDprune_removedrelatedsamples \
           -k data/issue45/normalizedKinshipForGEMMA.cxx.txt \
           -lmm 4 \
           -n 13 15  \
           -issue 45 \
           -o $testname
    assertEquals 0 $?
    outfn=output/$testname.assoc.txt
    assertEquals "139571" `wc -l < $outfn`
    assertEquals "5508486924.44" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

# Test for https://github.com/genetics-statistics/GEMMA/issues/26
# Always getting 'pve estimate =0.99xxx se(pve) =-nan'
testIssue26() {
    outn=issue26
    rm -f output/$outn.*
    $gemma -bfile data/issue26/mydata -k data/issue26/mydata_kinship.sXX.txt \
           -miss 1 -maf 0.01 -r2 1 -lmm \
           -debug -issue 26 \
           -o $outn
    assertEquals 0 $?
    outfn=output/$outn.assoc.txt
    grep "total computation time" < output/$outn.log.txt
    assertEquals 0 $?
    assertEquals "2001" `wc -l < $outfn`
    assertEquals "1582899231.18" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

testCenteredRelatednessMatrixKLOCO1() {
    outn=mouse_hs1940_LOCO1
    rm -f output/$outn.*
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
           -a ../example/mouse_hs1940.anno.txt -snps ../example/mouse_hs1940_snps.txt -nind 400 -loco 1 -gk -debug -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    outfn=output/$outn.cXX.txt
    assertEquals 0 $?
    assertEquals "400" `wc -l < $outfn`
    assertEquals "0.312" `head -c 5 $outfn`
    assertEquals "71.03" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

testUnivariateLinearMixedModelLOCO1() {
    outn=mouse_hs1940_CD8_LOCO1_lmm
    rm -f output/$outn.*
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
	   -n 1 \
	   -loco 1 \
           -a ../example/mouse_hs1940.anno.txt -k ./output/mouse_hs1940_LOCO1.cXX.txt \
	   -snps ../example/mouse_hs1940_snps.txt -lmm \
	   -nind 400 \
	   -debug \
           -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    assertEquals 0 $?
    outfn=output/$outn.assoc.txt
    assertEquals "68" `wc -l < $outfn`
    assertEquals "15465553.30" `perl -nle 'foreach $x (split(/\s+/,$_)) { $sum += sprintf("%.2f",(substr($x,,0,6))) } END { printf "%.2f",$sum }' $outfn`
}

shunit2=`which shunit2`

if [ -x "$shunit2" ]; then
    echo run system shunit2
    . $shunit2
elif [ -e ../contrib/shunit2-2.0.3/src/shell/shunit2 ]; then
    echo run shunit2 provided in gemma repo
    . ../contrib/shunit2-2.0.3/src/shell/shunit2
else
    echo "Can not find shunit2 - see INSTALL.md"
fi
