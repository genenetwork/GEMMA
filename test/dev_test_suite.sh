#!/usr/bin/env bash

gemma=../bin/gemma

testCenteredRelatednessMatrixKLOCO1() {
    outn=mouse_hs1940_LOCO1
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
           -a ../example/mouse_hs1940.anno.txt -snps ../example/snps.txt -nind 400 -loco 1 -gk -debug -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    outfn=output/$outn.cXX.txt
    assertEquals 0 $?
    assertEquals "400" `wc -l < $outfn`
    assertEquals "160000" `wc -w < $outfn`
    assertEquals "0.312" `head -c 5 $outfn`
    assertEquals "-72508" `perl -nle '$sum += substr($_,0,6)*10000 } END { print $sum' $outfn`
}

testUnivariateLinearMixedModelLOCO1() {
    outn=mouse_hs1940_CD8_LOCO1_lmm
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
	   -n 1 \
	   -loco 1 \
           -a ../example/mouse_hs1940.anno.txt -k ./output/mouse_hs1940_LOCO1.cXX.txt \
	   -snps ../example/snps.txt -lmm \
	   -nind 400 \
	   -debug \
           -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    assertEquals 0 $?
    outfn=output/$outn.assoc.txt
    assertEquals "748" `wc -w < $outfn`
    assertEquals "67" `perl -nle '$sum += substr($_,0,6) } END { print $sum' $outfn`
}

shunit2=`which shunit2`

if [ -x "$shunit2" ]; then
    echo run system shunit2
    . $shunit2
elif [ -e shunit2-2.0.3/src/shell/shunit2 ]; then
    echo run shunit2 provided in gemma repo
    . shunit2-2.0.3/src/shell/shunit2
else
    echo "Can not find shunit2 - see INSTALL.md"
fi
