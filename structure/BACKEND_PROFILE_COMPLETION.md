# Backend — Complétion obligatoire du profil patient

Objectif: après inscription / première connexion, un patient doit **renseigner obligatoirement**:

- `first_name`
- `last_name`
- `phone`
- `email` (doit être non vide côté API, même si stocké côté Auth)
- `date_of_birth`
- `teudat_zehut` (numéro d'identité israélien)
- `kupat_holim` (Clalit / Maccabi / Leumit / Meuhedet / other)

Et **optionnellement**:

- `insurance_provider` (AIG, איילון, ביטוח חקלאי, דקלה, הראל, הכשרה, הפניקס, כלל, מגדל, מנורה, ביטוח ישיר, שירביט, שלמה, שומרה)

## État actuel côté API (selon `openapi.yaml`)

- `GET/PATCH /api/v1/profile` gère `first_name`, `last_name`, `phone`, `date_of_birth` (et renvoie aussi `email`, `role`, etc.)
- `GET/PUT /api/v1/health/profile` gère `teudat_zehut` et `kupat_holim` (et d'autres champs de santé)

Le frontend force maintenant un wizard obligatoire tant que ces champs ne sont pas complétés.

## Changements DB requis (Supabase / Postgres)

Ajouter une colonne optionnelle pour l'assurance privée:

```sql
alter table public.health_profiles
add column if not exists insurance_provider text;
```

Optionnel mais recommandé:

- index si vous filtrez/reportez dessus (sinon inutile)
- normaliser `kupat_holim` (enum/check constraint) si vous voulez éviter des valeurs libres

## Changements API requis

### `PUT /api/v1/health/profile`

- Accepter le champ JSON `insurance_provider` (nullable).
- L'upsert doit écrire `insurance_provider` dans `public.health_profiles.insurance_provider`.

### `GET /api/v1/health/profile`

- Retourner `insurance_provider` dans la réponse.

### `GET /api/v1/profile`

Assurez-vous que:

- `email` est **toujours** présent (non vide) pour l'utilisateur courant.
  - Si `public.profiles.email` peut être `NULL`, alors:
    - soit synchroniser `profiles.email` depuis `auth.users.email` via trigger,
    - soit faire un fallback côté API (ex: sélectionner `auth.users.email` si `profiles.email` est null).

## Sécurité — Teudat Zehut

Le frontend envoie `teudat_zehut` en clair à l'API (TLS).

Recommandé côté backend:

- stocker **chiffré** (`teudat_zehut_encrypted`) + éventuellement **hash** (pour dédup/recherche sans déchiffrer)
- éviter de logger le champ en clair
- sur `GET /api/v1/health/profile`, si vous renvoyez `teudat_zehut` déchiffré, valider que c'est bien nécessaire

## (Optionnel) Endpoint de complétude

Pour simplifier le frontend et éviter 2 appels, vous pouvez ajouter:

- `GET /api/v1/profile/completion`
  - réponse: `{ is_complete: boolean, missing: string[] }`

