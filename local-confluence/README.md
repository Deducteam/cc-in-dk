# Verifying local confluence of $\mathcal{R}_2$

The files `csi.txt` and `sol.txt` are respectively the outputs of CSI^ho and SOL for the confluence of $\mathcal{R}_2$. Note that both systems answer MAYBE: they check that critical pairs close (allowing us to conclude local confluence) but are both unable to show SN, which would allow to conclude confluence.

The fact that critical pairs close is reported on line 89 of the CSI^ho output, and on line 140 of the SOL output. Note however that they do not report the same number of critical pairs: CSI^ho reports 29 whereas SOL reports 19. This is because SOL consider two symmetric critical pairs ($t \longleftarrow\longrightarrow u$ and $u \longleftarrow\longrightarrow t$) to be the same one, and the rewrite system contains exactly 10 symmetric critical pairs, justifying the difference of reported numbers.

## Reproducing the results


In order to reproduce the verification, we need the tools:

- [Lambdapi (with improved export)](https://github.com/thiagofelicissimo/lambdapi/tree/c21abb4c57f1d879a266227fd326976d7bc5b6a0)
- CSI^ho 0.3.2 ([precompiled binary](http://cl-informatik.uibk.ac.at/software/csi/ho))
- SOL unknown version ([web interface](http://solweb.mydns.jp/webcui/sol/))

First we copy `../cc.lp` into this directory
```
cp ../cc.lp temp.lp
```
and then we comment out the following lines in `temp.lp`, corresponding to rules not in $\mathcal{R}_2$ (lines 61, 62, 69, 73 and 75):
```
rule ⋄                            ⇒ $l₁ ↪ U $l₁;
rule (◁ $l₂ $A (λ x : _, $Δ.[x])) ⇒ $l₁ ↪ Π x : El $l₂ $A, $Δ.[x] ⇒ $l₁;
rule ◁ $l (↑ _ ⋄ $A) $Δ ↪ ◁ (P $l) $A $Δ;
rule ↑ $l (◁ _ _ (λ x : _,$Δ.[x])) (λ x : $A, $t.[x])   ↪ λ x : $A, ↑ $l $Δ.[x] $t.[x];
rule ↑ $l (◁ _ _ (λ x : _,$Δ.[x])) $t $u                ↪ ↑ $l $Δ.[$u] ($t $u);
```
Using Lambdapi, we now export the rewrite system into the TRS format by running
```
lambdapi export -w --no-sr-check -o hrs temp.lp > temp2.trs
```
In order to render the output more readable we can remove qualified names by running the following
```
bash remove-qualified-names.sh temp2.trs temp3.trs
```
Finally, we need to remove the lines (108 and 109)
```
A(L(*x,*y),*z) -> *y(*z),
B(*x,*z,*y) -> *y(*z),
```
from `temp3.trs`, which correspond to the beta rule and an internal rule for let used by Lambdapi, as these are not part of $\mathcal{R}_2$.

Now we can verify the file using CSI^ho and SOL.

### CSI^ho

In order to check for local confluence with CSI^ho, we run the following command. The option `-C HOCR` selects the higher-order Church-Rosser processor, and the option `-s 'hocr -kb'` asks it to first check that critical pairs close and return a termination problem if this is the case (we can replace `-kb` by `-help` to see all the options supported by `hocr`).
```
./csiho -C HOCR -s 'hocr -kb' temp3.trs
```
The output produced is the same as in `csi.txt`.

### SOL

Because SOL does not support unicode characters, we first need to rename them by running
```
bash remove-unicode.sh temp3.trs temp4.trs
```
Then, go to http://solweb.mydns.jp/webcui/sol/ load the file `temp4.trs` and choose TRS in the field format and CR in the field check. After pressing the button check we get the output shown in `sol.txt`

