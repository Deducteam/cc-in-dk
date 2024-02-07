# Verifying SN of $\mathcal{R}_2$

The file `proof.html` provides a proof of SN of $\mathcal{R}_2$ (seen as a first-order system, as explained in the paper) generated automatically by the AProVE termination checker and certified by the formally verified tool CeTA.

## How to reproduce the verification

In order to reproduce the verification, we need the tools:

- Lambdapi ([with improved export](https://github.com/thiagofelicissimo/lambdapi/tree/c21abb4c57f1d879a266227fd326976d7bc5b6a0))
- [CeTA 2.46](http://cl-informatik.uibk.ac.at/software/ceta/versions.php)
- [AProVe](https://github.com/aprove-developers/aprove-releases/releases/tag/master_2023_12_29)

First we copy `../cc.lp` into this directory
```
cp ../cc.lp temp.lp
```
and then we comment out the following lines (61, 62, 69, 73 and 75) of `temp.lp`, corresponding to rules not in R2:
```
rule ⋄                            ⇒ $l₁ ↪ U $l₁;
rule (◁ $l₂ $A (λ x : _, $Δ.[x])) ⇒ $l₁ ↪ Π x : El $l₂ $A, $Δ.[x] ⇒ $l₁;
rule ◁ $l (↑ _ ⋄ $A) $Δ ↪ ◁ (P $l) $A $Δ;
rule ↑ $l (◁ _ _ (λ x : _,$Δ.[x])) (λ x : $A, $t.[x])   ↪ λ x : $A, ↑ $l $Δ.[x] $t.[x];
rule ↑ $l (◁ _ _ (λ x : _,$Δ.[x])) $t $u                ↪ ↑ $l $Δ.[$u] ($t $u);
```
Using Lambdapi, we now export the rewrite system into the TRS format by running
```
lambdapi export -w --no-sr-check -o trs temp.lp > temp2.trs
```
This export performs the translation described in the article, which forgets the binders of $\lambda$ and $\Pi$. In order to render the output more readable we can remove qualified names by running the following
```
bash remove-qualified-names.sh temp2.trs temp3.trs
```
Now we can run
```
java -ea -jar aprove.jar -C ceta -p html temp3.trs > proof.html
```
which runs AProVE and produces a human-readable HTML termination proof. The resulting proof can also be certified with CeTA. In order to do this, we first have to remove the unicode symbols from the trs file, as these cause problems with CeTA. This can be done by running
```
bash remove-unicode.sh temp3.trs temp4.trs
```
Then we can run
```
java -ea -jar aprove.jar -C ceta -p cpf temp4.trs > certificate.xml
```
and verify the result on CeTA by using
```
./ceta certificate.xml
```
which outputs `CERTIFIED`.

Alternatively, you can use the [AProVE web interface](https://aprove.informatik.rwth-aachen.de/interface/v-AProVE2023/trs_wst) on `temp4.trs` (`temp3.trs` wouldn't work because the web interface doesn't support unicode) to check termination.

