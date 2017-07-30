#!/usr/bin/env bash

gemma=../bin/gemma

testCenteredRelatednessMatrixKFullLOCO1() {
    outn=mouse_hs1940_full_LOCO1
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
           -a ../example/mouse_hs1940.anno.txt -loco 1 -gk -debug -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    outfn=output/$outn.cXX.txt
    assertEquals 0 $?
    assertEquals "400" `wc -l < $outfn`
    assertEquals "160000" `wc -w < $outfn`
    assertEquals "0.312" `head -c 5 $outfn`
    assertEquals "-72508" `perl -nle '$sum += substr($_,0,6)*10000 } END { print $sum' $outfn`
}

testUnivariateLinearMixedModelFullLOCO1() {
    outn=mouse_hs1940_CD8_full_LOCO1_lmm
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
	   -n 1 \
	   -loco 1 \
           -a ../example/mouse_hs1940.anno.txt -k ./output/mouse_hs1940_full_LOCO1.cXX.txt \
	   -lmm \
	   -debug \
           -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    assertEquals 0 $?
    outfn=output/$outn.assoc.txt
    assertEquals "9790" `wc -w < $outfn`
    assertEquals "7590" `perl -nle '$sum += substr($_,0,6) } END { print $sum' $outfn`
}

testCenteredRelatednessMatrixK() {
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
           -gk -o mouse_hs1940
    assertEquals 0 $?
    grep "total computation time" < output/mouse_hs1940.log.txt
    assertEquals 0 $?
    outfn=output/mouse_hs1940.cXX.txt
    assertEquals "1940" `wc -l < $outfn`
    assertEquals "3763600" `wc -w < $outfn`
    assertEquals "0.335" `head -c 5 $outfn`
    assertEquals "24.9799" `perl -nle '$sum += substr($_,0,6) } END { print $sum' $outfn`
}

testUnivariateLinearMixedModel() {
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt -n 1 \
           -a ../example/mouse_hs1940.anno.txt -k ./output/mouse_hs1940.cXX.txt -lmm \
           -o mouse_hs1940_CD8_lmm
    assertEquals 0 $?
    grep "total computation time" < output/mouse_hs1940_CD8_lmm.log.txt
    assertEquals 0 $?
    outfn=output/mouse_hs1940_CD8_lmm.assoc.txt
    assertEquals "118459" `wc -w < $outfn`
    assertEquals "92047" `perl -nle '$sum += substr($_,0,6) } END { print $sum' $outfn`
}

testMultivariateLinearMixedModel() {
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
           -n 1 6 -a ../example/mouse_hs1940.anno.txt -k ./output/mouse_hs1940.cXX.txt \
           -lmm -o mouse_hs1940_CD8MCH_lmm
    assertEquals 0 $?
    grep "total computation time" < output/mouse_hs1940_CD8MCH_lmm.log.txt
    assertEquals 0 $?

    outfn=output/mouse_hs1940_CD8MCH_lmm.assoc.txt
    assertEquals "139867" `wc -w < $outfn`
    assertEquals "92079" `perl -nle '$sum += substr($_,0,6) } END { print $sum' $outfn`
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
