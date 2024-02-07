
// Universe levels
constant symbol 𝔖 : TYPE;
constant symbol 0 : 𝔖; // 0 = Prop
constant symbol S : 𝔖 → 𝔖; // s n = Typeₙ

symbol 𝔄 : 𝔖 → 𝔖;
rule 𝔄 0      ↪ S (S 0);
rule 𝔄 (S $l) ↪ S (S $l);

symbol P : 𝔖 → 𝔖;
rule P 0      ↪ 0;
rule P (S $l) ↪ $l;

symbol - : 𝔖 → 𝔖 → 𝔖;
notation - infix 7;
rule $l₁ - 0       ↪ $l₁;
rule $l₁ - (S $l₂) ↪ (P $l₁) - $l₂;

symbol + : 𝔖 → 𝔖 → 𝔖;
notation + infix 4;
rule 0       + $l₂     ↪ $l₂
with $l₁     + 0       ↪ $l₁
with (S $l₁) + $l₂     ↪ S ($l₁ + $l₂)
with $l₁     + (S $l₂) ↪ S ($l₁ + $l₂);


symbol ∨ : 𝔖 → 𝔖 → 𝔖;
notation ∨ infix 7;
rule 0       ∨ $l₂     ↪ $l₂
with $l₁     ∨ 0       ↪ $l₁
with (S $l₁) ∨ (S $l₂) ↪ S ($l₁ ∨ $l₂);

symbol 𝔑 : 𝔖 → 𝔖 → 𝔖;
rule 𝔑 $l₁ 0       ↪ 0
with 𝔑 $l₁ (S $l₂) ↪ $l₁ ∨ (S $l₂);

// Universe
constant symbol U : 𝔖 → TYPE;
symbol El (l : 𝔖) (A : U l) : TYPE;

// codes for universes
constant symbol u (l : 𝔖) : U (𝔄 l);
rule El _ (u $l) ↪ U $l;


// codes for dependent products
symbol π (l₀ l₁ l₂ : 𝔖) (A : U (l₀ + l₁)) (B : El (l₀ + l₁) A → U (l₀ + l₂)) : U (𝔑 (l₀ + l₁) (l₀ + l₂));
rule El _ (π $l₀ $l₁ $l₂ $A (λ x : _, $B.[x])) ↪ Π x : El ($l₀ + $l₁) $A, El ($l₀ + $l₂) $B.[x];

rule π $l0 (S $l1) (S $l2) $A $B ↪ π (S $l0) $l1 $l2 $A $B;


// Encoding of telescopes
constant symbol Tele : TYPE;
constant symbol ⋄ : Tele;
symbol ◁ (l : 𝔖) (A : U l) (a : El l A → Tele) : Tele;

symbol ⇒ (Δ : Tele) (l : 𝔖) : TYPE;
notation ⇒ infix 5;
rule ⋄                            ⇒ $l₁ ↪ U $l₁;
rule (◁ $l₂ $A (λ x : _, $Δ.[x])) ⇒ $l₁ ↪ Π x : El $l₂ $A, $Δ.[x] ⇒ $l₁;


// lift
symbol ↑ (l : 𝔖) (Δ : Tele) (t : Δ ⇒ l) : Δ ⇒ (S l);
rule El $l (↑ _ ⋄ $A) ↪ El (P $l) $A;

rule ◁ $l (↑ _ ⋄ $A) $Δ ↪ ◁ (P $l) $A $Δ;


// ↑ (λ x, t) ↪ λ x, ↑ t
rule ↑ $l (◁ _ _ (λ x : _,$Δ.[x])) (λ x : $A, $t.[x])   ↪ λ x : $A, ↑ $l $Δ.[x] $t.[x];
// (↑ t) u    ↪ ↑ (t u)
rule ↑ $l (◁ _ _ (λ x : _,$Δ.[x])) $t $u                ↪ ↑ $l $Δ.[$u] ($t $u);


symbol ⇑ (l : 𝔖) (A : U 0) : U l;
rule ⇑ 0      $A ↪ $A;
rule ⇑ (S $l) $A ↪ ↑ $l ⋄ (⇑ $l $A);

rule El $l₂ (⇑ $l₁ $A) ↪ El ($l₂ - $l₁) $A;


rule π 0           (S $l)  0       (↑ _ ⋄ $A) $B                       ↪                      π 0       $l      0       $A $B;
rule π (S $l₁)     0       $l₂     (↑ _ ⋄ $A) $B                       ↪                      π $l₁     0       (S $l₂) $A $B;
rule π (S $l₁)     (S $l₂) 0       (↑ _ ⋄ $A) $B                       ↪ ↑ (S ($l₁ + $l₂)) ⋄ (π (S $l₁) $l₂     0       $A $B);

rule π (S (S $l₁)) $l₂     0       $A         (λ x : $C, ↑ _ ⋄ $B.[x]) ↪                      π (S $l₁) (S $l₂) 0       $A (λ x : $C, $B.[x]);
rule π $l₁         0       (S $l₂) $A         (λ x : $C, ↑ _ ⋄ $B.[x]) ↪ ↑ ($l₁ + $l₂) ⋄     (π $l₁     0       $l₂     $A (λ x : $C, $B.[x]));
rule π (S 0)       $l      0       $A         (λ x : $C, ↑ _ ⋄ $B.[x]) ↪ ⇑ (S $l)            (π 0       (S $l)  0       $A (λ x : $C, $B.[x]));
