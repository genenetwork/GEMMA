#!/usr/bin/env bash

gemma=../bin/gemma

testCenteredRelatednessMatrixKLOCO1() {
    outn=mouse_hs1940_LOCO1
    $gemma -g ../example/mouse_hs1940.geno.txt.gz -p ../example/mouse_hs1940.pheno.txt \
           -a ../example/mouse_hs1940.anno.txt -loco 1 -gk -o $outn
    assertEquals 0 $?
    grep "total computation time" < output/$outn.log.txt
    outfn=output/$outn.cXX.txt
    assertEquals 0 $?
    assertEquals "1940" `wc -l < $outfn`
    assertEquals "3763600" `wc -w < $outfn`
    assertEquals "0.324" `head -c 5 $outfn`
    assertEquals "24.9799" `perl -nle '$sum += substr($_,0,6) } END { print $sum' $outfn`
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
